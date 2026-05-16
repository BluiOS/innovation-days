//: # Calendar Information
//:
//: Ask the calendar for ordinal values and valid ranges. Hard-coded month
//: lengths and day-of-year math break across leap years and calendar systems.

import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(secondsFromGMT: 0)!

let leapDay = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 2024,
    month: 2,
    day: 29
).date!

let regularFebruary = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 2026,
    month: 2,
    day: 1
).date!

let esfand = DateComponents(
    calendar: Calendar(identifier: .persian),
    timeZone: TimeZone(identifier: "Asia/Tehran"),
    year: 1403,
    month: 12,
    day: 30
).date!

print("ordinality(of:in:for:):", calendar.ordinality(of: .day, in: .year, for: leapDay) as Any)
print("range leap February:", calendar.range(of: .day, in: .month, for: leapDay) as Any)
print("range regular February:", calendar.range(of: .day, in: .month, for: regularFebruary) as Any)
print("week range in leap month:", calendar.range(of: .weekOfMonth, in: .month, for: leapDay) as Any)
