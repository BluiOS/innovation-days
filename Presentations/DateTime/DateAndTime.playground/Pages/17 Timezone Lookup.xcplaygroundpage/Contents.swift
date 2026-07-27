//: # Timezone Lookup
//:
//: Timezone conversion is a rule lookup. The offset is computed for a specific
//: instant using the platform's timezone data.

import Foundation

let instant = ISO8601DateFormatter()
    .date(from: "2026-04-28T12:00:00Z")!

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let components = calendar.dateComponents(
    [.year, .month, .day, .hour, .minute, .timeZone],
    from: instant
)

print(components)
