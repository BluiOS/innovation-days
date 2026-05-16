//: # Stable Test Context
//:
//: Fix calendar, timezone, and locale around date/time logic so results do not
//: depend on the user's device settings.

import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(secondsFromGMT: 0)!

let locale = Locale(identifier: "en_US_POSIX")
let timezone = TimeZone(secondsFromGMT: 0)!

print(calendar)
print(locale)
print(timezone)
