//: # Timezone Is Not Offset
//:
//: A fixed offset is only a number. A real timezone identifier points to a
//: set of historical and future civil-time rules.

import Foundation

let fixedOffset = TimeZone(secondsFromGMT: 3 * 60 * 60)
let realTimeZone = TimeZone(identifier: "Europe/Istanbul")

print(fixedOffset as Any)
print(realTimeZone as Any)
