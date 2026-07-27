//: # Exact Duration
//:
//: Adding `86_400` seconds means exactly 24 elapsed hours.
//: This is not always the same as "same local clock time tomorrow".

import Foundation

let now = Date()
let exactly24HoursLater = now.addingTimeInterval(86_400)

print(now)
print(exactly24HoursLater)
