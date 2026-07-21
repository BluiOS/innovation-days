import Foundation

// ─────────────────────────────────────────────────────────────────────────────
//  The cast — stubs of the real `Modules/Core/Validation` types.
//
//  These live in the playground's `Sources/` folder, so they are compiled once
//  as a module and are available to EVERY page. In blu-ios these come from the
//  real `Validation` module; here they are trimmed to exactly what the talk uses
//  so every page compiles and runs standalone.
// ─────────────────────────────────────────────────────────────────────────────

/// A rule is *just* `matches` + a `description` (the error message).
public protocol ValidationRule<Input>: CustomStringConvertible {
    associatedtype Input
    func matches(_ value: Input) -> Bool
}

/// A rule whose input is a `String`.
public protocol StringValidationRule: ValidationRule where Input == String {}

/// The partial-result type our builder collapses everything into.
public typealias StringValidationRules = [any StringValidationRule]

// MARK: - Concrete rules you already ship in blu-ios

public struct RegexValidationRule: StringValidationRule {
    public let regularExpression: NSRegularExpression
    public let description: String

    public init(regularExpression: NSRegularExpression, description: String) {
        self.regularExpression = regularExpression
        self.description = description
    }

    public func matches(_ value: String) -> Bool {
        let range = NSRange(value.startIndex..., in: value)
        return regularExpression.firstMatch(in: value, range: range) != nil
    }
}

public struct FunctionValidationRule: StringValidationRule {
    public let description: String
    private let isMatched: (String) -> Bool

    public init(description: String, isMatched: @escaping (String) -> Bool) {
        self.description = description
        self.isMatched = isMatched
    }

    public func matches(_ value: String) -> Bool { isMatched(value) }
}

public struct PredicateValidationRule: StringValidationRule {
    public let predicate: NSPredicate
    public let description: String

    public init(predicate: NSPredicate, description: String) {
        self.predicate = predicate
        self.description = description
    }

    public func matches(_ value: String) -> Bool { predicate.evaluate(with: value) }
}

// MARK: - Static factories  (.regex / .function / .predicate)

extension StringValidationRule where Self == RegexValidationRule {
    public static func regex(_ expression: NSRegularExpression, description: String) -> RegexValidationRule {
        RegexValidationRule(regularExpression: expression, description: description)
    }
}

extension StringValidationRule where Self == FunctionValidationRule {
    public static func function(description: String, isMatched: @escaping (String) -> Bool) -> FunctionValidationRule {
        FunctionValidationRule(description: description, isMatched: isMatched)
    }
}

extension StringValidationRule where Self == PredicateValidationRule {
    public static func predicate(_ predicate: NSPredicate, description: String) -> PredicateValidationRule {
        PredicateValidationRule(predicate: predicate, description: description)
    }
}

// MARK: - The regex shapes the talk references
//
// In blu-ios these are curated, localized patterns. Here they are deliberately
// simple — just enough that `.notEmpty`, `.localizedMobileNumber`, etc. resolve
// and actually run against a String.

extension NSRegularExpression {
    private static func make(_ pattern: String) -> NSRegularExpression {
        // Patterns here are known-good, so force-try is fine in a playground.
        try! NSRegularExpression(pattern: pattern)
    }

    public static var notEmpty: NSRegularExpression { make(#"^\s*\S.*$"#) }
    public static var localizedMobileNumber: NSRegularExpression { make(#"^09\d{9}$"#) }
    public static var localizedPhoneNumber: NSRegularExpression { make(#"^0\d{10}$"#) }
    public static var localizedPostalCode: NSRegularExpression { make(#"^\d{10}$"#) }

    // Used by the SwiftUI/KYC-flavoured examples.
    public static var passwordHasAlphaCases: NSRegularExpression { make(#"(?=.*[a-z])(?=.*[A-Z])"#) }
    public static var passwordMinimumLength: NSRegularExpression { make(#"^.{8,}$"#) }
    public static var passwordHasNumeric: NSRegularExpression { make(#"(?=.*\d)"#) }
}
