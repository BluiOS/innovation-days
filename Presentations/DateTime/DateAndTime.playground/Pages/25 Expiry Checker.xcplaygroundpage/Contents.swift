//: # Expiry Checker
//:
//: This example uses an injected clock to compare an expiry instant with a
//: controlled "now" value.

import Foundation

protocol Clock {
    var now: Date { get }
}

struct FixedClock: Clock {
    let now: Date
}

struct ExpiryChecker {
    let clock: Clock

    func isExpired(_ expiryDate: Date) -> Bool {
        expiryDate < clock.now
    }
}

let now = ISO8601DateFormatter().date(from: "2026-04-30T12:00:00Z")!
let expiry = ISO8601DateFormatter().date(from: "2026-04-29T12:00:00Z")!
let checker = ExpiryChecker(clock: FixedClock(now: now))

print(checker.isExpired(expiry))
