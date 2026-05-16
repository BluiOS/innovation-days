//: # Date.FormatStyle
//:
//: Modern Swift format styles are declarative and locale-aware. Use them for
//: display strings instead of hand-built date text.

import Foundation

let date = Date()

let text = date.formatted(
    .dateTime
        .year()
        .month(.wide)
        .day()
        .hour()
        .minute()
)

print(text)
