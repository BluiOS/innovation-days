//
//  MockSchemeHandler.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import Foundation
import WebKit

class MockSchemeHandler: NSObject, WKURLSchemeHandler {
    // Handle the start of a request
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else { return }

        // Prepare mock data based on URL
        let responseData: Data
        let mimeType: String

        if url.absoluteString == "mock://data" {
            responseData = """
            {
                "message": "Hello from mock API!"
            }
            """.data(using: .utf8)!
            mimeType = "application/json"
        } else if url.absoluteString == "mock://image" {
            responseData = UIImage(systemName: "star.fill")!.pngData()!
            mimeType = "image/png"
        } else {
            responseData = "Page Not Found".data(using: .utf8)!
            mimeType = "text/plain"
        }

        // Create HTTP-like response
        let response = URLResponse(
            url: url,
            mimeType: mimeType,
            expectedContentLength: responseData.count,
            textEncodingName: "utf-8"
        )

        // Send response
        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(responseData)
        urlSchemeTask.didFinish()
    }

    // Handle request cancellation (if needed)
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        // No special cleanup needed
    }
}
