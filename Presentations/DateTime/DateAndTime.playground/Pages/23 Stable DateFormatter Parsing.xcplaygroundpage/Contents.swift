//: # Stable DateFormatter Parsing
//:
//: For fixed machine formats, use a stable locale such as `en_US_POSIX` and
//: explicitly set the timezone.

import Foundation

let formatter = DateFormatter()
formatter.locale = Locale(identifier: "en_US_POSIX")
formatter.timeZone = TimeZone(secondsFromGMT: 0)
formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"

let date = formatter.date(from: "2026-04-28T12:30:00Z")

print(date as Any)
