//: # Scanning Dates
//:
//: Scanning APIs find dates that match calendar components. They are safer
//: than guessing with fixed seconds when local time rules can shift.

import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let start = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 2026,
    month: 3,
    day: 25
).date!
let end = calendar.date(byAdding: .day, value: 20, to: start)!
let range = start..<end

print("startOfDay(for:):", calendar.startOfDay(for: start))

calendar.enumerateDates(
    startingAfter: start,
    matching: DateComponents(hour: 9, minute: 30),
    matchingPolicy: .nextTime,
    repeatedTimePolicy: .first,
    direction: .forward
) { date, exactMatch, stop in
    print("enumerateDates:", date as Any, "exact:", exactMatch)
    stop = true
}

let nextNineThirty = calendar.nextDate(
    after: start,
    matching: DateComponents(hour: 9, minute: 30),
    matchingPolicy: .nextTime,
    repeatedTimePolicy: .first,
    direction: .forward
)
print("nextDate(after:matching:...):", nextNineThirty as Any)

let everyTwoDays = calendar.dates(
    byAdding: .day,
    value: 2,
    startingAt: start,
    in: range,
    wrappingComponents: false
)
print("dates(byAdding:value:startingAt:in:):", Array(everyTwoDays.prefix(4)))

let everyThreeDays = calendar.dates(
    byAdding: DateComponents(day: 3),
    startingAt: start,
    in: range,
    wrappingComponents: false
)
print("dates(byAdding:DateComponents...):", Array(everyThreeDays.prefix(4)))

let mondaysAtNine = calendar.dates(
    byMatching: DateComponents(hour: 9, minute: 0, weekday: 2),
    startingAt: start,
    in: range,
    matchingPolicy: .nextTime,
    repeatedTimePolicy: .first,
    direction: .forward
)
print("dates(byMatching:...):", Array(mondaysAtNine.prefix(3)))
