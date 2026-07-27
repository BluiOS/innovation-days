# Step 02 — What is `@resultBuilder`?

`@resultBuilder` is an attribute you put on a **type** (`struct`/`enum`/`class`).
That type becomes a **bag of static rewrite rules**:

- It is **never instantiated**. It holds no state. It's just a namespace of
  `static func`s the compiler calls.
- The compiler looks at a closure annotated with `@YourBuilder` and rewrites its
  statements into calls to those static methods.

## The one design rule: pick ONE partial-result type

The single most important discipline: **pick one "partial result" type and make
every build method consume and produce it.**

For us that type is `[any StringValidationRule]`. SwiftUI's `ViewBuilder` uses a
type-preserving `TupleView` instead — but the principle is identical. With
consistent types, the methods compose cleanly.

## The roadmap — every method maps to a `reduce`

| Build method | Role in the fold |
|---|---|
| `buildExpression` | the `map` step (intake / normalize) |
| `buildBlock` / `buildPartialBlock` | the `reduce` (combine statements) |
| `buildOptional` / `buildEither` / `buildArray` | branches & loops |
| `buildFinalResult` | the final `map` on the output |

A builder with **no `buildBlock`** can't combine anything — the `@resultBuilder`
attribute rejects the *declaration itself* ("must provide at least one static
`buildBlock`…"). So the smallest thing the attribute accepts is a type with
`buildBlock`, and that's exactly Step 03.

> **Mental model:** A result builder is a `reduce` over the statements of a
> closure, where the compiler writes the `reduce` for you and your build methods
> are the combining logic.
