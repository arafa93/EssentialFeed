//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Mohamed Arafa on 03/07/2026.
//

import XCTest

final class URLSessionHTTPClient {

    private let session: HTTPClientSession

    init(session: HTTPClientSession = URLSession.shared) {
        self.session = session
    }
    
    func get(from url: URL) {
        let task = session.dataTask(with: url) { _, _, _ in }
        task.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_performsGETRequestWithURL() {
        let url = URL(string: "https://www.google.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    //MARK: - Helper
    
    private final class URLSessionSpy: HTTPClientSession {
        var receivedURLs = [URL]()
        
        func dataTask(
            with url: URL,
            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
        ) -> HTTPClientSessionDataTask {
            receivedURLs.append(url)
            
            return DataTaskSpy()
        }
    }

    private final class DataTaskSpy: HTTPClientSessionDataTask {
        func resume() {}
    }
}

protocol HTTPClientSession {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> HTTPClientSessionDataTask
}

protocol HTTPClientSessionDataTask {
    func resume()
}

extension URLSessionDataTask: HTTPClientSessionDataTask {}

extension URLSession: HTTPClientSession {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> HTTPClientSessionDataTask {
        dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
}
