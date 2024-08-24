//
//  Model.swift
//  Code Challenge
//
//  Created by Youngjoon Kim on 8/24/24.
//

import Foundation

//
struct BusinessPhoto {
    var title: String
    var description: String
    var link: String
    var date: Date
    var author: String
    var imageLink: String
}

class ImageViewModel: ObservableObject {
    @Published var photoItems: [BusinessPhoto] = []
    var imageCache = NSCache<NSString, NSData>()
    var count: Int = 0
    
    func getImage(link: String) -> Data? {
        return imageCache.object(forKey: link as NSString) as? Data
    }
}
