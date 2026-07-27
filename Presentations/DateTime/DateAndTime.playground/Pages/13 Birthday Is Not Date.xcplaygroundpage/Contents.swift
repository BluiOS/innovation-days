//: # Birthday Is Not Date
//:
//: A birthday is a recurring local calendar concept, not an exact instant on
//: the timeline.

import Foundation

struct Birthday {
    let month: Int
    let day: Int
}

let birthday = Birthday(month: 1, day: 11)
print(birthday)
