//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Mohamed Arafa on 03/07/2026.
//

import Foundation

typealias HTTPClientResultCompletion = (HTTPClientResult) -> Void

enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

protocol HTTPClient {
    func get(from url: URL, completion: @escaping HTTPClientResultCompletion)
}
