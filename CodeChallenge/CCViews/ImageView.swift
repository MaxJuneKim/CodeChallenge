//
//  ImageView.swift
//  Code Challenge
//
//  Created by Youngjoon Kim on 8/24/24.
//

import SwiftUI

struct ImageView: View {
    
    @StateObject var model: ImageViewModel
    @StateObject var intent: VMIntent
    
    var body: some View {
        GeometryReader { proxy in
            let dimension = min(proxy.size.width / 3 - 10, proxy.size.height / 3 - 10)
            let gridItems = [
                GridItem(.fixed(dimension)),
                GridItem(.fixed(dimension)),
                GridItem(.fixed(dimension))
            ]
            NavigationStack {
                VStack {
                    if intent.inProgress {
                        ProgressView()
                    } else {
                        ScrollView {
                            LazyVGrid (columns: gridItems) {
                                ForEach(model.photoItems, id: \.link) { photo in
                                    let imageData = model.getImage(link: photo.imageLink)
                                    if imageData != nil, let image = UIImage(data: imageData!) {
                                        NavigationLink {
                                            FullImageView(image: image, imageDetails: photo)
                                        } label: {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                        }
                                    } else {
                                        Image(systemName: "exclamationmark.triangle")
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }.searchable(text: $intent.queryStr)
            }
            
        }
    }
    
    init() {
        let model = ImageViewModel()
        self._model = StateObject(wrappedValue: model)
        
        let intent = VMIntent(model: model)
        self._intent = StateObject(wrappedValue: intent)
    }
}

#Preview {
    ImageView()
}
