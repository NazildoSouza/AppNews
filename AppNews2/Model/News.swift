//
//  News.swift
//  AppNews2
//
//  Created by Nazildo Souza on 19/09/20.
//

import Foundation

struct News: Codable {
    let status: String
    let totalResults: Int
    let articles: [Articles]
    
    struct Articles: Codable, Identifiable {
        let id: String?
        let title: String?
        let description: String?
        let url: URL?
        let urlToImage: String?
     //   let publishedAt: String?
        let content: String?
        
        enum CodingKeys: String, CodingKey {
            case id = "publishedAt"
            case title, description, url, urlToImage, content
        }
    }
}
