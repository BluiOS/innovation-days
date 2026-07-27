import Foundation

// ════════════════════════════════════════════════════════════════════════════
//  STEP 07 — buildArray   (`for … in` loops)
// ════════════════════════════════════════════════════════════════════════════
//
// No buildArray → no `for`. Burn that in: SwiftUI deliberately OMITS this method,
// which is the whole reason you can't write a `for` loop inside a view body.

let bannedWords = ["test", "demo", "admin"]

// ── THE COMPILE-ERROR VERSION ─────────────────────────────────────────────────
// Without buildArray, a `for` loop is not allowed in the block:

// ("Uncommentable")
   makeRules {
       for word in bannedWords {                       // closure containing control flow
           FunctionValidationRule(description: "Cannot contain \(word)") { !$0.contains(word) }
       }
   }


// ── THE METHOD + SAMPLE IMPL ──────────────────────────────────────────────────
// ("Executable")
@resultBuilder
enum ValidationRuleBuilder {
    static func buildExpression(_ rule: any StringValidationRule) -> [any StringValidationRule] { [rule] }
    static func buildBlock(_ parts: [any StringValidationRule]...) -> [any StringValidationRule] { parts.flatMap { $0 } }

    /// Each iteration's block is collected into `[[…]]`; this flattens them.
    static func buildArray(_ parts: [[any StringValidationRule]]) -> [any StringValidationRule] {
        parts.flatMap { $0 }
    }
}

func makeRules(@ValidationRuleBuilder _ content: () -> [any StringValidationRule]) -> [any StringValidationRule] {
    content()
}

let rules = makeRules {
    for word in bannedWords {
        FunctionValidationRule(description: "Cannot contain \(word)") { !$0.contains(word) }
    }
}

print(rules.map(\.description))   // ["Cannot contain test", "Cannot contain demo", "Cannot contain admin"]


// ── TRANSLATED TO WHAT? ───────────────────────────────────────────────────────
// Each iteration is built into its own block, appended to an array of blocks,
// then buildArray folds the whole thing:
//
//   {
//       var collected: [[any StringValidationRule]] = []
//       for word in bannedWords {
//           let rule = FunctionValidationRule(description: "Cannot contain \(word)") { !$0.contains(word) }
//           collected.append(ValidationRuleBuilder.buildBlock(ValidationRuleBuilder.buildExpression(rule)))
//       }
//       let r0 = ValidationRuleBuilder.buildArray(collected)
//       return ValidationRuleBuilder.buildBlock(r0)
//   }

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
