/*:
 [Previous: Challenge - Log Analysis](@previous)

 # Scenario 1: Log File Analysis

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

// Solution using Swift Regex
let logRegex = /(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}) \[(\w+)\] (\w+): (.*)/

struct LogEntry {
    let timestamp: String
    let level: String
    let service: String
    let message: String
}

var parsedLogs: [LogEntry] = []
let logLines = serverLogs.components(separatedBy: .newlines).filter { !$0.isEmpty }

for line in logLines {
    if let match = line.firstMatch(of: logRegex) {
        parsedLogs.append(LogEntry(
            timestamp: String(match.1),
            level: String(match.2),
            service: String(match.3),
            message: String(match.4)
        ))
    }
}

print("Parsed \(parsedLogs.count) log entries")
print("First 3 entries:")
for entry in parsedLogs.prefix(3) {
    print("[\(entry.level)] \(entry.service) at \(entry.timestamp)")
    print("  \(entry.message)")
}

/*:
 ### Task 2: Error Analysis
 Find all ERROR and CRITICAL level logs and categorize them by service.
 */

print("\n=== Task 2: Error Analysis ===")

// Filter error logs
let errorLogs = parsedLogs.filter { ["ERROR", "CRITICAL"].contains($0.level) }
print("Found \(errorLogs.count) error/critical entries")

// Group by service
var errorsByService: [String: [LogEntry]] = [:]
for log in errorLogs {
    errorsByService[log.service, default: []].append(log)
}

print("Errors by service:")
for (service, logs) in errorsByService.sorted(by: { $0.key < $1.key }) {
    print("- \(service): \(logs.count) errors")
    for log in logs {
        print("  [\(log.level)] \(log.message)")
    }
}

/*:
 ### Task 3: Performance Metrics Extraction
 Extract response times, request methods, and status codes from WebServer logs.
 */

print("\n=== Task 3: Performance Metrics ===")

// TODO: Create a regex to extract HTTP request details
// Pattern: "Request METHOD /path from IP - Response STATUS (TIMEms)"

let httpRegex = /Request (\w+) (\/[^\s]*) from ([\d\.]+) - Response (\d+) \((\d+)ms\)/

struct HTTPRequest {
    let method: String
    let path: String
    let ip: String
    let status: Int
    let responseTime: Int
}

var httpRequests: [HTTPRequest] = []

let webServerLogs = parsedLogs.filter { $0.service == "WebServer" }

for log in webServerLogs {
    if let match = log.message.firstMatch(of: httpRegex) {
        httpRequests.append(HTTPRequest(
            method: String(match.1),
            path: String(match.2),
            ip: String(match.3),
            status: Int(String(match.4))!,
            responseTime: Int(String(match.5))!
        ))
    }
}

print("HTTP Request Analysis:")
print("Total requests: \(httpRequests.count)")

// Average response time
let avgResponseTime = httpRequests.map { $0.responseTime }.reduce(0, +) / httpRequests.count
print("Average response time: \(avgResponseTime)ms")

// Requests by method
let requestsByMethod = Dictionary(grouping: httpRequests, by: { $0.method })
for (method, requests) in requestsByMethod.sorted(by: { $0.key < $1.key }) {
    print("- \(method): \(requests.count) requests")
}

// Status code distribution
let statusCodes = Dictionary(grouping: httpRequests, by: { $0.status })
for (status, requests) in statusCodes.sorted(by: { $0.key < $1.key }) {
    print("- HTTP \(status): \(requests.count) responses")
}

/*:
 ### Task 4: Security Monitoring
 Identify potential security issues: failed logins, rate limiting, and suspicious IPs.
 */

print("\n=== Task 4: Security Monitoring ===")

// Failed login attempts
let failedLoginRegex = /Failed login attempt for user '([^']+)' from ([\d\.]+)/

var failedLogins: [(user: String, ip: String)] = []

for log in parsedLogs where log.service == "AuthService" {
    if let match = log.message.firstMatch(of: failedLoginRegex) {
        failedLogins.append((user: String(match.1), ip: String(match.2)))
    }
}

