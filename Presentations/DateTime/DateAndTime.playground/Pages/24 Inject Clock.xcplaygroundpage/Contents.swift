//: # Inject Clock
//:
//: Code that depends on "now" should receive a clock. That makes behavior
//: deterministic when you need to exercise date/time boundaries.

import Foundation

protocol Clock {
    var now: Date { get }
}

struct SystemClock: Clock {
    var now: Date { Date() }
}

struct FixedClock: Clock {
    let now: Date
}
