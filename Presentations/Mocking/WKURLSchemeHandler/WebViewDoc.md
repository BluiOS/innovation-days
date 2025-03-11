# **Understanding `WKURLSchemeHandler` in Swift**

## **1. What is `WKURLSchemeHandler`?**
`WKURLSchemeHandler` is part of WebKit and allows developers to handle custom URL schemes inside a `WKWebView`. This means that instead of making a traditional network request, `WKWebView` can intercept requests and return custom responses.

### **Why Use `WKURLSchemeHandler`?**
✅ **Intercept Web Requests** – Serve local or mock data without making a real network call.  
✅ **Offline Support** – Load cached content when offline.  
✅ **Security** – Prevent `WKWebView` from accessing certain external resources.  
✅ **Custom Protocols** – Implement `custom://` or `app://` schemes for internal app communication.  

---

## **2. Creating a Custom WKURLSchemeHandler**
Let’s create a `WKURLSchemeHandler` that serves mock data for a **custom scheme (`mock://`)**.

### **Step 1: Create a Custom Scheme Handler**
We subclass `WKURLSchemeHandler` and override the request handling methods.

```swift
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
```

---

### **Step 2: Register Custom Scheme in `WKWebViewConfiguration`**
Now, we configure `WKWebView` to use our **custom scheme handler (`mock://`)**.

```swift
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
```

---

## **3. How it Works**
1. **The WebView loads an HTML page** with JavaScript that fetches `mock://data` and `mock://image`.
2. **`WKURLSchemeHandler` intercepts the request**, recognizes the mock URLs, and returns predefined responses.
3. **The WebView displays mock data** and images without ever making a real network request.

---

## **4. Advanced Features**
### **🔹 Dynamic Mock Data**
Modify `MockSchemeHandler` to return different responses based on the requested URL.

```swift
let urlString = url.absoluteString
if urlString.contains("mock://user/") {
    let userId = urlString.replacingOccurrences(of: "mock://user/", with: "")
    responseData = """
    {
        "id": \(userId),
        "name": "User \(userId)"
    }
    """.data(using: .utf8)!
}
```

Now, `mock://user/1` returns:
```json
{
    "id": 1,
    "name": "User 1"
}
```

---

### **🔹 Serving Local Files**
You can serve static HTML, CSS, and JavaScript from the app bundle.

```swift
if let filePath = Bundle.main.path(forResource: "index", ofType: "html") {
    responseData = try! Data(contentsOf: URL(fileURLWithPath: filePath))
}
```

---

### **🔹 Handling HTTP-like Requests**
You can simulate REST API endpoints using `URLComponents`.

```swift
if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
   components.path == "/products" {
    responseData = """
    [
        {"id": 1, "name": "MacBook"},
        {"id": 2, "name": "iPhone"}
    ]
    """.data(using: .utf8)!
}
```

Now, `fetch('mock://products')` in JavaScript returns:
```json
[
    {"id": 1, "name": "MacBook"},
    {"id": 2, "name": "iPhone"}
]
```

---

## **5. When to Use `WKURLSchemeHandler`?**
| **Use Case**                 | **`WKURLSchemeHandler` is Suitable?** |
|------------------------------|--------------------------------------|
| Mocking API responses in WebView | ✅ Yes |
| Serving local HTML, CSS, JS files | ✅ Yes |
| Offline mode for WebView        | ✅ Yes |
| Global request interception (all network calls) | ❌ No (Use `URLProtocol` instead) |
| Debugging & network logging    | ❌ No (Use Proxy tools like Charles) |

---

## **6. Conclusion**
`WKURLSchemeHandler` is **a powerful way to handle custom web requests in `WKWebView`**. It allows you to:
✅ **Mock API responses** for testing.  
✅ **Serve local content** (HTML, images, JSON) without needing a real server.  
✅ **Support offline browsing** by intercepting network calls.  

### **Next Steps?**
- 🔹 Try adding more mock endpoints (`mock://products`, `mock://user/2`).
- 🔹 Load CSS and JavaScript dynamically via `WKURLSchemeHandler`.
- 🔹 Implement caching for offline browsing.  
