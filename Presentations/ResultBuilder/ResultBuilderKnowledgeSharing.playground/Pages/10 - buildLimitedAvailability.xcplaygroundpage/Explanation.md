# Step 10 — `buildLimitedAvailability`

Unlocks **`if #available(...)`** inside the block.

```swift
static func buildLimitedAvailability(_ part: [any StringValidationRule]) -> [any StringValidationRule] { part }
```

The result of an `#available` block passes through this method **in addition to**
the usual `buildOptional` / `buildEither` wrapping around the availability block.

## Why the method exists

So a **newer-OS-only type can be erased**. If an `#available` block produced a
type that only exists on, say, iOS 16+, that concrete type can't appear in the
static type of code that also runs on iOS 15. `buildLimitedAvailability` is the
hook to erase it.

For a **homogeneous** builder like ours, the partial type is the same on every
OS, so this is a plain **identity pass-through**.

> 🔮 SwiftUI makes this concrete: its `buildLimitedAvailability` erases to
> **`AnyView`** — the one place `@ViewBuilder` deliberately throws the type away.
> Step 13.

That's the **last of the build methods**. Next step: wire all seven together into
the real thing.
