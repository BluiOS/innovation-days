import SwiftUI

// ════════════════════════════════════════════════════════════════════════════
//  STEP 13 — Control flow: SAME methods you learned, but the TYPES carry meaning
// ════════════════════════════════════════════════════════════════════════════
//
// Same desugaring as our builder. In SwiftUI the difference is always WHICH
// concrete View type comes out.

// ── if (no else)  →  buildOptional  →  Optional<V> ────────────────────────────
//   public static func buildOptional<Content: View>(_ content: Content?) -> Content?
//
// SwiftUI makes Optional itself conform to View. An absent `if` branch is `nil` →
// renders nothing. The optionality lives in the type.
// Naming trap: the language hook is buildOptional(_:), but SwiftUI's public
// ViewBuilder docs call this buildIf(_:) — same role, same `-> Content?`.

struct Badge: View {
    let isPro: Bool
    var body: some View {
        VStack {
            Text("Account")
            if isPro {
                Text("PRO").bold()      // buildOptional → Text?
            }
        }
    }
}

// ── if/else, switch  →  buildEither  →  _ConditionalContent<A, B> ─────────────
//   public static func buildEither<T: View, F: View>(first:  T) -> _ConditionalContent<T, F>
//   public static func buildEither<T: View, F: View>(second: F) -> _ConditionalContent<T, F>
//
// The payoff of "why two methods": the two branches can be COMPLETELY DIFFERENT
// types (Text vs ProgressView), and _ConditionalContent holds either one.
//
// The gotcha that bites every UIKit engineer once: switching from the `if` branch
// to the `else` is, to SwiftUI, "view A left the tree, view B entered" — any
// @State, scroll position, or animation in the old branch is DISCARDED. For
// continuity, keep one view and change its inputs instead of if/else-ing.

struct LoadState: View {
    let isLoading: Bool
    var body: some View {
        if isLoading {
            ProgressView()              // buildEither(first:)
        } else {
            Text("Done")                // buildEither(second:)  ← different type, same slot
        }
    }
}

// ── if #available  →  buildLimitedAvailability  →  AnyView  (the erasing one) ──
//   public static func buildLimitedAvailability<C: View>(_ content: C) -> AnyView
//
// Ours was identity. SwiftUI uses THIS spot to throw the type away: a too-new
// concrete type can't appear in a function that also runs on an older OS, so it's
// boxed in AnyView.

// ("Executable")  — run, then read the printed _ConditionalContent type
print(type(of: LoadState(isLoading: true).body))   // _ConditionalContent<ProgressView, Text>

// ("Executable")  — renders both views live
import PlaygroundSupport
PlaygroundPage.current.setLiveView(
    VStack(spacing: 24) {
        Badge(isPro: true)
        LoadState(isLoading: false)
    }.padding()
)

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
