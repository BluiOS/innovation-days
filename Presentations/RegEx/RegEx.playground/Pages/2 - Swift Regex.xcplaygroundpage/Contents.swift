/*:
 [Previous: NSRegularExpression](@previous)

 # Swift Regex (iOS 16+)

 Swift 5.7 introduced native regex support with a modern, Swift-native API.
 This provides type-safe pattern matching with better performance and ergonomics.

 ## Basic Regex Literals
 */

import Foundation

// Example 1: Basic Regex Literals
print("=== Example 1: Basic Regex Literals ===")

let text1 = "The quick brown fox jumps over 123 lazy dogs."

// Using regex literals with /pattern/
let numberRegex = /\d+/
let wordRegex = /\b[A-Za-z]+\b/

// Check if text contains pattern
print("Text: \(text1)")
print("Contains numbers: \(text1.contains(numberRegex))")
print("Contains words: \(text1.contains(wordRegex))")

// Find first match
if let numberMatch = text1.firstMatch(of: numberRegex) {
    print("First number found: '\(numberMatch.0)'")
}

// Find all matches
let allNumbers = text1.matches(of: numberRegex)
print("All numbers: \(allNumbers.map { $0.0 })")

/*:
 ## Capture Groups with Type Safety
 */

print("\n=== Example 2: Capture Groups ===")

let dateText = "Today is 2023-12-31 and tomorrow is 2024-01-01."

// Regex with capture groups
let dateRegex = /(\d{4})-(\d{2})-(\d{2})/

// Swift Regex provides type-safe access to capture groups
if let match = dateText.firstMatch(of: dateRegex) {
    print("Full match: '\(match.0)'")
    print("Year: '\(match.1)'")      // First capture group
    print("Month: '\(match.2)'")     // Second capture group
    print("Day: '\(match.3)'")       // Third capture group
}

// Process all matches
let allDates = dateText.matches(of: dateRegex)
for (index, match) in allDates.enumerated() {
    print("Date \(index + 1): \(match.1)-\(match.2)-\(match.3)")
}

/*:
 ## Named Capture Groups
 */

print("\n=== Example 3: Named Capture Groups ===")

let logEntry = "2023-12-31 14:30:45 [ERROR] Database connection failed"

// Named capture groups for better readability
let logRegex = /(?<date>\d{4}-\d{2}-\d{2}) (?<time>\d{2}:\d{2}:\d{2}) \[(?<level>\w+)\] (?<message>.*)/

if let match = logEntry.firstMatch(of: logRegex) {
    print("Log entry parsed:")
    print("Date: \(match.date)")
    print("Time: \(match.time)")
    print("Level: \(match.level)")
    print("Message: \(match.message)")
}

/*:
 ## Email Validation and Extraction
 */

print("\n=== Example 4: Email Processing ===")

let emailText = "Contact john.doe@example.com or admin@company-site.org for support."

// More readable email regex
let emailRegex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/

let emails = emailText.matches(of: emailRegex)
print("Found emails:")
for email in emails {
    print("- \(email.0)")
}

// Email validation
let testEmails = ["valid@example.com", "invalid-email", "test@domain.co.uk"]

for email in testEmails {
    let isValid = email.wholeMatch(of: emailRegex) != nil
    print("\(email): \(isValid ? "✅" : "❌")")
}

/*:
 ## Advanced Pattern Matching
 */

print("\n=== Example 5: URL Parsing ===")

let urlText = "Visit https://www.example.com:8080/path/to/resource?param=value#section"

