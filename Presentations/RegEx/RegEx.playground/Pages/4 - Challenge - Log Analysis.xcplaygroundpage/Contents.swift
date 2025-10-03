/*:
 [Previous: Swift Regex Builder](@previous)

 # Challenge: Log File Analysis

 **Challenge**: You're tasked with analyzing server log files to extract insights about system performance,
 error rates, and user activity. You need to parse various log formats and extract meaningful data.

 ## Sample Data

 Here's a realistic server log file with different types of entries:
 */

import Foundation

let serverLogs = """
2023-12-31 08:15:23.456 [INFO] WebServer: Request GET /api/users from 192.168.1.100 - Response 200 (45ms)
2023-12-31 08:15:24.123 [ERROR] DatabaseManager: Connection timeout to db01.example.com:5432 after 30000ms
2023-12-31 08:15:24.890 [WARNING] AuthService: Failed login attempt for user 'admin' from 10.0.0.15
2023-12-31 08:15:25.123 [INFO] WebServer: Request POST /api/login from 10.0.0.15 - Response 401 (12ms)
2023-12-31 08:15:26.456 [DEBUG] CacheService: Cache hit for key 'user_session_abc123' (0.5ms)
2023-12-31 08:15:27.789 [ERROR] PaymentProcessor: Transaction failed - CardID: 4567****1234, Amount: $99.99, Error: DECLINED
2023-12-31 08:15:28.012 [INFO] WebServer: Request GET /api/products/electronics from 203.0.113.45 - Response 200 (89ms)
2023-12-31 08:15:29.345 [WARNING] RateLimiter: Rate limit exceeded for IP 203.0.113.45 (100 requests in 60s)
2023-12-31 08:15:30.678 [CRITICAL] SystemMonitor: CPU usage at 95% - Threshold: 90%
2023-12-31 08:15:31.901 [INFO] WebServer: Request DELETE /api/users/12345 from 192.168.1.200 - Response 204 (23ms)
2023-12-31 08:15:32.234 [ERROR] EmailService: SMTP connection failed to mail.example.com:587 - Timeout after 15000ms
2023-12-31 08:15:33.567 [INFO] BackupService: Database backup completed - Size: 2.5GB, Duration: 45min
"""

/*:
 ## Challenge Tasks

 ### Task 1: Basic Log Parsing
 Extract all log entries and identify their components (timestamp, level, service, message).
 */

print("=== Task 1: Basic Log Parsing ===")

// TODO: Create a regex to parse log entries
// Expected format: TIMESTAMP [LEVEL] SERVICE: MESSAGE
// 💡 Hint: Use capture groups to extract timestamp, level, service, and message

struct LogEntry {
    let timestamp: String
    let level: String
    let service: String
    let message: String
}

var parsedLogs: [LogEntry] = []
let logLines = serverLogs.components(separatedBy: .newlines).filter { !$0.isEmpty }

// Your parsing code here...

print("Parsed \(parsedLogs.count) log entries")

/*:
 ### Task 2: Error Analysis
 Find all ERROR and CRITICAL level logs and categorize them by service.
 */

print("\n=== Task 2: Error Analysis ===")

// TODO: Filter parsedLogs for ERROR and CRITICAL levels, then group by service
// 💡 Hint: Use .filter{} to find errors, then Dictionary(grouping:by:) to group them

// Your code here...


/*:
 ### Task 3: Performance Metrics Extraction
 Extract response times, request methods, and status codes from WebServer logs.
 */

print("\n=== Task 3: Performance Metrics ===")

// TODO: Extract HTTP request details from WebServer logs
// 💡 Hint: Parse "Request METHOD /path from IP - Response STATUS (TIMEms)" pattern

struct HTTPRequest {
    let method: String
    let path: String
    let ip: String
    let status: Int
    let responseTime: Int
}

var httpRequests: [HTTPRequest] = []

// Your code here...


/*:
 ### Task 4: Security Monitoring
 Identify potential security issues: failed logins, rate limiting, and suspicious IPs.
 */

print("\n=== Task 4: Security Monitoring ===")

// TODO: Find failed logins, rate limits, and analyze IP activity
// 💡 Hint: Extract failed logins from AuthService, find RateLimiter logs, count IP frequencies

var failedLogins: [(user: String, ip: String)] = []

// Your code here...


/*:
 ### Task 5: System Health Monitoring
 Extract system metrics and identify performance issues.
 */

print("\n=== Task 5: System Health Monitoring ===")

// TODO: Extract CPU alerts, database timeouts, and backup status
// 💡 Hint: Parse different patterns from CRITICAL, DatabaseManager, and BackupService logs

// Your code here...



/*:
 ### Task 6: Payment Transaction Analysis
 Extract payment information while protecting sensitive data.
 */

print("\n=== Task 6: Payment Analysis ===")

// TODO: Extract failed payment transactions from PaymentProcessor logs
// 💡 Hint: Parse "Transaction failed - CardID: XXXX****XXXX, Amount: $XX.XX, Error: XXXXX" pattern

struct FailedTransaction {
    let maskedCard: String
    let amount: Double
    let error: String
}

var failedTransactions: [FailedTransaction] = []

// Your code here...

/*:
 ## Your Turn! Practice Exercises

 Once you've completed the main tasks, try these additional challenges:

 ### Advanced Analysis Tasks:
 1. **Time-based Analysis**: Parse timestamps and group logs by hour to identify peak activity
    - 💡 Hint: Extract hour from timestamp using another regex or String methods
    - 💡 Hint: Use Dictionary(grouping:by:) to group by hour

 2. **Cache Performance**: Extract cache hit information from CacheService logs
    - Look for: "Cache hit for key 'user_session_abc123' (0.5ms)"
    - Calculate cache hit rates and average response times

 3. **Email Service Monitoring**: Parse SMTP connection failures
    - Look for: "SMTP connection failed to mail.example.com:587 - Timeout after 15000ms"
    - Track which email servers are having issues

 4. **Geographic Analysis**: Map IP addresses to mock regions
    - Create a simple mapping of IP ranges to regions
    - Analyze activity by geographic location

 5. **Correlation Analysis**: Find logs that occur within short time windows
    - Identify patterns like: failed login followed by rate limiting
    - Look for suspicious activity sequences

 ### Regex Technique Exploration:
 - **Error Handling**: Add proper error handling for malformed log entries
 - **Performance**: Compare different regex patterns for the same task
 - **Validation**: Create regex patterns to validate log format consistency
 - **Complex Patterns**: Try matching multi-line log entries or nested data

 ### Swift Regex Features to Explore:
 - Use named capture groups for clearer code
 - Experiment with regex options like case-insensitive matching
 - Try conditional patterns for optional log components
 - Use regex to validate and sanitize extracted data

 **Bonus Challenge**: Create an automated alerting system that scans logs and
 triggers alerts based on patterns you define (e.g., multiple failed logins,
 high error rates, performance degradation).
 */

//: [Next: Challenge - Log Analysis (Solution)](@next)
