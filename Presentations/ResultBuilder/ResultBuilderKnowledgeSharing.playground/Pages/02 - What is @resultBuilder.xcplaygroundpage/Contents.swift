import Foundation

// ════════════════════════════════════════════════════════════════════════════
//  STEP 02 — What IS @resultBuilder?
// ════════════════════════════════════════════════════════════════════════════
//
// It's a Swift LANGUAGE feature — an attribute you put on a type. That type is
// just a namespace of static methods the compiler calls. Nothing is instantiated.

// ── THE CAST (lives in Sources/ValidationStubs.swift — shown here for context) ─
//
//   public protocol ValidationRule<Input>: CustomStringConvertible {
//       associatedtype Input
//       func matches(_ value: Input) -> Bool      // description == the error message
//   }
//   public protocol StringValidationRule: ValidationRule where Input == String {}
//   public typealias StringValidationRules = [any StringValidationRule]
//
// Concrete rules: RegexValidationRule, FunctionValidationRule, PredicateValidationRule.
// Our builder's ONE partial-result type is the array: [any StringValidationRule].


// ── @resultBuilder marks a TYPE as a set of rewrite rules ─────────────────────
// A namespace of static methods — never instantiated, holds no state.
//
// An EMPTY builder doesn't even compile — the attribute demands a combining method.

// ("Uncommentable")
//   @resultBuilder
//   enum ValidationRuleBuilder { }
//   error: result builder must provide at least one static 'buildBlock' method, or both
//          'buildPartialBlock(first:)' and 'buildPartialBlock(accumulated:next:)'

// So the smallest thing the attribute will accept is a type with one block-combiner:

// ("Executable")
@resultBuilder
enum ValidationRuleBuilder {
    // The block-combining method.
    static func buildBlock(_ rules: any StringValidationRule...) -> [any StringValidationRule] { rules }
}

print("@resultBuilder applied — it now has a block-combiner.")

// Mental model: a result builder is a `reduce` over the statements of a closure,
// and the compiler writes the reduce for you.
//   buildExpression       → the `map` step (intake)
//   buildBlock / Partial  → the `reduce`   (combine)
//   buildOptional/Either/Array → branches & loops
//   buildFinalResult      → the final `map` on the output

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
