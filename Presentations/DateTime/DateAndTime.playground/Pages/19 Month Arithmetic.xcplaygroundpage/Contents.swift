//: # Month Arithmetic
//:
//: Adding one calendar month is not the same kind of operation as adding a
//: fixed duration. End-of-month behavior needs product rules.

import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(secondsFromGMT: 0)!

let jan31 = DateComponents(
    calendar: calendar,
    year: 2026,
    month: 1,
    day: 31
).date!

print(calendar.date(byAdding: .month, value: 1, to: jan31) as Any)
