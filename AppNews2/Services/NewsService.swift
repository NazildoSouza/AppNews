//
//  NewsService.swift
//  AppNews2
//
//  Created by Nazildo Souza on 18/09/20.
//

import Foundation

protocol NewsService {
    func fetchNewsSearch(query: String, endPoint: NewsEndPoint, page: String, completion: @escaping (Result<News, MovieError>) -> ())
    func fetchNews(endPoint: NewsEndPoint, page: String, completion: @escaping (Result<News, MovieError>) -> ())
}

enum NewsEndPoint: String, CaseIterable {
    case topHeadlines = "top-headlines"
    case everything = "everything"
}

enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Falha ao buscar Dados"
        case .invalidEndpoint: return "Endpoint Inválido"
        case .invalidResponse: return "Resposta Inválida"
        case .noData: return "Sem Dados"
        case .serializationError: return "Falhou ao decodificar Dados"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}

