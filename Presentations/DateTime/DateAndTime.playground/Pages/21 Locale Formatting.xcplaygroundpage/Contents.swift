//: # Locale Formatting
//:
//: The same instant can produce different display text in different locales.

import Foundation

let date = Date()

let us = date.formatted(
    .dateTime
        .year()
        .month(.wide)
        .day()
        .locale(Locale(identifier: "en_US"))
)

let nl = date.formatted(
    .dateTime
        .year()
        .month(.wide)
        .day()
        .locale(Locale(identifier: "nl_NL"))
)

print(us)
print(nl)
