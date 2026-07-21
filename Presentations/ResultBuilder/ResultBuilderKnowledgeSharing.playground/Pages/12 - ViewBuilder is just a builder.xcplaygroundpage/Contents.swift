import SwiftUI

// ════════════════════════════════════════════════════════════════════════════
//  STEP 12 — @ViewBuilder is just one of these builders
//            (the partial-result type is the VIEW'S OWN STATIC TYPE)
// ════════════════════════════════════════════════════════════════════════════
//
// The type IS the tree. SwiftUI keeps the structure of your UI in the type system
// instead of in an array — that single change is why it feels alien from UIKit.

// ── @ViewBuilder IS a real, ordinary result builder ───────────────────────────
// Result builders belong to Swift; ViewBuilder belongs to SwiftUI:
//   • Swift language feature ......... @resultBuilder
//   • Framework-provided builder ..... SwiftUI.ViewBuilder
//   • Your own builder ............... ValidationRuleBuilder
// Conceptually ViewBuilder looks like what you'd now write yourself:
//
//   @resultBuilder public struct ViewBuilder {
//       static func buildBlock() -> EmptyView                                   // empty
//       static func buildBlock<C: View>(_ c: C) -> C                            // single → pass through
//       static func buildBlock<C0: View, C1: View>(_ c0: C0, _ c1: C1)          // ...one overload
//           -> TupleView<(C0, C1)>                                              //    per arity, up to 10
//   }
//
// ValidationRuleBuilder ERASED each statement → [any StringValidationRule].
// ViewBuilder does the OPPOSITE: it PRESERVES each concrete type into
// TupleView<(C0, C1, ...)>. Nothing is thrown away.

struct WelcomeCard: View {
    var body: some View {
        VStack {
            Text("Welcome")
            Image(systemName: "star")
            Button("Tap") { }
        }
    }
}

// ── TRANSLATED TO WHAT? ───────────────────────────────────────────────────────
// The VStack content closure desugars (conceptually) to:
//
//   VStack(content: {
//       ViewBuilder.buildBlock(Text("Welcome"), Image(systemName: "star"), Button("Tap") { })
//   })
//
// the closure's type is:   () -> TupleView<(Text, Image, Button)>
// so the whole thing is:   VStack<TupleView<(Text, Image, Button)>>
//
// That nested generic is the ACTUAL static type of your stack — the view hierarchy
// spelled out in the type. Stare at it until it stops looking weird.

// ("Executable")  — run, then read the printed type aloud
print(type(of: WelcomeCard().body))


// ── WHERE @ViewBuilder IS APPLIED FOR YOU ─────────────────────────────────────
//   protocol View { associatedtype Body: View; @ViewBuilder var body: Body { get } }
//   struct VStack<Content: View>: View { init(@ViewBuilder content: () -> Content) }
//
// That's why `var body: some View { … }` lets you write bare views with no commas
// and ifs/switches in the middle — `body` is a builder closure. `some View` is the
// OPAQUE type that makes that monster type bearable to write: the compiler knows
// the exact type; you don't have to.

// ("Executable")  — renders the real VStack in the live view
import PlaygroundSupport
PlaygroundPage.current.setLiveView(WelcomeCard().padding())

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
