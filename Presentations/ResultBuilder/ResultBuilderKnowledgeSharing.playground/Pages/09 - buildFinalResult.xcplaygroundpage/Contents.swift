import Foundation

// ════════════════════════════════════════════════════════════════════════════
//  STEP 09 — buildFinalResult   (transform the collected value, once, at the end)
// ════════════════════════════════════════════════════════════════════════════
//
// The one method that deliberately changes the output type — and only at the
// boundary. buildBlock collects; buildFinalResult converts.

// ── THE SITUATION ─────────────────────────────────────────────────────────────
// So far every block returns a raw [any StringValidationRule]. Let's hand callers
// something nicer — a `Validator` that actually runs the rules.
struct Validator {
    let rules: [any StringValidationRule]

    /// Returns the message of the first failing rule, or nil if all pass.
    func firstError(in value: String) -> String? {
        rules.first { !$0.matches(value) }?.description
    }
}


// ── THE METHOD + SAMPLE IMPL ──────────────────────────────────────────────────
// ("Executable")
@resultBuilder
enum ValidationRuleBuilder {
    static func buildExpression(_ rule: any StringValidationRule) -> [any StringValidationRule] { [rule] }
    static func buildBlock(_ parts: [any StringValidationRule]...) -> [any StringValidationRule] { parts.flatMap { $0 } }

    static func buildFinalResult(_ rules: [any StringValidationRule]) -> Validator {
        Validator(rules: rules)
    }
}

// Note the return type is now `Validator`, not the array:
func makeValidator(@ValidationRuleBuilder _ content: () -> Validator) -> Validator {
    content()
}

let businessName = makeValidator {
    RegexValidationRule(regularExpression: .notEmpty, description: "Required")
    FunctionValidationRule(description: "Min 2 chars") { $0.count >= 2 }
}

print(businessName.firstError(in: "")  as Any)   // Optional("Required")
print(businessName.firstError(in: "A") as Any)   // Optional("Min 2 chars")
print(businessName.firstError(in: "Acme") as Any) // nil


// ── TRANSLATED TO WHAT? ───────────────────────────────────────────────────────
// Same collect as before, plus ONE extra line at the end — the final wrap:
//
//   {
//       let r0 = ValidationRuleBuilder.buildExpression(...)   // Required
//       let r1 = ValidationRuleBuilder.buildExpression(...)   // Min 2 chars
//       let block = ValidationRuleBuilder.buildBlock(r0, r1)  // [any StringValidationRule]
//       return ValidationRuleBuilder.buildFinalResult(block)  // → Validator  ← the extra wrap
//   }
//
// Use it to hide your internal accumulator type from the public API.

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
