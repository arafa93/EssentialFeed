//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Mohamed Arafa on 02/07/2026.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL, completion: ((Error?, HTTPURLResponse?) -> Void)?)
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
    
    func load(completion: ((Error?) -> Void)?) {
        client.get(from: url) { error, response in
            completion?(response != nil ? .invalidData : .connectivity)
        }
    }
}
