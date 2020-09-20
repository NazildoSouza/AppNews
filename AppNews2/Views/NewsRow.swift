//
//  NewsRow.swift
//  AppNews2
//
//  Created by Nazildo Souza on 19/09/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewRow: View {
    var article: News.Articles
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading) {
                
                Text(article.title ?? "")
                    .fontWeight(.heavy)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                
                Text(article.description ?? "")
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
            }
            
            Spacer()
            
            AnimatedImage(url: URL(string: article.urlToImage ?? ""))
                .resizable()
                .placeholder {
                    ZStack {
                        Rectangle().foregroundColor(Color(.systemGray4))
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 85, height: 75)
                            .foregroundColor(.secondary)
                    }
                }
                .indicator(SDWebImageActivityIndicator.medium)
                .scaledToFill()
                .frame(width: 120, height: 135)
                .cornerRadius(20)
            
        }
        .padding(.vertical, 15)
    }
}

