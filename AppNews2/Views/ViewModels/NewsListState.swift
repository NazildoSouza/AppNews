//
//  NewsListState.swift
//  AppNews2
//
//  Created by Nazildo Souza on 19/09/20.
//

import Foundation

class NewsListState: ObservableObject {
    @Published var news: [News.Articles]?
    @Published var isLoading: Bool = false
    @Published var error: NSError?
    @Published var page = 1
    @Published var total = 0
    @Published var atualPages = 0
    @Published var pageUpOrDown = true
    
    private let newsService: NewsService
    
    var isNewsCount: Bool {
        self.isLoading == false && self.news != nil && !self.news!.isEmpty
    }
    
    var isTotalPages: Bool {
        self.atualPages < 100 && self.atualPages < self.total
    }
    
    init(newsService: NewsService = NewsStore.shared) {
        self.newsService = newsService
    }
    
    func loadNews(witch endPoint: NewsEndPoint) {
        self.news = nil
        self.isLoading = false
        self.error = nil
        
        self.isLoading = true
        
        self.newsService.fetchNews(endPoint: endPoint, page: String(page)) { [weak self] (result) in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let response):
                self.news = response.articles
                self.total = response.totalResults
                if self.pageUpOrDown {
                    self.atualPages += response.articles.count
                } else {
                    self.atualPages -= response.articles.count
                }
                print("carregando noticias: \(String(describing: self.news?.count)) total: \(self.total)")
                print("atual pages \(self.atualPages)")
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}

