/*:
 [Previous: Swift Regex Syntax](@previous)

 # Swift Regex Builder (iOS 16+)

 RegexBuilder provides a domain-specific language (DSL) for creating regular expressions
 in Swift. It offers better readability, type safety, and IDE support compared to string-based patterns.

 ## Basic RegexBuilder Components
 */

import RegexBuilder
import Foundation

print("=== Example 1: Basic Components ===")

// Instead of: /\d{3}-\d{3}-\d{4}/
let phoneRegex = Regex {
    Repeat(count: 3) {
        .digit
    }
    "-"
    Repeat(count: 3) {
        .digit
    }
    "-"
    Repeat(count: 4) {
        .digit
    }
}

let phoneText = "Call me at 555-123-4567 for assistance."
if let match = phoneText.firstMatch(of: phoneRegex) {
    print("Found phone: \(match.0)")
}

/*:
 ## Character Classes and Quantifiers
 */

print("\n=== Example 2: Character Classes ===")

// Email regex using RegexBuilder
let emailRegex = Regex {
    OneOrMore {
        .word
        "-"
        "."
    }
    "@"
    OneOrMore {
        .word
        "-"
        "."
    }
    "."
    Repeat(2...4) {
        .word
    }
}

let emailText = "Contact support@example.com or admin@company-name.org"
let emailMatches = emailText.matches(of: emailRegex)

print("Found emails:")
for match in emailMatches {
    print("- \(match.0)")
}

/*:
 ## Capture Groups with Type Safety
 */

print("\n=== Example 3: Capture Groups ===")

// Date parser with named captures
let dateRegex = Regex {
    Capture {
        Repeat(count: 4) { .digit }
    } transform: { String($0) }

    "-"

    Capture {
        Repeat(count: 2) { .digit }
    } transform: { String($0) }

    "-"

    Capture {
        Repeat(count: 2) { .digit }
    } transform: { String($0) }
}

let dateText = "The event is scheduled for 2023-12-31."

if let match = dateText.firstMatch(of: dateRegex) {
    print("Date components:")
    print("Year: \(match.1)")   // String type thanks to transform
    print("Month: \(match.2)")  // String type thanks to transform
    print("Day: \(match.3)")    // String type thanks to transform
}

/*:
 ## Advanced Transformations
 */

print("\n=== Example 4: Custom Transformations ===")

// Parse coordinates with type transformations
let coordinateRegex = Regex {
    Capture {
        Optionally { "-" }
        OneOrMore { .digit }
        Optionally {
            "."
            OneOrMore { .digit }
        }
    } transform: {
        Double($0)
    }

    ChoiceOf {
        ", "
        ","
        " "
    }

    Capture {
        Optionally { "-" }
        OneOrMore { .digit }
        Optionally {
            "."
            OneOrMore { .digit }
        }
    } transform: {
        Double($0)
    }
}

let locationText = "GPS coordinates: 37.7749, -122.4194"

if let match = locationText.firstMatch(of: coordinateRegex) {
    if let lat = match.1, let lon = match.2 {
        print("Latitude: \(lat)")    // Double type
        print("Longitude: \(lon)")   // Double type
        print("Distance from origin: \(sqrt(lat * lat + lon * lon))")
    }
}

/*:
 ## Complex URL Parser
 */

print("\n=== Example 5: URL Parser ===")

// (https|http|ftp)://(?:([A-Za-z0-9-_]+)(?::([A-Za-z0-9-_]+))?@)?([A-Za-z0-9-\.]+)(?::(\d+))?((?:/[A-Za-z0-9-_]+)*/?)(?:\?([A-Za-z0-9=&]+))?
let urlRegex = Regex {
    // Scheme
    Capture {
        ChoiceOf {
            "https"
            "http"
            "ftp"
        }
    }

    "://"
    // user:pass@
    Optionally {
        let oneOrMoreAllowedChars = OneOrMore {
            CharacterClass(
                .anyOf("-_"),
                ("A"..."Z"),
                ("a"..."z"),
                ("0"..."9")
            )
        }

        Capture {
            oneOrMoreAllowedChars
        }
        Optionally {
            ":"
            Capture {
                oneOrMoreAllowedChars
            }
        }
        "@"
    }
    // host
    Capture {
        OneOrMore {
            CharacterClass(
                .anyOf("-."),
                ("A"..."Z"),
                ("a"..."z"),
                ("0"..."9")
            )
        }
    }
    // port
    Optionally {
        ":"
        Capture {
            OneOrMore(.digit)
        }
    }
    // path
    Capture {
        Regex {
            ZeroOrMore {
                    "/"
                OneOrMore {
                    CharacterClass(
                        .anyOf("-_"),
                        ("A"..."Z"),
                        ("a"..."z"),
                        ("0"..."9")
                    )
                }
            }
            Optionally {
                "/"
            }
        }
    }
    // query parameters
    Optionally {
        "?"
        Capture {
            OneOrMore {
                CharacterClass(
                    .anyOf("=&"),
                    ("A"..."Z"),
                    ("a"..."z"),
                    ("0"..."9")
                )
            }
        }
    }
}

