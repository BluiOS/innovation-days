import Foundation

// ════════════════════════════════════════════════════════════════════════════
//  STEP 05 — buildOptional   (an `if` with no `else`)
// ════════════════════════════════════════════════════════════════════════════
//
// Each language feature inside a builder closure must be paid for by a method.
// This is the first one: no buildOptional → no `if`.

let isBusinessAccount = true

// ── THE COMPILE-ERROR VERSION ─────────────────────────────────────────────────
// Without buildOptional, an `if` with no `else` is not allowed in the block:

// ("Uncommentable")
   makeRules {
       RegexValidationRule(regularExpression: .notEmpty, description: "Required")
       if isBusinessAccount {                          // closure containing control
           FunctionValidationRule(description: "Min 2") { $0.count >= 2 }
           RegexValidationRule(regularExpression: .notEmpty, description: "Required")//   flow statement
       }                                               //   cannot be used with result builder
   }


// ── THE METHOD + SAMPLE IMPL ──────────────────────────────────────────────────
// False condition → the branch produces nothing → nil → we map nil to empty.

// ("Executable")
@resultBuilder
enum ValidationRuleBuilder {
    static func buildExpression(_ rule: any StringValidationRule) -> [any StringValidationRule] { [rule] }
    static func buildBlock(_ parts: [any StringValidationRule]...) -> [any StringValidationRule] { parts.flatMap { $0 } }

    static func buildOptional(_ part: [any StringValidationRule]?) -> [any StringValidationRule] { part ?? [] }
}

func makeRules(@ValidationRuleBuilder _ content: () -> [any StringValidationRule]) -> [any StringValidationRule] {
    content()
}

let rules = makeRules {
    RegexValidationRule(regularExpression: .notEmpty, description: "Required")
    if isBusinessAccount {
        FunctionValidationRule(description: "Min 2 chars") { $0.count >= 2 }
    }
}

print(rules.map(\.description))   // ["Required", "Min 2 chars"]   (drops to ["Required"] when false)


// ── TRANSLATED TO WHAT? ───────────────────────────────────────────────────────
// The inner block is built, then wrapped in buildOptional, which receives the
// result OR nil:
//
//   {
//       let r0 = ValidationRuleBuilder.buildExpression(
//                    RegexValidationRule(regularExpression: .notEmpty, description: "Required"))
//       let r1: [any StringValidationRule]?
//       if isBusinessAccount {
//           r1 = ValidationRuleBuilder.buildBlock(
//                    ValidationRuleBuilder.buildExpression(
//                        FunctionValidationRule(description: "Min 2 chars") { $0.count >= 2 }))
//       } else {
//           r1 = nil
//       }
//       let r1opt = ValidationRuleBuilder.buildOptional(r1)
//       return ValidationRuleBuilder.buildBlock(r0, r1opt)
//   }

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
