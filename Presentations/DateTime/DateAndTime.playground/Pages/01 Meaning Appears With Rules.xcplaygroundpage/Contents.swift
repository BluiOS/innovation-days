//: # Meaning Appears With Rules
//:
//: `Date` is an instant. Calendar components become meaningful only after
//: choosing a calendar and timezone.

import Foundation

let instant = Date()

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Istanbul")!

let components = calendar.dateComponents(
    [.year, .month, .day, .hour, .minute],
    from: instant
)

print(components)