let urlText = "Visit https://user:pass@example.com:8080/path/to/resource?param=value"

if let match = urlText.firstMatch(of: urlRegex) {
    print("URL components:")
    print("Protocol: \(match.1)")
    if let username = match.2 { print("Username: \(username)") }
    if let password = match.3 { print("Password: \(password, default: "nil")") }
    print("Host: \(match.4)")
    if let port = match.5 { print("Port: \(port)") }  // Int type
    print("Path: \(match.6)")
    print("Query: \(match.7, default: "nil")")
}

/*:
 ## Log File Parser
 */

print("\n=== Example 6: Log Parser with Enum Types ===")

enum LogLevel: String, CaseIterable {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case critical = "CRITICAL"
}

let logRegex = Regex {
    // Timestamp
    Capture {
        Repeat(count: 4) { .digit }
        "-"
        Repeat(count: 2) { .digit }
        "-"
        Repeat(count: 2) { .digit }
        " "
        Repeat(count: 2) { .digit }
        ":"
        Repeat(count: 2) { .digit }
        ":"
        Repeat(count: 2) { .digit }
    }

    " ["

    // Log level
    Capture {
        ChoiceOf {
            "DEBUG"
            "INFO"
            "WARNING"
            "ERROR"
            "CRITICAL"
        }
    } transform: {
        LogLevel(rawValue: String($0))
    }

    "] "

    // Module
    Capture {
        OneOrMore { .word }
    }

    ": "

    // Message
    Capture {
        OneOrMore { .any }
    }
}

let logEntries = [
    "2023-12-31 14:30:45 [ERROR] DatabaseManager: Connection timeout after 30 seconds",
    "2023-12-31 14:30:46 [INFO] UserService: User authentication successful",
    "2023-12-31 14:30:47 [WARNING] CacheService: Cache miss for key 'user_123'"
]

for entry in logEntries {
    if let match = entry.firstMatch(of: logRegex) {
        let timestamp = match.1
        let level = match.2
        let module = match.3
        let message = match.4

        print("[\(level?.rawValue ?? "UNKNOWN")] \(module): \(message) @\(timestamp)")
    }
}

/*:
 ## Conditional Matching
 */

print("\n=== Example 7: Conditional Patterns ===")

// Match different phone number formats
let flexiblePhoneRegex = Regex {
    // Country code (optional)
    Optionally {
        ChoiceOf {
            Regex {
                "+"
                OneOrMore { .digit }
                ChoiceOf { "-"; " "; ""; }
            }
            Regex {
                "("
                OneOrMore { .digit }
                ")"
                ChoiceOf { "-"; " "; ""; }
            }
        }
    }

    // Main number with flexible formatting
    ChoiceOf {
        // Format: XXX-XXX-XXXX
        Regex {
            Repeat(count: 3) { .digit }
            "-"
            Repeat(count: 3) { .digit }
            "-"
            Repeat(count: 4) { .digit }
        }

        // Format: XXX.XXX.XXXX
        Regex {
            Repeat(count: 3) { .digit }
            "."
            Repeat(count: 3) { .digit }
            "."
            Repeat(count: 4) { .digit }
        }

        // Format: (XXX) XXX-XXXX
        Regex {
            "("
            Repeat(count: 3) { .digit }
            ") "
            Repeat(count: 3) { .digit }
            "-"
            Repeat(count: 4) { .digit }
        }
    }
}

let phoneNumbers = [
    "+1-555-123-4567",
    "(555) 987-6543",
    "555.234.5678",
    "+44 20 7946 0958"
]

print("Phone number validation:")
for phone in phoneNumbers {
    let isValid = phone.wholeMatch(of: flexiblePhoneRegex) != nil
    print("\(phone): \(isValid ? "✅" : "❌")")
}

