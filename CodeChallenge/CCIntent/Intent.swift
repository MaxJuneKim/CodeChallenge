//
//  Intent.swift
//  Code Challenge
//
//  Created by Youngjoon Kim on 8/23/24.
//

import Foundation
import Combine

class VMIntent: ObservableObject {
    
    @Published var model: ImageViewModel
    @Published var queryStr = ""
    @Published var inProgress: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    init(model: ImageViewModel) {
        self.model = model
        self.$queryStr.removeDuplicates()
            .debounce(for: .seconds(0.8), scheduler: DispatchQueue.main)
            .sink { value in
                if !value.isEmpty {
                    Task.init {
                        await self.search(query: value)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func search(query: String) async {
        // Make URL for the API request. If the url is not valid, it should not trigger any API request
        guard let url = URL(string: api + query) else {
            return
        }
        
        Task.init { @MainActor in // Clearing the array for the result of new query
            inProgress = true
            model.photoItems.removeAll()
        }
        
        // Making API request
        let request = URLRequest(url: url)
        let responseResult: Result<Flickr, Error> = await HTTPClient.shared.requestAndDecode(request: request)
        
        switch responseResult {
        case .success(let response): // If the API request was successful, append the data to the model.
            guard let images = response.items else { return }
            
            
            let items = await withTaskGroup(of: Void.self, returning: [BusinessPhoto].self) { taskGroup in
                var imagesItem: [BusinessPhoto] = []
                for image in images { // iterating through items array of the response
                    if let myImage = busImage(image: image) {
                        imagesItem.append(myImage)
                        
                        taskGroup.addTask { // Download images asynchronously with taskGroup.
                            guard let imageUrl =  URL(string: myImage.imageLink) else { return }
                            let imgRequest = URLRequest(url: imageUrl)
                            let imageResult = await HTTPClient.shared.requestRaw(request: imgRequest) // Fetching image data.
                            
                            switch imageResult {
                            case .success(let imgData): // if the fetching was successful, store it in the cahe.
                                self.model.imageCache.setObject(imgData as NSData, forKey: myImage.imageLink as NSString)
                            case .failure(let error):
                                print(error)
                                return
                            }
                        }
                    }
                }
                
                return imagesItem
            }
        
            // Update the model.
            Task.init { @MainActor in
                inProgress = false
                self.model.photoItems.append(contentsOf: items)
            }
            
        case .failure: // If the API request was unsuccessful
            Task.init { @MainActor in
                inProgress = false
            }
            return
        }
    }
    
    // This function makes sure all the necessary fields are present
    private func busImage(image: ImageItem) -> BusinessPhoto? {
        guard let title = image.title,
              let description = image.description,
              let link = image.link,
              let date = image.dateTaken,
              let author = image.author,
              let imageLink = image.media?.m else {
            return nil
        }
                
        return BusinessPhoto(title: title, description: description, link: link, date: date, author: author, imageLink: imageLink)
    }
}
