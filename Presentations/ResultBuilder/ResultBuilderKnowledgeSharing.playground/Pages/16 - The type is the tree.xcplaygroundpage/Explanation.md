# Step 16 — The type is the tree (wrap-up)

## The mapping back to what you already know

| `ValidationRuleBuilder` (Steps 01–11) | `@ViewBuilder` (SwiftUI) |
|---|---|
| partial result `[any StringValidationRule]` | the view's own static type, e.g. `TupleView<…>` |
| `buildExpression` → `[rule]` | `buildExpression<C: View>(C) -> C` (identity) |
| `buildBlock(…) -> [rule]` | `buildBlock<C0,…>(…) -> TupleView<(C0,…)>` |
| `buildOptional` → `part ?? []` | `buildOptional(C?) -> C?` (`Optional` is a `View`) |
| `buildEither` (erased to the array) | `buildEither -> _ConditionalContent<A, B>` |
| `buildArray` (for loops) | **absent** → use `ForEach` |
| `buildLimitedAvailability` identity | erases to `AnyView` |
| `buildFinalResult -> Validator` | (unused; `body` returns the tuple directly) |

Same **seven methods**. The *only* real difference is the partial-result type
went from a type-erased array to a type-preserving generic tree. Everything that
feels novel about SwiftUI — value-type views, automatic diffing, identity-driven
state, the `ForEach`/`Group` quirks, the 10-view ghost, branch-switch state loss
— falls out of that one substitution: from `[any StringValidationRule]` to a type
that **is** the tree.

## The mental model to keep

> **UIKit:** you build and mutate a tree of *objects*, and reconciliation is your
> job.
> **SwiftUI:** `@ViewBuilder` turns your closure into a **typed value** describing
> the tree, and the framework **diffs that value** for you. The type system *is*
> the tree.

Step 11's closing line said every builder is "this exact set of methods with a
fancier partial-result type." `@ViewBuilder` is the canonical proof: the fancier
type is *the structure of your UI itself*.
