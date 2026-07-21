# Step 12 — `@ViewBuilder` is just one of these builders

> `@ViewBuilder` is the `ValidationRuleBuilder` from the last 10 steps, with
> exactly **one** change: the partial-result type isn't `[any StringValidationRule]`
> — it's the **view's own static type**, encoded into the generics. SwiftUI keeps
> the structure of your UI in the type system instead of in an array.

That single decision — **the type IS the tree** — is the whole reason SwiftUI
feels alien coming from UIKit. Everything in the next four steps is a consequence
of it.

> **Where the feature actually lives.** Result builders are a *Swift language*
> feature — the `@resultBuilder` attribute. `ViewBuilder` is just one concrete
> builder type that *SwiftUI* supplies (Apple's docs list it as
> `SwiftUI.ViewBuilder`). Clean teaching sentence: **result builders belong to
> Swift; `ViewBuilder` belongs to SwiftUI.** It is not "a SwiftUI feature" — SwiftUI
> is only its most visible user, exactly like our own `ValidationRuleBuilder`.

## Erase vs. preserve

| | partial-result type | what it does to each statement |
|---|---|---|
| `ValidationRuleBuilder` | `[any StringValidationRule]` | **erases** the concrete rule type |
| `@ViewBuilder` | `TupleView<(C0, C1, …)>` | **preserves** every concrete type |

```swift
VStack { Text("Welcome"); Image(systemName: "star"); Button("Tap") {} }
// static type:  VStack<TupleView<(Text, Image, Button)>>
```

## Why "the type is the tree" is the entire trick

In UIKit you build a tree of *objects* at runtime (`addSubview`, mutate, keep
references) and reconciliation is **your** job.

SwiftUI inverts it. Your `body` is a **pure function returning a value** — a
deeply-nested generic struct describing the desired tree. The framework calls
`body`, gets a new value, and reconciles it against the old one.

The static type gives SwiftUI a **compile-time description of fixed structure**:
child count, order, and branch shape (`TupleView<(Text, Image, Button)>` = "three
children, these kinds, this order") — at compile time, with zero runtime
inspection of arbitrary objects.

> **Don't over-promise the runtime.** This is *not* "compare leaves, redraw the
> changed ones." Actual updates are still driven by state dependencies, identity,
> dynamic properties, environment, layout, and transactions — a parent `body` can
> recompute even when only a small part visually changes. The win is narrower and
> real: SwiftUI isn't *discovering the basic tree shape by inspecting runtime
> objects* the way UIKit does; the type handed it that shape for free.

`@ViewBuilder` is the machine that **produces those typed trees** from the
readable closure you wrote. `some View` (an opaque return type) is what makes the
monster type **bearable to write** — the compiler knows the exact type; you don't
have to spell it out.
