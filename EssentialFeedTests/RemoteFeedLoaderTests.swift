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
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataTwiceFromURL() {
        let url = URL(string: "https://a-dummy.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load {_  in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_deliversErrorOnClientError() throws {
        let (sut, client) = makeSUT()
        
        try expect(sut, toCompleteWith: .connectivity) {
            let clientError = NSError(domain: "Test Error", code: 0) as Error
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() throws {
        let (sut, client) = makeSUT()
        let statusSamples = [199, 201, 300, 400, 500]
        
        try statusSamples.enumerated().forEach { index, status in
            try expect(sut, toCompleteWith: .invalidData) {
                client.complete(withStatucCode: 400, at: index)
            }
        }
    }
    
    func test_load_deliverErrorOn200HTTPResponseWithInvalidJSON() throws {
        let (sut, client) = makeSUT()
        try expect(sut, toCompleteWith: .invalidData) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatucCode: 200, data: invalidJSON)
        }
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://dummy.com")!) -> (sut: RemoteFeedLoader,
                                                                           client: HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut: sut, client: client)
    }
    
    private func expect(_ sut: RemoteFeedLoader,
                        toCompleteWith error: RemoteFeedLoader.Error,
                        when action: (() -> Void),
                        file: StaticString = #filePath,
                        line: UInt = #line) throws {
        var resultError: Error?
        var capturedError = [RemoteFeedLoader.Error]()
        
        sut.load { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                resultError = error
            }
        }
        
        action()
        
        let wrappedResultError = try XCTUnwrap(resultError as? RemoteFeedLoader.Error, file: file, line: line)
        capturedError.append(wrappedResultError)
        XCTAssertEqual(capturedError, [error], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL,
                                 completion: HTTPClientResultCompletion)]()
        
        func get(from url: URL,
                 completion: @escaping HTTPClientResultCompletion) {
            messages.append((url: url, completion: completion))
        }
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func complete(with error: Error,
                      at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatucCode code: Int,
                      at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(Data(), response))
        }
        
        func complete(withStatucCode code: Int,
                      data: Data = Data(),
                      at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
