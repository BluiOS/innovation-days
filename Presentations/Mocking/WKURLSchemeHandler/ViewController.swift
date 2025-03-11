//
//  ViewController.swift
//  MockDataPresentation
//
//  Created by Hossein Hajimirza on 3/11/25.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure WebView
        let config = WKWebViewConfiguration()
        config.setURLSchemeHandler(MockSchemeHandler(), forURLScheme: "mock")

        webView = WKWebView(frame: view.bounds, configuration: config)
        view.addSubview(webView)

        // Load mock data in WebView
        loadMockHTML()
    }

    func loadMockHTML() {
        let htmlString = """
        <html>
        <body>
            <h1>Mock Data Example</h1>
            <p>Fetching data from <b>mock://data</b>...</p>
            <pre id="jsonData">Loading...</pre>
            <script>
                fetch('mock://data')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('jsonData').textContent = JSON.stringify(data, null, 2);
                });
            </script>
            <br>
            <p>Mock Image:</p>
            <img src="mock://image" width="100">
        </body>
        </html>
        """

        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}
