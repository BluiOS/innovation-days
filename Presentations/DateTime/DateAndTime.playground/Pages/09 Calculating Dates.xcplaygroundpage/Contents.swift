//: # Calculating Dates From Components
//:
//: Calendar date construction can fail or resolve differently around invalid
//: and ambiguous local times. Use explicit methods and policies.

import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let base = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 2026,
    month: 3,
    day: 29,
    hour: 12
).date!

let dateFromComponents = calendar.date(from: DateComponents(
    timeZone: calendar.timeZone,
    year: 2026,
    month: 4,
    day: 28,
    hour: 9
))
print("date(from:):", dateFromComponents as Any)

let byAddingComponents = calendar.date(
    byAdding: DateComponents(month: 1, day: 1),
    to: base,
    wrappingComponents: false
)
print("date(byAdding:DateComponents...):", byAddingComponents as Any)

let byAddingOneDay = calendar.date(
    byAdding: .day,
    value: 1,
    to: base,
    wrappingComponents: false
)
print("date(byAdding:value:to:):", byAddingOneDay as Any)

let firstDayOfMonth = calendar.date(bySetting: .day, value: 1, of: base)
print("date(bySetting:value:of:):", firstDayOfMonth as Any)

let nextAvailableTwoThirty = calendar.date(
    bySettingHour: 2,
    minute: 30,
    second: 0,
    of: base,
    matchingPolicy: .nextTime,
    repeatedTimePolicy: .first,
    direction: .forward
)
print("date(bySettingHour:minute:second:of:):", nextAvailableTwoThirty as Any)
