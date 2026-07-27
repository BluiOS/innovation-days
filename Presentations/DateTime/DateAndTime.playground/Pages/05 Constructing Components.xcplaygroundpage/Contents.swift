//: # Constructing Components
//:
//: Local date/time components can be invalid or ambiguous around daylight
//: saving transitions.

import Foundation

var components = DateComponents()
components.calendar = Calendar(identifier: .gregorian)
components.timeZone = TimeZone(identifier: "Europe/Amsterdam")
components.year = 2025
components.month = 3
components.day = 29
components.hour = 2
components.minute = 30

let date = components.date

print(date as Any)
