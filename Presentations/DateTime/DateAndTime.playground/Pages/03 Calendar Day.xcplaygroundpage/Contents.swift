//: # Calendar Day
//:
//: Calendar arithmetic asks a calendar/timezone rule system what "one day
//: later" means in local civil time.

import Foundation

let now = Date()

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let sameLocalTimeTomorrow = calendar.date(
    byAdding: .day,
    value: 1,
    to: now
)

print(sameLocalTimeTomorrow as Any)
