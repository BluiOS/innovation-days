# Step 15 — The 10-view cap, and how `buildPartialBlock` lifted it

This is the variadic-vs-ladder problem from Step 08, made real.

Because each view is a **different** type, `ViewBuilder` couldn't use one variadic
`buildBlock` — it needed a hand-written overload **per arity**. Apple wrote them
up to ten:

```swift
buildBlock<C0, …, C9>(…) -> TupleView<(C0, …, C9)>
```

…and stopped. That's the famous historical rule: **a `@ViewBuilder` block could
hold at most 10 direct children.** An eleventh was a compile error, and the
workaround was to wrap children in a `Group`.

## The fix: a pairwise left-fold

Swift 5.7 / iOS 16 added `buildPartialBlock`:

```swift
static func buildPartialBlock<C: View>(first: C) -> C
static func buildPartialBlock<Acc: View, Next: View>(accumulated: Acc, next: Next)
    -> TupleView<(Acc, Next)>
```

Folding two-at-a-time means **any number of statements, each a different type,
with just two methods** — so the 10-view cap is gone on modern SwiftUI.

It's the **same mechanism** you saw with `ValidationRuleBuilder` on Step 08. The
only twist: the accumulator here is a **growing nested `TupleView`** instead of a
flat `[any StringValidationRule]`.
