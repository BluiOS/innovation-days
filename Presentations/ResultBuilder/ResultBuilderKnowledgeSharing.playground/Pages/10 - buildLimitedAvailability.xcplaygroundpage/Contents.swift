import Foundation

// ════════════════════════════════════════════════════════════════════════════
//  STEP 10 — buildLimitedAvailability   (taming `if #available`)
// ════════════════════════════════════════════════════════════════════════════
//
// Identity for us. The point of the method is to ERASE a too-new type — which is
// exactly what SwiftUI does with it (it erases to AnyView).

// ── THE COMPILE-ERROR VERSION ─────────────────────────────────────────────────
// An `if #available(...)` block needs this method (on top of the usual wrapping):

// ("Uncommentable")
//   makeRules {
//       if #available(iOS 16, *) {
//           RegexValidationRule(regularExpression: .localizedPostalCode, description: "iOS16-only rule")
//       }
//   }


// ── THE METHOD + SAMPLE IMPL ──────────────────────────────────────────────────
// ("Executable")
@resultBuilder
enum ValidationRuleBuilder {
    static func buildExpression(_ rule: any StringValidationRule) -> [any StringValidationRule] { [rule] }
    static func buildBlock(_ parts: [any StringValidationRule]...) -> [any StringValidationRule] { parts.flatMap { $0 } }
    static func buildOptional(_ part: [any StringValidationRule]?) -> [any StringValidationRule] { part ?? [] }

    /// For a homogeneous builder like ours it's an identity pass-through; SwiftUI
    /// uses it to erase a too-new concrete type.
    static func buildLimitedAvailability(_ part: [any StringValidationRule]) -> [any StringValidationRule] { part }
}

func makeRules(@ValidationRuleBuilder _ content: () -> [any StringValidationRule]) -> [any StringValidationRule] {
    content()
}

let rules = makeRules {
    RegexValidationRule(regularExpression: .notEmpty, description: "Required")
    if #available(iOS 16, *) {
        RegexValidationRule(regularExpression: .localizedPostalCode, description: "iOS16-only rule")
    }
}

print(rules.map(\.description))   // ["Required", "iOS16-only rule"]


// ── TRANSLATED TO WHAT? ───────────────────────────────────────────────────────
// The availability branch is built, wrapped in buildLimitedAvailability, then the
// usual optional/either wrapping applies on top:
//
//   let avail: [any StringValidationRule]
//   if #available(iOS 16, *) {
//       avail = ValidationRuleBuilder.buildLimitedAvailability(
//                   ValidationRuleBuilder.buildBlock( ... ))
//   }
//
// Identity for us — but this is the slot where SwiftUI erases to AnyView.

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
