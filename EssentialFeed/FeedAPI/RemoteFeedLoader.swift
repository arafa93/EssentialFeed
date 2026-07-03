//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Mohamed Arafa on 02/07/2026.
//

import Foundation

final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    enum Error: Swift.Error {
        case invalidURL
        case invalidData
        case connectivity
    }
    
    enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    init(url: URL = URL(string: "https://dummy.com")!, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
            
        }
    }
}
