import Foundation

// ════════════════════════════════════════════════════════════════════════════
//  STEP 04 — buildExpression   (the intake valve)
// ════════════════════════════════════════════════════════════════════════════
//
// Runs on EVERY statement first, before buildBlock. It decides what you're allowed
// to write — and it's the lever for clear compiler errors.

// ── THE COMPILE-ERROR VERSION ─────────────────────────────────────────────────
// With only buildBlock, you can write actual rules and nothing else. A bare
// NSRegularExpression isn't a rule, so this is rejected:

// ("Uncommentable")
   makeRules {
       .notEmpty                                  // NSRegularExpression is not 'any StringValidationRule'
       FunctionValidationRule(description: "Too short") { $0.count >= 2 }
   }


// ── THE METHOD + SAMPLE IMPL ──────────────────────────────────────────────────
// From now on the partial-result type is [any StringValidationRule] everywhere —
// one type in, one type out. That discipline is what makes every later method compose.

// ("Executable")
@resultBuilder
enum ValidationRuleBuilder {
    // Intake: normalize whatever you wrote into the ONE partial-result type.
    static func buildExpression(_ rule: any StringValidationRule) -> [any StringValidationRule] { [rule] }

    // Convenience overload: a bare NSRegularExpression becomes a rule automatically.
    static func buildExpression(_ pattern: NSRegularExpression) -> [any StringValidationRule] {
        [RegexValidationRule(regularExpression: pattern, description: "Invalid format")]
    }

    static func buildBlock(_ parts: [any StringValidationRule]...) -> [any StringValidationRule] {
        parts.flatMap { $0 }
    }
}

func makeRules(@ValidationRuleBuilder _ content: () -> [any StringValidationRule]) -> [any StringValidationRule] {
    content()
}

let rules = makeRules {
    .notEmpty                                                    // NSRegularExpression overload fires
    FunctionValidationRule(description: "Too short") { $0.count >= 2 }  // rule overload
}

print(rules.map(\.description))   // ["Invalid format", "Too short"]   ← "Invalid format" came from the bare regex


// ── TRANSLATED TO WHAT? ───────────────────────────────────────────────────────
// Two-stage pipeline: normalize each value through buildExpression FIRST, then
// combine the results through buildBlock.
//
//   {
//       let r0 = ValidationRuleBuilder.buildExpression(.notEmpty)   // NSRegularExpression → [RegexValidationRule]
//       let r1 = ValidationRuleBuilder.buildExpression(
//                    FunctionValidationRule(description: "Too short") { $0.count >= 2 })
//       return ValidationRuleBuilder.buildBlock(r0, r1)
//   }
//
// This is where you buy good diagnostics: write a UIView in a rules block and the
// error says "expected a validation rule" instead of vomiting generics.

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
