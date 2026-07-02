//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Mohamed Arafa on 02/07/2026.
//

import XCTest
@testable import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-dummy.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataTwiceFromURL() {
        let url = URL(string: "https://a-dummy.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_deliversErrorOnClientError() throws {
        let (sut, client) = makeSUT()
        
        var capturedError = [RemoteFeedLoader.Error]()
        sut.load { capturedError.append($0) }
        
        let clientError = NSError(domain: "Test Error", code: 0) as Error
        
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedError, [.connectivity])
//        XCTAssertEqual(capturedError, <#T##expression2: Equatable##Equatable#>)
//        XCTAssertNotEqual(client.error?.localizedDescription, RemoteFeedLoader.Error.connectivity.localizedDescription)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://dummy.com")!) -> (sut: RemoteFeedLoader,
                                                                           client: HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut: sut, client: client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: ((Error) -> Void)?)]()
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func get(from url: URL, completion: ((Error) -> Void)? = nil) {
            messages.append((url: url, completion: completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion?(error)
        }
    }
}
