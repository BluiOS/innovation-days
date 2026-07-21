import Foundation

// ════════════════════════════════════════════════════════════════════════════
//  STEP 11 — The full builder, wired together  (the payoff)
// ════════════════════════════════════════════════════════════════════════════
//
// All seven methods on one type. Every line of the call site maps to one of them —
// and it runs, control flow and all.

struct Validator {
    let rules: [any StringValidationRule]
    func firstError(in value: String) -> String? {
        rules.first { !$0.matches(value) }?.description
    }
}

@resultBuilder
enum ValidationRuleBuilder {
    // 1. Intake — what you're allowed to write
    static func buildExpression(_ rule: any StringValidationRule) -> [any StringValidationRule] { [rule] }
    static func buildExpression(_ pattern: NSRegularExpression) -> [any StringValidationRule] {
        [RegexValidationRule(regularExpression: pattern, description: "Invalid format")]
    }
    // 2. Combine the statements in a block
    static func buildBlock(_ parts: [any StringValidationRule]...) -> [any StringValidationRule] {
        parts.flatMap { $0 }
    }
    // 3. if (no else)
    static func buildOptional(_ part: [any StringValidationRule]?) -> [any StringValidationRule] { part ?? [] }
    // 4. if / else, switch
    static func buildEither(first  part: [any StringValidationRule]) -> [any StringValidationRule] { part }
    static func buildEither(second part: [any StringValidationRule]) -> [any StringValidationRule] { part }
    // 5. for loops
    static func buildArray(_ parts: [[any StringValidationRule]]) -> [any StringValidationRule] { parts.flatMap { $0 } }
    // 6. if #available
    static func buildLimitedAvailability(_ part: [any StringValidationRule]) -> [any StringValidationRule] { part }
    // 7. final conversion to the type the caller wants
    static func buildFinalResult(_ rules: [any StringValidationRule]) -> Validator { Validator(rules: rules) }
}

// A tiny helper so the call site reads like English.
func minLength(_ n: Int, _ message: String) -> FunctionValidationRule {
    FunctionValidationRule(description: message) {
        $0.trimmingCharacters(in: .whitespacesAndNewlines).count >= n
    }
}

// Ergonomic entry point: `Validator { … }`
extension Validator {
    init(@ValidationRuleBuilder _ build: () -> Validator) { self = build() }
}


// ── THE REAL BusinessNameRegister RULE SET, REWRITTEN ─────────────────────────
// Read each line and name the method behind it: .notEmpty → buildExpression,
// minLength → a plain rule, if → buildOptional, for → buildArray.
let isBusinessAccount = true
let bannedWords = ["test", "demo"]

// ("Executable")
let businessName = Validator {
    .notEmpty                            // bare NSRegularExpression → RegexValidationRule
    minLength(2, "Name must be at least 2 characters")
    if isBusinessAccount {               // buildOptional
        FunctionValidationRule(description: "Business names need a suffix") {
            $0.hasSuffix("Co.") || $0.hasSuffix("Ltd.")
        }
    }
    for word in bannedWords {            // buildArray
        FunctionValidationRule(description: "Cannot contain \(word)") { !$0.contains(word) }
    }
}

print(businessName.firstError(in: "") as Any)         // Optional("Invalid format")  (empty fails .notEmpty)
print(businessName.firstError(in: "A") as Any)        // Optional("Name must be at least 2 characters")
print(businessName.firstError(in: "Acme") as Any)     // Optional("Business names need a suffix")
print(businessName.firstError(in: "demo Co.") as Any) // Optional("Cannot contain demo")
print(businessName.firstError(in: "Acme Co.") as Any) // nil — all pass

// Same seven methods — only the partial-result type changes. Next, SwiftUI swaps
// our humble array for the view's own TYPE, and that one substitution is the whole
// reason SwiftUI feels alien.

//: [◀︎ Previous](@previous)  |  [Next ▶︎](@next)
