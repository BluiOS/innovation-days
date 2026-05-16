//: # Intervals And Comparisons
//:
//: Compare dates at the granularity your domain means. Two different instants
//: can still be the same calendar day in a chosen timezone.

import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let first = ISO8601DateFormatter()
    .date(from: "2026-04-28T12:00:00Z")!
let second = ISO8601DateFormatter()
    .date(from: "2026-04-28T21:00:00Z")!

print("dateInterval(of:for:):", calendar.dateInterval(of: .day, for: first) as Any)

var intervalStart = Date()
var intervalDuration: TimeInterval = 0
let foundMonth = calendar.dateInterval(
    of: .month,
    start: &intervalStart,
    interval: &intervalDuration,
    for: first
)
print("dateInterval(of:start:interval:for:):", foundMonth, intervalStart, intervalDuration)

print("compare(_:to:toGranularity:):", calendar.compare(first, to: second, toGranularity: .day).rawValue)
print("isDate(_:equalTo:toGranularity:):", calendar.isDate(first, equalTo: second, toGranularity: .day))
print("isDate(_:inSameDayAs:):", calendar.isDate(first, inSameDayAs: second))
print("isDateInToday:", calendar.isDateInToday(first))
print("isDateInTomorrow:", calendar.isDateInTomorrow(first))
print("isDateInYesterday:", calendar.isDateInYesterday(first))
print("isDateInWeekend:", calendar.isDateInWeekend(first))
