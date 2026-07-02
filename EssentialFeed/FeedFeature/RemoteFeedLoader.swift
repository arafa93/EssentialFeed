//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Mohamed Arafa on 02/07/2026.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public init(url: URL = URL(string: "https://dummy.com")!, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
}
