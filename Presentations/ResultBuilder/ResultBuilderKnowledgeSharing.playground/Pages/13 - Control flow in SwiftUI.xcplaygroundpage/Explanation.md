# Step 13 — Control flow: the same methods, but the types carry meaning

You already know the desugaring. In SwiftUI the only difference is **which
concrete `View` type comes out** of each method.

| statement | method | our result | SwiftUI result |
|---|---|---|---|
| `if` (no else) | `buildOptional` | `[Rule]` (`?? []`) | `Content?` (`Optional` is a `View`) |
| `if/else`, `switch` | `buildEither` | `[Rule]` (erased) | `_ConditionalContent<A, B>` |
| `if #available` | `buildLimitedAvailability` | `[Rule]` (identity) | **`AnyView`** (erases) |

- **`buildOptional → Content?`** — SwiftUI makes `Optional` conform to `View`. An
  absent `if` branch is `nil` and renders as nothing. No `EmptyView` shuffle.
  > 📎 **Naming trap.** The Swift *language* hook is `buildOptional(_:)`, but
  > SwiftUI's public `ViewBuilder` docs expose the corresponding operation as
  > `buildIf(_:)` (also `-> Content?`). Same role — an `if` without `else` produces
  > optional content. If someone searches Apple docs for
  > `ViewBuilder.buildOptional` and finds `buildIf`, that's why.
- **`buildEither → _ConditionalContent<A, B>`** — the payoff of *"why two
  methods."* The branches can be **completely different types** (`Text` vs
  `ProgressView`); `_ConditionalContent` is one type that holds either.
- **`buildLimitedAvailability → AnyView`** — the *one* place `@ViewBuilder`
  deliberately throws the type away, because a too-new type can't appear in code
  that also runs on an older OS.

## ⚠️ UIKit-brain gotcha #1 — branch switching destroys state

Because `_ConditionalContent<A, B>` represents A and B as **structurally distinct
positions** in the tree, switching from the `first` branch to the `second` is, to
SwiftUI, *"view A left the tree, view B entered."* Any `@State`, scroll position,
or in-flight animation in the old branch is **discarded** — not preserved.

This surprises every UIKit engineer once. The fix when you want continuity: keep
**one** view and change its inputs, rather than `if/else`-ing between two views.
