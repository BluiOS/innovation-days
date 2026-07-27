import SwiftUI

// ════════════════════════════════════════════════════════════════════════════
//  STEP 15 — The 10-view cap, and how buildPartialBlock lifted it
// ════════════════════════════════════════════════════════════════════════════
//
// Closes the loop on the fold: same pairwise left-fold from the homogeneous
// builder — and with it, the famous 10-view limit is gone.

// ── THE VARIADIC-vs-LADDER PROBLEM ────────────────────────────────────────────
// Each view is a DIFFERENT type, so ViewBuilder couldn't use one variadic
// buildBlock — it needed an overload per arity. Apple wrote ten and stopped:
//
//   buildBlock<C0>(C0) -> TupleView<(C0)>
//   buildBlock<C0, C1>(C0, C1) -> TupleView<(C0, C1)>
//   ...
//   buildBlock<C0, ..., C9>(...) -> TupleView<(C0, ..., C9)>     // ← the last one
//
// Hence the historical rule: at most 10 direct children. An eleventh was a compile
// error, and the workaround was to wrap children in a Group:
//
//   VStack {
//       Group { v0; v1; ...; v9 }     // 10 here
//       Group { v10; v11; ... }       // and more here
//   }


// ── Swift 5.7 / iOS 16: buildPartialBlock, the pairwise left-fold ─────────────
//   static func buildPartialBlock<C: View>(first: C) -> C
//   static func buildPartialBlock<Acc: View, Next: View>(accumulated: Acc, next: Next)
//       -> TupleView<(Acc, Next)>
//
// Folding two-at-a-time means any number of statements, each a different type, with
// just two methods. Same mechanism as the homogeneous builder; only twist is the
// accumulator is a growing nested TupleView instead of a flat array.

struct ManyRows: View {
    var body: some View {
        VStack {
            Text("1"); Text("2"); Text("3"); Text("4");  Text("5");  Text("6")
            Text("7"); Text("8"); Text("9"); Text("10"); Text("11"); Text("12")
        }   // 12 children — would NOT have compiled before iOS 16
    }
}

// ("Executable")  — read the deeply nested TupleView aloud
print(type(of: ManyRows().body))

// ("Executable")  — renders the 12 rows live
import PlaygroundSupport
PlaygroundPage.current.setLiveView(ManyRows().padding())

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
