import Foundation

// ════════════════════════════════════════════════════════════════════════════
//  STEP 03 — buildBlock   (the classic block-combiner; or buildPartialBlock)
// ════════════════════════════════════════════════════════════════════════════
//
// Every method step has the same three beats: the compile error, the method,
// and what the compiler rewrites it into.

// ── THE COMPILE-ERROR VERSION ─────────────────────────────────────────────────
// A builder must provide a way to combine block components. With none, a block of
// bare statements is rejected — buildBlock is the price of admission.

// ("Uncommentable")
//   @resultBuilder enum Empty {}
//   func makeRules(@Empty _ c: () -> [any StringValidationRule]) -> [any StringValidationRule] { c() }
//   makeRules {
//       RegexValidationRule(regularExpression: .notEmpty, description: "Required")
//       FunctionValidationRule(description: "Too short") { $0.count >= 2 }
//   }
//   error: 'Empty' does not implement any 'buildBlock' or a combination of 'buildPartialBlock' methods


// ── THE METHOD + SAMPLE IMPL ──────────────────────────────────────────────────
// Variadic works here for ONE reason only: every statement is the same type.
// (Hold that thought — it's the whole plot of buildPartialBlock later.)

// ("Executable")
@resultBuilder
enum ValidationRuleBuilder {
    static func buildBlock(_ rules: any StringValidationRule...) -> [any StringValidationRule] {
        rules
    }
}

func makeRules(@ValidationRuleBuilder _ content: () -> [any StringValidationRule]) -> [any StringValidationRule] {
    content()
}

let rules = makeRules {
    RegexValidationRule(regularExpression: .notEmpty, description: "Required")
    FunctionValidationRule(description: "Too short") { $0.count >= 2 }
}

print(rules.map(\.description))   // ["Required", "Too short"]


// ── TRANSLATED TO WHAT? ───────────────────────────────────────────────────────
// The compiler rewrites the closure above into exactly this — each statement
// becomes a hidden temporary, collected in order, handed to buildBlock:
//
//   {
//       let r0 = RegexValidationRule(regularExpression: .notEmpty, description: "Required")
//       let r1 = FunctionValidationRule(description: "Too short") { $0.count >= 2 }
//       return ValidationRuleBuilder.buildBlock(r0, r1)
//   }
//
// Here's the desugared form, written by hand — the `true` proves the builder
// closure and the static-call version are the SAME program.

// ("Executable")
let desugared: [any StringValidationRule] = {
    let r0 = RegexValidationRule(regularExpression: .notEmpty, description: "Required")
    let r1 = FunctionValidationRule(description: "Too short") { $0.count >= 2 }
    return ValidationRuleBuilder.buildBlock(r0, r1)
}()

print(desugared.map(\.description) == rules.map(\.description))   // true — identical

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
