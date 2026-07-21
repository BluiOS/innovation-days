# Step 14 — The missing method: there is **no `buildArray`**

> ⚠️ **UIKit-brain gotcha #2 — you cannot write a `for` loop in `@ViewBuilder`.**

Recall the rule from Step 07: *no `buildArray` → no `for` loops.* `ViewBuilder`
does **not** define `buildArray`. So a `for` inside a `VStack` is a compile error.

## Why it was left out

A `for` loop produces a **runtime-length** list, but `ViewBuilder`'s promise is a
**compile-time-known tuple shape** (`TupleView<(…)>`). A loop would force the
array path (`[AnyView]`-ish), defeating the static-tree diffing that makes SwiftUI
work. So instead of allowing the loop, SwiftUI gives you a **`View` that
represents a loop**:

```swift
VStack {
    ForEach(items) { item in   // ✅ ForEach is itself a View, not a loop
        Text(item.name)
    }
}
```

## `ForEach` is a value, not control flow

`ForEach` is a value of type `ForEach<Data, ID, Content>`. The loop becomes a
**single typed node** in the tree, and it carries an **explicit identity key**
(`id:` / `Identifiable`) so the diffing engine can match rows across updates —
the thing you'd hand-manage with `IndexPath`s and `reloadRows` in a
`UITableView`.

Identity is **mandatory** precisely *because* the framework can't infer it from
positions the way it does for a fixed tuple.