/*:
 ## Data Extraction Pipeline
 */

print("\n=== Example 8: Data Extraction Pipeline ===")

struct Contact {
    let name: String
    let email: String
    let phone: String?
}

let contactRegex = Regex {
    // Name
    Capture {
        OneOrMore {
            CharacterClass.word
            " "
            "."
        }
    } transform: {
        String($0).trimmingCharacters(in: .whitespaces)
    }

    CharacterClass.whitespace

    // Email
    Capture {
        OneOrMore {
            CharacterClass(
                .anyOf("-_."),
                ("A"..."Z"),
                ("a"..."z"),
                ("0"..."9")
            )
        }
        "@"
        OneOrMore {
            CharacterClass(
                .anyOf("-."),
                ("A"..."Z"),
                ("a"..."z"),
                ("0"..."9")
            )
        }
        "."
        Repeat(2...4) { .word }
    }

    // Optional phone
    Optionally {
        One(.whitespace)
        Capture {
            OneOrMore {
                CharacterClass(
                    .anyOf("-() "),
                    ("0"..."9")
                )

            }
        } transform: {
            String($0).trimmingCharacters(in: .whitespaces)
        }
    }
}

let contactData = [
    "John Doe john.doe@example.com (555) 123-4567",
    "Jane Smith jane@company.org",
    "Bob Wilson bob.wilson@domain.net 555-987-6543"
]

print("Extracted contacts:")
for data in contactData {
    if let match = data.firstMatch(of: contactRegex) {
        let contact = Contact(
            name: String(match.output.1),
            email: String(match.output.2),
            phone: match.output.3
        )
        print("Name: \(contact.name)")
        print("Email: \(contact.email)")
        print("Phone: \(contact.phone ?? "N/A")")
        print("---")
    }
}

/*:
 ## Performance and Debugging
 */

print("\n=== Example 9: Performance Tips ===")

// Compile once, use multiple times
let compiledRegex = Regex {
    OneOrMore { .digit }
    "."
    OneOrMore { .digit }
    "."
    OneOrMore { .digit }
    "."
    OneOrMore { .digit }
}

let ipAddresses = [
    "192.168.1.1",
    "10.0.0.1",
    "172.16.254.1",
    "8.8.8.8"
]

let startTime = CFAbsoluteTimeGetCurrent()
let validIPs = ipAddresses.filter { $0.wholeMatch(of: compiledRegex) != nil }
let elapsed = CFAbsoluteTimeGetCurrent() - startTime

print("Validated \(validIPs.count) IP addresses in \(String(format: "%.4f", elapsed)) seconds")
print("Valid IPs: \(validIPs)")

/*:
 ## Builder vs Literal Comparison
 */

print("\n=== Builder vs Literal Comparison ===")

// Literal approach
let literalEmailRegex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b/

// Builder approach
let builderEmailRegex = Regex {

    OneOrMore {
        CharacterClass(
            .anyOf("._%+-"),
            ("A"..."Z"),
            ("a"..."z"),
            ("0"..."9")
        )
    }
    "@"
    OneOrMore {
        CharacterClass(
            .anyOf(".-"),
            ("A"..."Z"),
            ("a"..."z"),
            ("0"..."9")
        )
    }
    "."
    Repeat(2...) {
        .word
    }
    Anchor.wordBoundary
}

let testEmailText = "Contact admin@example.com or support@company.co.uk for help."

// Both should produce the same results
let literalMatches = testEmailText.matches(of: literalEmailRegex)
let builderMatches = testEmailText.matches(of: builderEmailRegex)

print("Literal regex found: \(literalMatches.map { $0.0 })")
print("Builder regex found: \(builderMatches.map { $0.0 })")
print("Results match: \(literalMatches.count == builderMatches.count)")

/*:
 ## Key Advantages of RegexBuilder

 1. **Type Safety**: Compile-time checking of patterns
 2. **Readability**: Self-documenting code
 3. **IDE Support**: Autocompletion and syntax highlighting
 4. **Maintainability**: Easier to modify and extend
 5. **Debugging**: Better error messages and debugging support

 ## When to Use Each Approach

 - **Regex Literals**: Simple patterns, performance-critical code
 - **RegexBuilder**: Complex patterns, team collaboration, maintainability
 - **NSRegularExpression**: Backwards compatibility, dynamic patterns
 */

//: [Next: Scenario 1 - Log File Analysis](@next)
