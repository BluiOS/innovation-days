# Step 11 — The full builder, wired together

All seven methods on one type, plus a `Validator.init(@ValidationRuleBuilder …)`
so the call site reads `Validator { … }`. The example is the **real**
`BusinessNameRegister` rule set — control flow and all — rewritten as a builder.

## The complete transform order

For each statement in a builder closure:

1. **Expression** `e` → `buildExpression(e)` if defined, else used directly.
2. **`if` without `else`** → inner block built, wrapped in `buildOptional(_:)`.
3. **`if/else`, `switch`** → each branch built, then `buildEither(first:/second:)`,
   nested into a tree for >2 branches.
4. **`for…in`** → each iteration collected into `[PartialResult]`, then
   `buildArray(_:)`.
5. **`if #available`** → branch built, then `buildLimitedAvailability(_:)`, then
   the usual optional/either wrapping.
6. **Combine the block** → `buildBlock(_:...)` *(all at once)* **OR**
   `buildPartialBlock(first:)` + `(accumulated:next:)` *(fold)*.
7. **Block's final value** → `buildFinalResult(_:)` if defined, else as-is.

## What's allowed (the pay-to-play list)

- No `buildOptional` & no `buildEither` → **no `if`**.
- No `buildEither` → **no `if/else`, no `switch`**.
- No `buildArray` → **no `for` loops**.
- `let`/`var` declarations and plain assignments are **left untouched** — they
  execute but are not collected, so local helpers inside the closure are fine.

## The mental model to keep

> A result builder is a `reduce` over the statements of a closure, where the
> compiler writes the `reduce` for you and your build methods are the combining
> logic.

- `buildExpression` → the `map` step
- `buildBlock` / `buildPartialBlock` → the `reduce`
- `buildOptional` / `buildEither` / `buildArray` → branches and loops
- `buildFinalResult` → the final `map` on the output

Everything **in the result-builder family** — `@ViewBuilder`, RegexBuilder-style
DSLs, and our `ValidationRuleBuilder` — is this **exact set of methods** with a
different partial-result type. The mechanism never changes; only the accumulated
type gets more sophisticated.

> **Not everything DSL-shaped is a result builder.** `#Predicate` *feels* similar
> at the call site, but it's a **macro** — it expands closure syntax, it has no
> `buildBlock`/`buildExpression`/`buildEither`/… It's a useful *contrast*, not a
> member of this mechanism. Same surface feel, different compiler machinery.

Next: SwiftUI swaps our humble array for *the view's own static type* — and that
one substitution is the whole reason SwiftUI feels alien.
