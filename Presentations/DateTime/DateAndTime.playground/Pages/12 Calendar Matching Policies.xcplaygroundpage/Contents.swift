//: # Calendar Matching Policies
//:
//: When a requested local time is missing or repeated around DST, matching
//: policies define how `Calendar` should resolve it.

import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let beforeDSTJump = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 2026,
    month: 3,
    day: 28,
    hour: 12
).date!

let requestedTwoThirty = DateComponents(hour: 2, minute: 30)

let nextAvailable = calendar.nextDate(
    after: beforeDSTJump,
    matching: requestedTwoThirty,
    matchingPolicy: .nextTime,
    repeatedTimePolicy: .first,
    direction: .forward
)

let strict = calendar.nextDate(
    after: beforeDSTJump,
    matching: requestedTwoThirty,
    matchingPolicy: .strict,
    repeatedTimePolicy: .first,
    direction: .forward
)

print("Next available 02:30:", nextAvailable as Any)
print("Strict 02:30:", strict as Any)
