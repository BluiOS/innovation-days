import Foundation

// ════════════════════════════════════════════════════════════════════════════
//  STEP 08 — buildPartialBlock   (modern replacement for variadic buildBlock)
// ════════════════════════════════════════════════════════════════════════════
//
// The pivot. Variadic buildBlock works only when every statement is the SAME type.
// The fold preserves DIFFERENT types — and that's why SwiftUI capped at 10 for years.

// ── THE PROBLEM IT SOLVES ─────────────────────────────────────────────────────
// Variadic buildBlock only works when every argument is the same type. For us it
// always is, so ours is fine. The OTHER case is a type-preserving builder where
// each statement is a different concrete type — you'd need a ladder of overloads:
//
//   buildBlock<A>(A) -> ...
//   buildBlock<A,B>(A,B) -> ...
//   buildBlock<A,B,C>(A,B,C) -> ...        // ...and on forever, one per arity.
//
// Apple wrote ten of these for ViewBuilder and stopped. Hence the 10-view limit.


// ── THE METHOD + SAMPLE IMPL ──────────────────────────────────────────────────
// A pairwise LEFT FOLD, like reduce. Two methods, any number of statements, each
// can be a different type — because the accumulator is free to grow.

// ("Executable")
@resultBuilder
enum ValidationRuleBuilder {
    static func buildExpression(_ rule: any StringValidationRule) -> [any StringValidationRule] { [rule] }

    static func buildPartialBlock(first: [any StringValidationRule]) -> [any StringValidationRule] { first }
    static func buildPartialBlock(accumulated: [any StringValidationRule],
                                  next: [any StringValidationRule]) -> [any StringValidationRule] {
        accumulated + next
    }
}

func makeRules(@ValidationRuleBuilder _ content: () -> [any StringValidationRule]) -> [any StringValidationRule] {
    content()
}

let rules = makeRules {
    RegexValidationRule(regularExpression: .notEmpty, description: "Required")
    FunctionValidationRule(description: "Too short") { $0.count >= 2 }
    FunctionValidationRule(description: "No spaces")  { !$0.contains(" ") }
}

print(rules.map(\.description))   // ["Required", "Too short", "No spaces"]


// ── TRANSLATED TO WHAT? ───────────────────────────────────────────────────────
//   {
//       let e0 = ValidationRuleBuilder.buildExpression(ruleA)
//       let e1 = ValidationRuleBuilder.buildExpression(ruleB)
//       let e2 = ValidationRuleBuilder.buildExpression(ruleC)
//       let acc0 = ValidationRuleBuilder.buildPartialBlock(first: e0)
//       let acc1 = ValidationRuleBuilder.buildPartialBlock(accumulated: acc0, next: e1)
//       let acc2 = ValidationRuleBuilder.buildPartialBlock(accumulated: acc1, next: e2)
//       return acc2
//   }
//
// Define buildBlock OR buildPartialBlock:
//   • variadic buildBlock  → homogeneous builders like ours
//   • buildPartialBlock    → heterogeneous, type-preserving builders like ViewBuilder

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
