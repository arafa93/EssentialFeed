//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Mohamed Arafa on 03/07/2026.
//

import Foundation

internal final class FeedItemsMapper {
    private struct FeedItems: Decodable {
        let items: [Item]
    }
    
    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    private static var OK_200: Int { 200 }
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return try JSONDecoder().decode(FeedItems.self, from: data).items.map(\.item)
    }
}
