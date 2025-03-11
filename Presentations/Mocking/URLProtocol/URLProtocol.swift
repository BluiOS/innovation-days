//
//  URLProtocol.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation

class MockURLProtocol: URLProtocol {
    // Determines if this protocol should handle the request
    override class func canInit(with request: URLRequest) -> Bool {
        return true // Intercepts all requests
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        let mockResponse: HTTPURLResponse
        let mockData: Data

        if request.url?.absoluteString.contains("/users") == true {
            mockResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            mockData = "{\"users\": [{\"id\": 1, \"name\": \"John Doe\"}]}".data(using: .utf8)!
        } else {
            mockResponse = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            mockData = "{\"error\": \"Not found\"}".data(using: .utf8)!
        }

        client?.urlProtocol(self, didReceive: mockResponse, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: mockData)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // No need to implement for mock responses
    }
}
