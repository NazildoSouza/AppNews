//
//  SearchNewsState.swift
//  AppNews2
//
//  Created by Nazildo Souza on 19/09/20.
//

import Foundation
import Combine

class NewsSearchState: ObservableObject {
    @Published var news: [News.Articles]?
    @Published var isLoading: Bool = false
    @Published var error: NSError?
    @Published var query = ""
    @Published var page = 1
    @Published var total = 0
    @Published var atualPages = 0
    @Published var pageUpOrDown = true
    
    private let newsService: NewsService
    private var subscriptionToken: AnyCancellable?
    
    var isEmptyResults: Bool {
        !self.query.isEmpty && self.news != nil && self.isLoading == false && self.news!.isEmpty
    }
    
    var isNewsCount: Bool {
        self.isLoading == false && self.news != nil && !self.news!.isEmpty
    }
    
    var isTotalPages: Bool {
        self.atualPages < 100 && self.atualPages < self.total && (self.atualPages + 30) < 100
    }
    
    init(newsService: NewsService = NewsStore.shared) {
        self.newsService = newsService
    }
    
    func startObserve() {
        guard subscriptionToken == nil else { return }

        self.subscriptionToken = self.$query
            .map { [weak self] text in
                self?.news = nil
                self?.error = nil
                self?.atualPages = 0
                return text

            }
            .throttle(for: 2, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] in self?.search(query: $0) }

    }
    
    func search(query: String) {
        self.isLoading = false
        self.news = nil
        self.error = nil
        
        guard !query.isEmpty else {
            return
        }
        
        self.isLoading = true
        
        self.newsService.fetchNewsSearch(query: query, endPoint: .everything, page: String(page)) { [weak self] (result) in
            guard let self = self, self.query == query else { return }
            
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
                print("carregando noticias: \(String(describing: self.news?.count))) total: \(self.total)")
                print("atual pages \(self.atualPages)")
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
    deinit {
        self.subscriptionToken?.cancel()
        self.subscriptionToken = nil
    }
}
