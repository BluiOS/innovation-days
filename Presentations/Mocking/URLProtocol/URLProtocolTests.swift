//
//  URLProtocolTests.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation
import XCTest

class NetworkTests: XCTestCase {
    func testMockAPIResponse() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        let url = URL(string: "https://api.example.com/test")!
        let expectation = self.expectation(description: "Mock API Call")

        let task = session.dataTask(with: url) { data, response, error in
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        task.resume()

        wait(for: [expectation], timeout: 2.0)
    }
}
