//
//  CCFlickr.swift
//  Code Challenge
//
//  Created by Youngjoon Kim on 8/23/24.
//

import Foundation

struct Flickr: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case description
        case modified
        case generator
        case items
    }
    
    let title: String?
    let link: String?
    let description: String?
    let modified: Date?
    let generator: String?
    let items: [ImageItem]?
}

struct ImageItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case media
        case dateTaken = "date_taken"
        case description
        case published
        case author
        case authorId = "author_id"
        case tags
    }
    
    let title: String?
    let link: String?
    let media: Media?
    let dateTaken: Date?
    let description: String?
    let published: Date?
    let author: String?
    let authorId: String?
    let tags: String?
}

struct Media: Decodable {
    let m: String?
}
