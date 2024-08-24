//
//  FullImageView.swift
//  Code Challenge
//
//  Created by Youngjoon Kim on 8/24/24.
//

import SwiftUI
import WebKit

struct FullImageView: View {
    
    var image: UIImage
    var imageDetails: BusinessPhoto
    
    var body: some View {
        VStack {
            Text("Title: \(imageDetails.title)")
                .foregroundStyle(.red)
            Text("Author: \(imageDetails.author)")
                .foregroundStyle(.blue)
            Text("Link: \(imageDetails.link)")
                .foregroundStyle(.green)
            Text("Date: \(formatDate(date: imageDetails.date))")
                .foregroundStyle(.yellow)
            Text("Description: \(imageDetails.description)")
                .foregroundStyle(.orange)
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding()
        }
    }
    
    init(image: UIImage, imageDetails: BusinessPhoto) {
        self.image = image
        self.imageDetails = imageDetails
    }
}


