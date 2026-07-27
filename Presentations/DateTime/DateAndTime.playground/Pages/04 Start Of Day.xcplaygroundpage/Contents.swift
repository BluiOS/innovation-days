//: # Start Of Day
//:
//: Day boundaries depend on calendar and timezone. Do not assume that manually
//: selecting `00:00` is always the right way to model the beginning of a day.
//:
//: This example uses 1 Farvardin 1398 in the Persian calendar, a real case
//: where manually constructing midnight can expose timezone/calendar surprises.

import Foundation

var calendar = Calendar(identifier: .persian)
calendar.timeZone = TimeZone(identifier: "Asia/Tehran")!

let farvardinOneAtMidnight = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 1398,
    month: 1,
    day: 1,
    hour: 0,
    minute: 0
).date

print("Manual 00:00:", farvardinOneAtMidnight as Any)

let noonOnFarvardinOne = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 1398,
    month: 1,
    day: 1,
    hour: 12,
    minute: 0
).date!

let startOfFarvardinOne = calendar.startOfDay(for: noonOnFarvardinOne)

print("Calendar startOfDay:", startOfFarvardinOne)
