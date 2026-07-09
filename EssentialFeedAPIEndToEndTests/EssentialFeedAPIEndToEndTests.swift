//
//  EssentialFeedAPIEndToEndTests.swift
//  EssentialFeedAPIEndToEndTests
//
//  Created by Mohamed Arafa on 09/07/2026.
//

import XCTest
@testable import EssentialFeed

final class EssentialFeedAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGetFeedResult_matchesFixedAccountData() {
        switch getFeedResult() {
        case let .success(feed)?:
            XCTAssertEqual(feed.count, 8, "Expected 8 items in the test feed")
            
            
            
        case let .failure(error)?:
            XCTFail("Expected successful feed result but got: \(error) instead")
        default:
            XCTFail("Expected successful feed result, but got no result at all")
        }
    }
    
    //MARK: - Helpers
    
    private func getFeedResult() -> RemoteFeedLoader.Result? {
        let url = URL(string: "https://essentialdeveloper.com/feed-case-study/test-api/feed")!
        let client = URLSessionHTTPClient()
        let loader = RemoteFeedLoader(url: url, client: client)
        
        let exp = expectation(description: "waiting for result")
        
        var receivedResult: RemoteFeedLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
        return receivedResult
    }

}