print("Security Issues:")
print("Failed login attempts: \(failedLogins.count)")
for login in failedLogins {
    print("- User '\(login.user)' from \(login.ip)")
}

// Rate limiting violations
let rateLimitLogs = parsedLogs.filter { $0.service == "RateLimiter" }
print("Rate limiting violations: \(rateLimitLogs.count)")
for log in rateLimitLogs {
    print("- \(log.message)")
}

// IP frequency analysis
let allIPs = httpRequests.map { $0.ip } + failedLogins.map { $0.ip }
let ipFrequency = Dictionary(allIPs.map { ($0, 1) }, uniquingKeysWith: +)
let suspiciousIPs = ipFrequency.filter { $0.value > 2 }.sorted { $0.value > $1.value }

print("Most active IPs:")
for (ip, count) in suspiciousIPs.prefix(3) {
    print("- \(ip): \(count) activities")
}

/*:
 ### Task 5: System Health Monitoring
 Extract system metrics and identify performance issues.
 */

print("\n=== Task 5: System Health Monitoring ===")

// CPU usage alerts
let cpuRegex = /CPU usage at (\d+)% - Threshold: (\d+)%/

for log in parsedLogs where log.level == "CRITICAL" {
    if let match = log.message.firstMatch(of: cpuRegex) {
        print("🚨 CPU Alert: \(match.1)% usage (threshold: \(match.2)%)")
    }
}

// Database connection timeouts
let dbTimeoutRegex = /Connection timeout to ([^:]+):(\d+) after (\d+)ms/

for log in parsedLogs where log.service == "DatabaseManager" {
    if let match = log.message.firstMatch(of: dbTimeoutRegex) {
        print("🔴 DB Timeout: \(match.1):\(match.2) after \(match.3)ms")
    }
}

// Backup completion status
let backupRegex = /Database backup completed - Size: ([\d\.]+)(GB|MB), Duration: (\d+)(min|sec)/

for log in parsedLogs where log.service == "BackupService" {
    if let match = log.message.firstMatch(of: backupRegex) {
        print("✅ Backup Complete: \(match.1)\(match.2) in \(match.3)\(match.4)")
    }
}

/*:
 ### Task 6: Payment Transaction Analysis
 Extract payment information while protecting sensitive data.
 */

print("\n=== Task 6: Payment Analysis ===")

// Extract payment transactions with masked card numbers
let paymentRegex = /Transaction failed - CardID: (\d{4}\*{4}\d{4}), Amount: \$(\d+\.\d{2}), Error: (\w+)/

struct FailedTransaction {
    let maskedCard: String
    let amount: Double
    let error: String
}

var failedTransactions: [FailedTransaction] = []

for log in parsedLogs where log.service == "PaymentProcessor" {
    if let match = log.message.firstMatch(of: paymentRegex) {
        if let amount = Double(String(match.2)) {
            failedTransactions.append(FailedTransaction(
                maskedCard: String(match.1),
                amount: amount,
                error: String(match.3)
            ))
        }
    }
}

print("Payment Analysis:")
print("Failed transactions: \(failedTransactions.count)")
let totalFailedAmount = failedTransactions.reduce(0) { $0 + $1.amount }
print("Total failed amount: $\(String(format: "%.2f", totalFailedAmount))")

for transaction in failedTransactions {
    print("- Card: \(transaction.maskedCard), Amount: $\(String(format: "%.2f", transaction.amount)), Error: \(transaction.error)")
}

/*:
 ## Your Turn! Practice Exercises

 Try these additional challenges:

 1. **Time-based Analysis**: Group logs by hour and identify peak activity times
 2. **Geographic Analysis**: Map IP addresses to regions (you can use mock data)
 3. **Correlation Analysis**: Find logs that occur within a short time window
 4. **Custom Metrics**: Extract cache hit rates and performance metrics
 5. **Alert Patterns**: Create rules that would trigger automated alerts

 Experiment with different regex approaches:
 - Use Swift Regex for modern, type-safe pattern matching
 - Try RegexBuilder for complex patterns
 - Implement error handling for malformed log entries
 */
