//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Mohamed Arafa on 02/07/2026.
//

import Foundation

enum HTTPClientResult {
    case success(HTTPURLResponse)
    case failure(Error)
}

typealias HTTPClientResultCompletion = (HTTPClientResult) -> Void

protocol HTTPClient {
    func get(from url: URL, completion: @escaping HTTPClientResultCompletion)
}

final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    enum Error: Swift.Error {
        case invalidURL
        case invalidData
        case connectivity
    }
    
    init(url: URL = URL(string: "https://dummy.com")!, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping HTTPClientResultCompletion) {
        client.get(from: url) { result in
            switch result {
            case .success(let response):
//                completion(.success(response))
                completion(.failure(Error.invalidData))
            case .failure:
                completion(.failure(Error.connectivity))
            }
            
        }
    }
}
