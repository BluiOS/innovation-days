//: # ISO 8601 Parsing
//:
//: Use structured parsers for machine timestamps. This example parses a UTC
//: timestamp with `ISO8601DateFormatter`.

import Foundation

let string = "2026-04-28T12:30:00Z"

let formatter = ISO8601DateFormatter()
let date = formatter.date(from: string)

print(date as Any)
