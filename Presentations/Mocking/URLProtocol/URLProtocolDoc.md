# Understanding URLProtocol in Swift

## 1. Introduction to URLProtocol

`URLProtocol` is a powerful part of Apple’s Foundation framework that allows developers to intercept and modify network requests made using `URLSession`. It enables custom handling of HTTP requests and responses, making it useful for mocking network responses, logging, caching, or implementing custom authentication mechanisms.

## 2. Why Use URLProtocol?

### 2.1. Mocking Network Requests
- Simulate API responses without making real network calls.
- Useful for unit and UI testing.

### 2.2. Request and Response Inspection
- Log network requests and responses for debugging purposes.

### 2.3. Custom Authentication Handling
- Intercept requests to inject custom headers or tokens.

### 2.4. Caching and Offline Mode
- Serve pre-cached responses when offline or for performance improvements.

## 3. Implementing a Custom URLProtocol

### 3.1. Subclassing URLProtocol
To use `URLProtocol`, create a subclass and override key methods:

```swift
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
        // Simulated response
        let mockResponse = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )!
        
        let mockData = "{\"message\": \"Success\"}".data(using: .utf8)!
        
        // Sending mock response
        client?.urlProtocol(self, didReceive: mockResponse, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: mockData)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // No need to implement for mock responses
    }
}
```

### 3.2. Registering URLProtocol in URLSession

To use `MockURLProtocol`, register it with a `URLSessionConfiguration`:

```swift
let config = URLSessionConfiguration.default
config.protocolClasses = [MockURLProtocol.self]
let session = URLSession(configuration: config)
```

Now, any request made with this `session` will be intercepted by `MockURLProtocol`.

## 4. Advanced Use Cases

### 4.1. Mocking API Responses Based on Request
Modify `startLoading()` to return different responses based on the request URL:

```swift
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
```

### 4.2. Adding Custom Headers
Modify requests by injecting headers before they are sent:

```swift
override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    var modifiedRequest = request
    modifiedRequest.addValue("Bearer mockToken", forHTTPHeaderField: "Authorization")
    return modifiedRequest
}
```

### 4.3. Logging Network Requests
Log all outgoing network requests for debugging:

```swift
override func startLoading() {
    print("Intercepted request: \(request.url?.absoluteString ?? "Unknown URL")")
    super.startLoading()
}
```

### 4.4. Handling Offline Mode
Return cached data when offline:

```swift
override func startLoading() {
    if !isConnectedToInternet() {
        let cachedResponse = loadCachedData(for: request.url!)
        client?.urlProtocol(self, didReceive: cachedResponse, cacheStoragePolicy: .allowed)
        client?.urlProtocol(self, didLoad: cachedResponse.data)
    } else {
        super.startLoading()
    }
}
```

## 5. Unit Testing with URLProtocol

To use `MockURLProtocol` in unit tests:

```swift
import XCTest
@testable import YourApp

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
```

## 6. Conclusion

`URLProtocol` is a powerful tool in Swift that allows developers to intercept, modify, and mock network requests. It is particularly useful for testing, debugging, and implementing custom networking behavior without modifying the core networking logic. By mastering `URLProtocol`, developers can create more efficient and flexible network handling in their applications.
