import SwiftUI

// ════════════════════════════════════════════════════════════════════════════
//  STEP 16 — The type IS the tree   (wrap-up)
// ════════════════════════════════════════════════════════════════════════════
//
// You didn't learn SwiftUI today — you learned one Swift language feature, and
// SwiftUI is its most ambitious use.

// ── THE MAPPING: same seven methods, ONE difference (the partial-result type) ──
//
//  ValidationRuleBuilder (ours)                →  @ViewBuilder (SwiftUI)
//  ───────────────────────────────────────────────────────────────────────────
//  partial result [any StringValidationRule]  →  the view's own static type,
//                                                 e.g. TupleView<(Text, Image)>
//  buildExpression -> [rule]                   →  buildExpression<C: View>(C) -> C   (identity)
//  buildBlock(...) -> [rule]                   →  buildBlock<C0,…>(…) -> TupleView<(C0,…)>
//  buildOptional -> part ?? []                 →  buildOptional(C?) -> C?   (Optional is a View)
//  buildEither   (erased to the array)         →  buildEither -> _ConditionalContent<A, B>
//  buildArray    (for loops)                   →  ABSENT → use ForEach instead
//  buildLimitedAvailability  (identity)        →  erases to AnyView
//  buildFinalResult -> Validator               →  (unused; body returns the tuple directly)
//
// The only real difference: type-ERASED array vs type-PRESERVING generic tree.
// Value-type views, automatic diffing, identity-driven state, the ForEach/Group
// quirks, the 10-view ghost, branch-switch state loss — all fall out of that one
// substitution: from [any StringValidationRule] to a type that IS the tree.

// One last look — the whole UI, including the branch, spelled out as a type:
struct Demo: View {
    var body: some View {
        VStack {
            Text("A")
            if Bool.random() { Text("B") } else { Image(systemName: "star") }
        }
    }
}

// ("Executable")
print(type(of: Demo().body))
// e.g. VStack<TupleView<(Text, _ConditionalContent<Text, Image>)>>

//: [◀︎ Previous](@previous)
