/*:
 [Previous: Introduction](@previous)

 # NSRegularExpression

 NSRegularExpression is the Foundation framework's approach to regular expressions.
 It's been available since iOS 4 and provides comprehensive regex functionality.

 ## Basic Pattern Matching
 */

import Foundation

// Example 1: Simple Pattern Matching
print("=== Example 1: Simple Pattern Matching ===")

let text1 = "The quick brown fox jumps over 123 lazy dogs."
let pattern1 = #"\d+"# // Match digits

do {
    let regex1 = try NSRegularExpression(pattern: pattern1)
    let matches1 = regex1.matches(in: text1, range: NSRange(text1.startIndex..., in: text1))

    print("Text: \(text1)")
    print("Pattern: \(pattern1)")
    print("Found \(matches1.count) matches:")

    for match in matches1 {
        if let range = Range(match.range, in: text1) {
            print("- '\(text1[range])' at position \(match.range.location)")
        }
    }
} catch {
    print("Regex error: \(error)")
}

/*:
 ## Email Validation
 */

print("\n=== Example 2: Email Validation ===")

let emails = [
    "user@example.com",
    "invalid-email",
    "test.email+tag@domain.co.uk",
    "bad@.com",
    "good_email@company-name.org"
]

let emailPattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

do {
    let emailRegex = try NSRegularExpression(pattern: emailPattern)

    for email in emails {
        let range = NSRange(email.startIndex..., in: email)
        let isValid = emailRegex.firstMatch(in: email, range: range) != nil
        print("\(email): \(isValid ? "✅ Valid" : "❌ Invalid")")
    }
} catch {
    print("Email regex error: \(error)")
}

/*:
 ## Capture Groups and Data Extraction
 */

print("\n=== Example 3: Capture Groups - Date Extraction ===")

let dateText = "Meeting on 2023-12-31, deadline is 2024-01-15, and review on 2024-02-28."
let datePattern = #"(\d{4})-(\d{2})-(\d{2})"#

do {
    let dateRegex = try NSRegularExpression(pattern: datePattern)
    let dateMatches = dateRegex.matches(in: dateText, range: NSRange(dateText.startIndex..., in: dateText))

    print("Text: \(dateText)")
    print("Found \(dateMatches.count) dates:")

    for match in dateMatches {
        // Full match
        if let fullRange = Range(match.range, in: dateText) {
            let fullDate = String(dateText[fullRange])
            print("Full date: \(fullDate)")
        }

        // Individual groups
        if match.numberOfRanges >= 4 {
            if let yearRange = Range(match.range(at: 1), in: dateText),
               let monthRange = Range(match.range(at: 2), in: dateText),
               let dayRange = Range(match.range(at: 3), in: dateText) {

                let year = String(dateText[yearRange])
                let month = String(dateText[monthRange])
                let day = String(dateText[dayRange])

                print("  Year: \(year), Month: \(month), Day: \(day)")
            }
        }
    }
} catch {
    print("Date regex error: \(error)")
}

/*:
 ## Phone Number Extraction
 */

print("\n=== Example 4: Phone Number Extraction ===")

let contactText = """
Call me at +1-555-123-4567 or (555) 987-6543.
International: +44 20 7946 0958
Local: 555.234.5678
"""

let phonePattern = #"(\+?[\d\s\-\(\)\.]{10,})"#

do {
    let phoneRegex = try NSRegularExpression(pattern: phonePattern)
    let phoneMatches = phoneRegex.matches(in: contactText, range: NSRange(contactText.startIndex..., in: contactText))

    print("Contact text:")
    print(contactText)
    print("\nFound \(phoneMatches.count) potential phone numbers:")

    for match in phoneMatches {
        if let range = Range(match.range, in: contactText) {
            let phoneNumber = String(contactText[range]).trimmingCharacters(in: .whitespaces)
            print("- \(phoneNumber)")
        }
    }
} catch {
    print("Phone regex error: \(error)")
}

