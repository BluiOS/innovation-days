//: # Extracting Components
//:
//: Component extraction is only meaningful with the right calendar and
//: timezone. The wrong way is to read business fields from `Calendar.current`
//: when the domain has its own calendar/timezone.

import Foundation

let instant = ISO8601DateFormatter()
    .date(from: "2026-04-28T12:30:00Z")!
let later = ISO8601DateFormatter()
    .date(from: "2026-04-30T15:45:00Z")!

print("Wrong for Amsterdam business day:", Calendar.current.component(.day, from: instant))

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

print("component(_:from:):", calendar.component(.day, from: instant))

let fields = calendar.dateComponents(
    [.year, .month, .day, .hour, .minute, .weekday, .era],
    from: instant
)
print("dateComponents(_:from:):", fields)

let matches = calendar.date(instant, matchesComponents: DateComponents(day: 28))
print("date(_:matchesComponents:):", matches)

let elapsedFields = calendar.dateComponents([.day, .hour, .minute], from: instant, to: later)
print("dateComponents(_:from:to:) Date -> Date:", elapsedFields)

let amsterdamNoon = DateComponents(timeZone: TimeZone(identifier: "GMT"), hour: 12)
let tehranEvening = DateComponents(
    timeZone: TimeZone(identifier: "Asia/Tehran"),
    hour: 17
)
let componentDifference = calendar.dateComponents([.hour, .minute], from: amsterdamNoon, to: tehranEvening)
print("dateComponents(_:from:to:) DateComponents -> DateComponents:", componentDifference)

let tehranFields = calendar.dateComponents(
    in: TimeZone(identifier: "Asia/Tehran")!,
    from: instant
)
print("dateComponents(in:from:):", tehranFields)
