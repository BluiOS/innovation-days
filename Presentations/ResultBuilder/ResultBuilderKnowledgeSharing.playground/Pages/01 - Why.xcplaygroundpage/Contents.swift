import Foundation

// ════════════════════════════════════════════════════════════════════════════
//  STEP 01 — Why result builders? What do they buy us?
// ════════════════════════════════════════════════════════════════════════════
//
// No runtime magic. A result builder is a compile-time rewrite of the statements
// inside a closure into static method calls. Learn the rewrite → understand it all.

// ── THE BEFORE ───────────────────────────────────────────────────────────────
// How we declare a rule set today: an array literal. Commas, brackets — and no
// room for an `if` or a `for` in the middle.

// ("Executable")
let businessNameRules: [any StringValidationRule] = [
    RegexValidationRule(
        regularExpression: .notEmpty,
        description: "Business name is required"
    ),
    FunctionValidationRule(description: "Min 2 characters") { value in
        value.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2
    }
]

func firstError(in value: String, using rules: [any StringValidationRule]) -> String? {
    rules.first { !$0.matches(value) }?.description
}

print(firstError(in: "",  using: businessNameRules) as Any)   // Optional("Business name is required")
print(firstError(in: "A", using: businessNameRules) as Any)   // Optional("Min 2 characters")
print(firstError(in: "Acme Co.", using: businessNameRules) as Any) // nil — plain rules; this already works


// ── A CLOSURE NORMALLY RETURNS ONE VALUE ─────────────────────────────────────
// Three bare value-producing statements is meaningless Swift — a closure returns
// ONE value. A result builder is what gives those bare statements meaning.

// ("Uncommentable")
// let nonsense = {
//     RegexValidationRule(regularExpression: .notEmpty, description: "Required")
//     FunctionValidationRule(description: "Too short") { $0.count >= 2 }   // unused
//     PredicateValidationRule(predicate: .init(format: "SELF != ''"), description: "Bad")
// }


// ── THE AFTER ─────────────────────────────────────────────────────────────────
// Same rules — no commas, no brackets, and an `if` living right inside the list.
// This is where we're going; the whole session is one question: how does it compile?
//
//   let businessName = Validator {
//       .notEmpty                              // bare regex → a rule
//       minLength(2, "Min 2 characters")
//       if isBusinessAccount {                 // control flow, inside a "list"
//           FunctionValidationRule(description: "Needs a suffix") {
//               $0.hasSuffix("Co.") || $0.hasSuffix("Ltd.")
//           }
//       }
//   }
//
// That `{ … }` is a *result-builder closure*.

//: [Next ▶︎](@next)
