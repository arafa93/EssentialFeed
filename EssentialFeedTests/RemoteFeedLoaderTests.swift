//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Mohamed Arafa on 02/07/2026.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-dummy.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "Test Error", code: 0)
        
        var capturedError: RemoteFeedLoader.Error?
        sut.load { error in
            capturedError = error
        }
        
        XCTAssertEqual(capturedError, .connectivity)
        XCTAssertEqual(client.error?.localizedDescription, RemoteFeedLoader.Error.connectivity.localizedDescription)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://dummy.com")!) -> (sut: RemoteFeedLoader,
                                                                           client: HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut: sut, client: client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        var error: Error?
        
        func get(from url: URL, completion: ((Error) -> Void)? = nil) {
            if let error {
                completion?(error)
            }
            requestedURL = url
        }
    }
}
