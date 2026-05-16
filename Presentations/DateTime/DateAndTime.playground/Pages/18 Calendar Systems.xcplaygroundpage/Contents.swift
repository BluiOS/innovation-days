//: # Calendar Systems
//:
//: The same instant can have different year values depending on the calendar
//: system used to interpret it.

import Foundation

let date = Date()

let gregorian = Calendar(identifier: .gregorian)
let persian = Calendar(identifier: .persian)
let islamic = Calendar(identifier: .islamic)

print(gregorian.component(.year, from: date))
print(persian.component(.year, from: date))
print(islamic.component(.year, from: date))