// Complex URL regex with named groups
let urlRegex = /(?<protocol>https?):\/\/(?<host>[^:\/\s]+)(?::(?<port>\d+))?(?<path>\/[^\?\s]*)?(?:\?(?<query>[^#\s]*))?(?:#(?<fragment>\S*))?/

if let match = urlText.firstMatch(of: urlRegex) {
    print("URL components:")
    print("Protocol: \(match.protocol)")
    print("Host: \(match.host)")

    // Optional components might be nil
    if let port = match.port {
        print("Port: \(port)")
    }
    if let path = match.path {
        print("Path: \(path)")
    }
    if let query = match.query {
        print("Query: \(query)")
    }
    if let fragment = match.fragment {
        print("Fragment: \(fragment)")
    }
}

/*:
 ## Pattern Options and Modifiers
 */

print("\n=== Example 6: Case-Insensitive Matching ===")

let caseText = "Hello WORLD and hello world"

// Case-sensitive (default)
let caseSensitiveRegex = /hello/
print("Case-sensitive matches: \(caseText.matches(of: caseSensitiveRegex).count)")

// Case-insensitive
let caseInsensitiveRegex = /hello/.ignoresCase()
print("Case-insensitive matches: \(caseText.matches(of: caseInsensitiveRegex).count)")

/*:
 ## Multiline and Anchors
 */

print("\n=== Example 7: Multiline Processing ===")

let multilineText = """
First line starts here
Second line has content
Third line ends here
"""

// Match lines starting with specific words
let lineStartRegex = /^Second.*$/
let multilineRegex = lineStartRegex.anchorsMatchLineEndings()

let matchingLines = multilineText.matches(of: multilineRegex)
print("Lines starting with 'Second':")
for match in matchingLines {
    print("- \(match.0)")
}

/*:
 ## String Replacement
 */

print("\n=== Example 8: String Replacement ===")

let originalText = "My phone is 555-123-4567 and backup is 555-987-6543"
let phoneRegex = /\d{3}-\d{3}-\d{4}/

// Replace all matches
let maskedText = originalText.replacing(phoneRegex, with: "XXX-XXX-XXXX")
print("Original: \(originalText)")
print("Masked: \(maskedText)")

// Replace with closure for custom logic
let customReplaced = originalText.replacing(phoneRegex) { match in
    let phone = String(match.0)
    let lastFour = String(phone.suffix(4))
    return "XXX-XXX-\(lastFour)"
}
print("Custom masked: \(customReplaced)")

/*:
 ## Splitting Strings
 */

print("\n=== Example 9: String Splitting ===")

let csvData = "John,25,Engineer;Jane,30,Designer;Bob,35,Manager"

// Split by semicolon or comma
let delimiterRegex = /[;,]/

let fields = csvData.split(separator: delimiterRegex)
print("CSV fields: \(fields)")

// More complex splitting with whitespace handling
let sentenceText = "First sentence.    Second sentence!   Third sentence?"
let sentenceRegex = /[.!?]+\s*/

let sentences = sentenceText.split(separator: sentenceRegex, omittingEmptySubsequences: true)
print("Sentences:")
for (index, sentence) in sentences.enumerated() {
    print("\(index + 1): \(sentence)")
}

/*:
 ## Validation Patterns
 */

print("\n=== Example 10: Common Validation Patterns ===")

// Credit card pattern (simplified)
let creditCardRegex = /^\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}$/

let cardNumbers = [
    "1234 5678 9012 3456",
    "1234-5678-9012-3456",
    "1234567890123456",
    "1234 5678 901"
]

print("Credit card validation:")
for card in cardNumbers {
    let isValid = card.wholeMatch(of: creditCardRegex) != nil
    print("\(card): \(isValid ? "✅" : "❌")")
}

// IP address validation
let ipRegex = /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/

let ipAddresses = ["192.168.1.1", "10.0.0.1", "256.1.1.1", "192.168.1"]

print("\nIP address validation:")
for ip in ipAddresses {
    let isValid = ip.wholeMatch(of: ipRegex) != nil
    print("\(ip): \(isValid ? "✅" : "❌")")
}

/*:
 ## Performance Comparison
 */

print("\n=== Performance Comparison ===")

let testText = String(repeating: "test@example.com invalid.email another@domain.org ", count: 1000)
let swiftEmailRegex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/

// Swift Regex approach
let startTime1 = CFAbsoluteTimeGetCurrent()
let swiftMatches = testText.matches(of: swiftEmailRegex)
let swiftTime = CFAbsoluteTimeGetCurrent() - startTime1

// NSRegularExpression approach (for comparison)
let nsRegex = try! NSRegularExpression(pattern: #"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b"#)
let startTime2 = CFAbsoluteTimeGetCurrent()
let nsMatches = nsRegex.matches(in: testText, range: NSRange(testText.startIndex..., in: testText))
let nsTime = CFAbsoluteTimeGetCurrent() - startTime2

print("Swift Regex: \(swiftMatches.count) matches in \(String(format: "%.4f", swiftTime)) seconds")
print("NSRegularExpression: \(nsMatches.count) matches in \(String(format: "%.4f", nsTime)) seconds")

if swiftTime < nsTime {
    print("Swift Regex is \(String(format: "%.1f", nsTime / swiftTime))x faster")
} else {
    print("NSRegularExpression is \(String(format: "%.1f", swiftTime / nsTime))x faster")
}

//: [Next: Swift Regex Builder](@next)
