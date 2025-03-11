## **1. NSURLSessionDelegate**
- Provides hooks to modify requests and responses within `URLSession`.
- Used mainly for authentication handling, request modification, and response validation.  
- Cannot intercept all requests globally like `URLProtocol`, but works well for modifying requests at the session level.

### **Example: Modifying a Request Before Sending**
```swift
class CustomSessionDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        var modifiedRequest = request
        modifiedRequest.addValue("Custom-Header-Value", forHTTPHeaderField: "Custom-Header")
        completionHandler(modifiedRequest)
    }
}

let config = URLSessionConfiguration.default
let session = URLSession(configuration: config, delegate: CustomSessionDelegate(), delegateQueue: nil)
```

**Use case:** Modify requests dynamically before they are sent, such as adding headers or handling redirects.

---

## **2. WKURLSchemeHandler (For WebKit & WKWebView)**
- Used to intercept network requests within `WKWebView`.
- Can handle custom URL schemes (e.g., `myapp://`) and provide responses directly.
- Only applies to web content, not general network requests.

### **Example: Handling Custom Scheme Requests in WebView**
```swift
import WebKit

class CustomSchemeHandler: NSObject, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        let responseData = "Hello from custom scheme!".data(using: .utf8)!
        let response = URLResponse(url: urlSchemeTask.request.url!, mimeType: "text/plain", expectedContentLength: responseData.count, textEncodingName: "utf-8")

        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(responseData)
        urlSchemeTask.didFinish()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        // No special stop behavior needed
    }
}

let config = WKWebViewConfiguration()
config.setURLSchemeHandler(CustomSchemeHandler(), forURLScheme: "customscheme")
let webView = WKWebView(frame: .zero, configuration: config)
```

**Use case:** Serve local content or mock responses in web-based apps.

---

## **3. Proxy Servers (Charles Proxy, mitmproxy)**
- External tools like **Charles Proxy** or **mitmproxy** act as network intermediaries.
- Can intercept, modify, and replay network requests globally across apps.
- Requires manual setup and cannot be embedded directly within an app.

### **Example Use Cases**
- Debugging and inspecting API calls in real-time.
- Modifying requests for testing without changing app code.
- Simulating slow networks or failed requests.

---

## **4. Custom URL Loading Systems (Alamofire Interceptors)**
- **Alamofire**, a popular Swift networking library, has **request interceptors** similar to `URLProtocol`.
- Allows modifying, retrying, or rejecting requests before they are sent.

### **Example: Alamofire Request Interceptor**
```swift
import Alamofire

class CustomInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var modifiedRequest = urlRequest
        modifiedRequest.addValue("Bearer myAccessToken", forHTTPHeaderField: "Authorization")
        completion(.success(modifiedRequest))
    }
}

let session = Session(interceptor: CustomInterceptor())
session.request("https://api.example.com/data").responseJSON { response in
    print(response)
}
```

**Use case:** Inject authentication tokens, modify headers, or handle retries in networking requests.

---

## **5. NSURLProtocol (macOS Only)**
- `NSURLProtocol` (older Objective-C API) works similarly to `URLProtocol` but is limited to macOS.
- Used for intercepting network traffic at a system level in older macOS applications.

---

### **📌 Summary Table: Comparing Alternatives**
| API                    | Scope                   | Use Case | Supports Mocking? |
|------------------------|------------------------|----------------------------------|------------------|
| **URLProtocol**        | System-wide (App)       | Mocking, logging, custom handling | ✅ Yes |
| **NSURLSessionDelegate** | Per URLSession instance | Authentication, redirect handling | ❌ No |
| **WKURLSchemeHandler**  | Web content (WKWebView) | Custom URL schemes for web apps | ✅ Yes (for web) |
| **Proxy Servers**       | External tool (All apps) | API debugging, interception | ✅ Yes (global) |
| **Alamofire Interceptors** | Alamofire-specific | Request modification, retry logic | ✅ Yes |

---

### **When to Use What?**
- **For unit tests and API mocking:** `URLProtocol`
- **For modifying network requests dynamically in app:** `NSURLSessionDelegate` or `Alamofire Interceptors`
- **For web-based apps:** `WKURLSchemeHandler`
- **For debugging and intercepting traffic outside the app:** Proxy tools (Charles, mitmproxy)
