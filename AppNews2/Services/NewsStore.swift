//
//  NewsStore.swift
//  AppNews2
//
//  Created by Nazildo Souza on 19/09/20.
//

import Foundation

class NewsStore: NewsService {
    
    static let shared = NewsStore()
    private init() {}
    
    private let apiKeyKav = "8468d3e24f614f959062cd9645b04e9d"
    private let apiKey = "ef11fe53da4647279b7cd9f2b72bf003"
    private let baseApiURL = "https://newsapi.org/v2"
    private let urlSession = URLSession.shared
    
    func fetchNewsSearch(query: String, endPoint: NewsEndPoint, page: String, completion: @escaping (Result<News, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseApiURL)/\(endPoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadURLAndDecode(url: url, params: [
            "q": query,
            "page": page,
            "pageSize": "30",
            "sortBy": "popularity",
            "language": "pt"
        ], completion: completion)
    }
    
    func fetchNews(endPoint: NewsEndPoint, page: String, completion: @escaping (Result<News, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseApiURL)/\(endPoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadURLAndDecode(url: url, params: [
            "page": page,
            "pageSize": "30",
            "category": "technology",
            "country": "br"
        ], completion: completion)
    }
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "apiKey", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value)})
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        print(finalURL)
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else {return}
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedResponde = try jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponde), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
                print(error)
            }
            
        }.resume()
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping (Result<D, MovieError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
