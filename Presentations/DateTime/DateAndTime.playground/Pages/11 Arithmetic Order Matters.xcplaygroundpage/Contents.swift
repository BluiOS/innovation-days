//: # Arithmetic Order Matters
//:
//: Calendar arithmetic is not commutative. Adding one day and then one month
//: can produce a different result than adding one month and then one day.

import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(secondsFromGMT: 0)!


let start = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 2026,
    month: 1,
    day: 30,
    hour: 9
).date!

let dayThenMonth = calendar.date(byAdding: .month, value: 1, to:
    calendar.date(byAdding: .day, value: 1, to: start)!
)!

let monthThenDay = calendar.date(byAdding: .day, value: 1, to:
    calendar.date(byAdding: .month, value: 1, to: start)!
)!

print("Start:", start)
print("Day then month:", dayThenMonth)
print("Month then day:", monthThenDay)

// Prefer one combined DateComponents operation when the business rule is
// "add this calendar period" rather than "perform these steps in sequence".
let combined = calendar.date(
    byAdding: DateComponents(month: 1, day: 1),
    to: start,
    wrappingComponents: false
)

print("Combined components:", combined as Any)
