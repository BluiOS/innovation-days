/*:
 # Regular Expressions in Swift - Playground

 Welcome to the Regular Expressions playground! This playground covers:

 ## Navigation

 **Core Topics:**
 - [NSRegularExpression]()
 - [Swift Regex]()
 - [Swift Regex Builder]()

 **Hands-on Practice:**
 - [Scenario 1: Log File Analysis](Scenario%201%20-%20Log%20File%20Analysis)
 - [Scenario 2: Data Validation](Scenario%202%20-%20Data%20Validation)
 - [Scenario 3: Text Processing](Scenario%203%20-%20Text%20Processing)

 ## Quick Start

 Each page builds upon the previous one, starting from basic NSRegularExpression usage to advanced Regex Builder patterns.

 The practice scenarios provide real-world examples with sample data to work with.

 **Requirements:**
 - iOS 16+ for Swift Regex features
 - Foundation framework for NSRegularExpression
 */

import Foundation

// Basic example to get started
let text = "Hello, World! Welcome to Regular Expressions."
let regex = /[A-Z][a-z]+/

let matches = text.matches(of: regex)

print("Found \(matches.count) capitalized words:")
for match in matches {
    print("- \(match.output) at: \(match.range)")
}

//: [Next: NSRegularExpression Examples](@next)
