//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Mohamed Arafa on 02/07/2026.
//

import Foundation

struct FeedItem: Decodable, Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
    
    init(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
    
    func getItemJSON() ->  [String: String] {
        let itemDec = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }
        
        return itemDec
    }
}

struct FeedItems: Decodable {
    let items: [Item]
}

struct Item: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
    
    var item: FeedItem {
        FeedItem(id: id, description: description, location: location, imageURL: image)
    }
}
