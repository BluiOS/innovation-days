//: # Week Year Versus Calendar Year
//:
//: `YYYY` is the week-based year. Use `yyyy` when you mean calendar year.
//: The difference appears near New Year boundaries.

import Foundation

let formatter = DateFormatter()
formatter.locale = Locale(identifier: "en_US_POSIX")
formatter.timeZone = TimeZone(secondsFromGMT: 0)

formatter.dateFormat = "YYYY-MM-dd"
print("Week year:", formatter.string(from: Date()))

formatter.dateFormat = "yyyy-MM-dd"
print("Calendar year:", formatter.string(from: Date()))
