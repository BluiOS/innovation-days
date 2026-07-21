import SwiftUI

// ════════════════════════════════════════════════════════════════════════════
//  STEP 14 — The MISSING method: there is no buildArray in @ViewBuilder
// ════════════════════════════════════════════════════════════════════════════
//
// The callback to buildArray: no buildArray → no `for`. ViewBuilder leaves it out
// on purpose, so the fix is a View that REPRESENTS a loop: ForEach.

struct Item: Identifiable { let id = UUID(); let name: String }
let items = [Item(name: "Apple"), Item(name: "Banana"), Item(name: "Cherry")]

// ── THE COMPILE-ERROR VERSION ─────────────────────────────────────────────────
// ViewBuilder does NOT define buildArray, so this does not compile:

// ("Uncommentable")
//   VStack {
//       for item in items {          // Closure containing control flow statement
//           Text(item.name)          // cannot be used with result builder 'ViewBuilder'
//       }
//   }
//
// Why omit it? A `for` makes a runtime-length list, but ViewBuilder's promise is a
// compile-time-known tuple shape. A loop would defeat the static-tree diffing.


// ── THE FIX: ForEach is itself a View, not a loop ─────────────────────────────
// And it carries an EXPLICIT identity key (id: / Identifiable) — the thing you
// hand-managed with IndexPaths and reloadRows in a UITableView.
struct Fruits: View {
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(items) { item in     // ForEach<[Item], UUID, Text> — one typed node
                Text(item.name)
            }
        }
    }
}

// ("Executable")
print(type(of: Fruits().body))

// ("Executable")  — renders the list live
import PlaygroundSupport
PlaygroundPage.current.setLiveView(Fruits().padding())

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