/*:
 ## Text Replacement
 */

print("\n=== Example 5: Text Replacement ===")

let originalText = "Visit http://example.com and https://secure.example.org for more info."
let urlPattern = #"https?://[^\s]+"#

do {
    let urlRegex = try NSRegularExpression(pattern: urlPattern)
    let replacedText = urlRegex.stringByReplacingMatches(
        in: originalText,
        range: NSRange(originalText.startIndex..., in: originalText),
        withTemplate: "[URL]"
    )

    print("Original: \(originalText)")
    print("Replaced: \(replacedText)")
} catch {
    print("URL replacement error: \(error)")
}

/*:
 ## Advanced: Password Validation with Multiple Patterns
 */

print("\n=== Example 6: Password Validation ===")

func validatePassword(_ password: String) -> (isValid: Bool, errors: [String]) {
    let validationRules = [
        ("At least 8 characters", #".{8,}"#),
        ("Contains uppercase letter", #"[A-Z]"#),
        ("Contains lowercase letter", #"[a-z]"#),
        ("Contains digit", #"\d"#),
        ("Contains special character", #"[!@#$%^&*(),.?\":{}|<>]"#),
        ("No spaces", #"^[^\s]*$"#)
    ]

    var errors: [String] = []

    for (rule, pattern) in validationRules {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(password.startIndex..., in: password)
            let hasMatch = regex.firstMatch(in: password, range: range) != nil

            if !hasMatch {
                errors.append(rule)
            }
        } catch {
            errors.append("Error validating: \(rule)")
        }
    }

    return (errors.isEmpty, errors)
}

let testPasswords = [
    "password",
    "Password123",
    "P@ssw0rd!",
    "weak",
    "StrongP@ssw0rd2023!"
]

for password in testPasswords {
    let validation = validatePassword(password)
    print("\nPassword: '\(password)'")
    if validation.isValid {
        print("✅ Valid password")
    } else {
        print("❌ Invalid - Missing:")
        for error in validation.errors {
            print("  - \(error)")
        }
    }
}

/*:
 ## Performance Tips

 ### Compile Once, Use Many Times
 */

print("\n=== Performance Example ===")

let performanceText = Array(repeating: "test@example.com contact@domain.org", count: 100).joined(separator: " ")

// ❌ Bad: Compiling regex multiple times
func slowEmailExtraction(_ text: String) -> [String] {
    var emails: [String] = []
    let pattern = #"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b"#

    // This compiles the regex every time - inefficient!
    if let regex = try? NSRegularExpression(pattern: pattern) {
        let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        for match in matches {
            if let range = Range(match.range, in: text) {
                emails.append(String(text[range]))
            }
        }
    }
    return emails
}

// ✅ Good: Compile once, use many times
let emailExtractionRegex = try! NSRegularExpression(pattern: #"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b"#)

func fastEmailExtraction(_ text: String) -> [String] {
    var emails: [String] = []
    let matches = emailExtractionRegex.matches(in: text, range: NSRange(text.startIndex..., in: text))

    for match in matches {
        if let range = Range(match.range, in: text) {
            emails.append(String(text[range]))
        }
    }
    return emails
}

// Demonstrate the difference
let startTime = CFAbsoluteTimeGetCurrent()
let emails1 = slowEmailExtraction(performanceText)
let slowTime = CFAbsoluteTimeGetCurrent() - startTime

let startTime2 = CFAbsoluteTimeGetCurrent()
let emails2 = fastEmailExtraction(performanceText)
let fastTime = CFAbsoluteTimeGetCurrent() - startTime2

print("Slow method found \(emails1.count) emails in \(String(format: "%.4f", slowTime)) seconds")
print("Fast method found \(emails2.count) emails in \(String(format: "%.4f", fastTime)) seconds")
print("Performance improvement: \(String(format: "%.1f", slowTime / fastTime))x faster")

//: [Next: Swift Regex](@next)
