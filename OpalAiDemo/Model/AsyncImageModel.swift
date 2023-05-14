//
//  AsyncImageModel.swift
//  OpalAiDemo
//
//  Created by Lei Chen on 5/15/23.
//


import Foundation
import SwiftUI
import Kingfisher

struct AsyncImage: View {
    let url: URL?

    init(urlString: String) {
        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encoded) {
            self.url = url
        } else {
            self.url = nil
        }
    }

    var body: some View {
        KFImage(url)
            .resizable()
            .onFailure { error in
                print(error.localizedDescription)
            }
            .placeholder {
                Image(systemName: "photo")
                    .resizable()
                    .padding(50)
                    .foregroundColor(.gray)
            }
            .fade(duration: 0.5)
            .aspectRatio(contentMode: .fit)
    }
}
