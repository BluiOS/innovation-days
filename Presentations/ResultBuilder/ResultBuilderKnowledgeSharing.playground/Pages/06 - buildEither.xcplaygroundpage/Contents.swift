import Foundation

// ════════════════════════════════════════════════════════════════════════════
//  STEP 06 — buildEither   (`if / else` and `switch`)
// ════════════════════════════════════════════════════════════════════════════
//
// Why TWO methods instead of one? So the compiler can stamp which branch you took
// into the type system — the exact machinery that later lets a Text and a
// ProgressView share one if/else.

enum Locale { case iran, other }
let locale: Locale = .iran

// ── THE COMPILE-ERROR VERSION ─────────────────────────────────────────────────
// buildOptional covers `if` with no else. An `if/else` (or `switch`) needs buildEither:

// ("Uncommentable")
   makeRules {
       if locale == .iran {
           RegexValidationRule(regularExpression: .localizedMobileNumber, description: "Invalid mobile")
       } else {
           RegexValidationRule(regularExpression: .localizedPhoneNumber, description: "Invalid number")
       }
   }
//   error: closure containing control flow statement cannot be used with result builder
//          ('buildEither(first:)'/'buildEither(second:)' missing)


// ── THE METHOD + SAMPLE IMPL ──────────────────────────────────────────────────
// ("Executable")
@resultBuilder
enum ValidationRuleBuilder {
    static func buildExpression(_ rule: any StringValidationRule) -> [any StringValidationRule] { [rule] }
    static func buildBlock(_ parts: [any StringValidationRule]...) -> [any StringValidationRule] { parts.flatMap { $0 } }
    static func buildOptional(_ part: [any StringValidationRule]?) -> [any StringValidationRule] { part ?? [] }

    static func buildEither(first  part: [any StringValidationRule]) -> [any StringValidationRule] { part }
    static func buildEither(second part: [any StringValidationRule]) -> [any StringValidationRule] { part }
}

func makeRules(@ValidationRuleBuilder _ content: () -> [any StringValidationRule]) -> [any StringValidationRule] {
    content()
}

let rules = makeRules {
    if locale == .iran {
        RegexValidationRule(regularExpression: .localizedMobileNumber, description: "Invalid mobile")
    } else {
        RegexValidationRule(regularExpression: .localizedPhoneNumber, description: "Invalid number")
    }
}

print(rules.map(\.description))   // ["Invalid mobile"]


// ── TRANSLATED TO WHAT? ───────────────────────────────────────────────────────
//   {
//       let r0: [any StringValidationRule]
//       if locale == .iran {
//           r0 = ValidationRuleBuilder.buildEither(first:
//                    ValidationRuleBuilder.buildBlock(ValidationRuleBuilder.buildExpression(
//                        RegexValidationRule(regularExpression: .localizedMobileNumber, description: "Invalid mobile"))))
//       } else {
//           r0 = ValidationRuleBuilder.buildEither(second:
//                    ValidationRuleBuilder.buildBlock(ValidationRuleBuilder.buildExpression(
//                        RegexValidationRule(regularExpression: .localizedPhoneNumber, description: "Invalid number"))))
//       }
//       return ValidationRuleBuilder.buildBlock(r0)
//   }
//
// For us both branches are the same array, so the distinction is cosmetic — but
// it's exactly what lets SwiftUI hold different View types in one if/else.
// A `switch` with N cases becomes a nested tree of these.

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
