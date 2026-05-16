//: # Business Timezone
//:
//: User timezone and business timezone can produce different calendar days for
//: the same payment or ledger instant.

import Foundation

let paymentExecutionInstant = Date()

let userCalendar = Calendar.current

var businessCalendar = Calendar(identifier: .gregorian)
businessCalendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

print(userCalendar.component(.day, from: paymentExecutionInstant))
print(businessCalendar.component(.day, from: paymentExecutionInstant))
