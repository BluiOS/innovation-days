# Regular Expressions Knowledge Sharing Session

## Table of Contents
1. [What is Regex?](#what-is-regex)
2. [Why Do We Need Regex?](#why-do-we-need-regex)
3. [Regex Syntax and Basic Elements](#regex-syntax-and-basic-elements)
4. [Advanced Topics](#advanced-topics)
5. [First-Class Support in Swift](#first-class-support-in-swift)
6. [Example Scenarios and Solutions](#example-scenarios-and-solutions)
7. [Handling Persian Text](#handling-persian-text)
8. [Performance Considerations](#performance-considerations)
9. [Regex Performance Analysis (Big-O)](#regex-performance-analysis-big-o)

---

## What is Regex?

**Regular Expressions (Regex)** are a powerful pattern-matching language used to search, match, and manipulate text. They provide a concise and flexible way to describe patterns in strings using a special syntax.

Key characteristics:
- **Pattern matching**: Find specific patterns in text
- **Text processing**: Extract, replace, or validate data
- **Cross-platform**: Supported in most programming languages
- **Standardized**: Based on formal language theory

---

## Why Do We Need Regex?

### Limitations of Simple Find/Replace

| Simple Find/Replace | Regular Expressions |
|-------------------|-------------------|
| Exact string matching only | Pattern-based matching |
| Case-sensitive by default | Flexible case handling |
| No validation capabilities | Built-in validation |
| Limited text extraction | Powerful capture groups |
| Static replacements | Dynamic replacements |

### Real-world Examples

**Simple Find/Replace:**
```
Find: "john@email.com"
Replace: "john@company.com"
```

**Regex Power:**
```regex
Find: \b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b
Replace: All email addresses in the document
```

---

## Regex Syntax and Basic Elements

### Metacharacters
| Character | Description | Example |
|-----------|-------------|---------|
| `.` | Matches any single character | `a.c` matches "abc", "axc" |
| `*` | Zero or more of preceding | `ab*c` matches "ac", "abc", "abbc" |
| `+` | One or more of preceding | `ab+c` matches "abc", "abbc" |
| `?` | Zero or one of preceding | `ab?c` matches "ac", "abc" |
| `^` | Start of string | `^Hello` matches "Hello world" |
| `$` | End of string | `world$` matches "Hello world" |
| `\|` | OR operator | `cat\|dog` matches "cat" or "dog" |

### Character Classes
| Class | Description | Example |
|-------|-------------|---------|
| `[abc]` | Any of a, b, or c | `[aeiou]` matches vowels |
| `[^abc]` | Not a, b, or c | `[^0-9]` matches non-digits |
| `[a-z]` | Range from a to z | `[A-Z]` matches uppercase |
| `\d` | Digit (0-9) | `\d+` matches numbers |
| `\w` | Word character | `\w+` matches words |
| `\s` | Whitespace | `\s+` matches spaces |

### Quantifiers
| Quantifier | Description | Example |
|------------|-------------|---------|
| `{n}` | Exactly n times | `a{3}` matches "aaa" |
| `{n,}` | n or more times | `a{2,}` matches "aa", "aaa"... |
| `{n,m}` | Between n and m times | `a{2,4}` matches "aa" to "aaaa" |

---

## Advanced Topics

### Capture Groups
```regex
(\d{4})-(\d{2})-(\d{2})
```
- Matches dates like "2023-12-31"
- Group 1: Year (2023)
- Group 2: Month (12)
- Group 3: Day (31)

### Named Groups
```regex
(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})
```

### Lookahead and Lookbehind
```regex
# Positive lookahead: Match "foo" if followed by "bar"
foo(?=bar)

# Negative lookahead: Match "foo" if NOT followed by "bar"
foo(?!bar)

# Positive lookbehind: Match "bar" if preceded by "foo"
(?<=foo)bar

# Negative lookbehind: Match "bar" if NOT preceded by "foo"
(?<!foo)bar
```

### Non-Greedy Matching
```regex
# Greedy (default): Matches as much as possible
<.*>     # In "<p>Hello</p>", matches entire string

# Non-greedy: Matches as little as possible
<.*?>    # In "<p>Hello</p>", matches "<p>" and "</p>" separately
```

### Word Boundaries
```regex
\b      # Word boundary
\bcat\b # Matches "cat" but not "catch" or "scat"
```

---

## First-Class Support in Swift

Swift provides excellent support for regular expressions through multiple approaches:

### NSRegularExpression (Foundation)
- Available since iOS 4
- Foundation framework's mature regex implementation
- Full compatibility with existing codebases
- Comprehensive pattern matching capabilities

### Modern Swift Regex (iOS 16+)
- Native Swift regex literals with `/pattern/` syntax
- Type-safe capture groups
- Better performance and ergonomics
- Seamless integration with Swift's type system

### RegexBuilder DSL (iOS 16+)
- Domain-specific language for building patterns
- Compile-time pattern validation
- Enhanced readability and maintainability
- IDE support with autocompletion

**For detailed Swift implementation examples, refer to the companion Swift Playground files.**

---

## Example Scenarios and Solutions

Regular expressions excel in many common programming scenarios:

### 1. Email Validation
- Pattern: `^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$`
- Validates standard email format
- Handles most common email variations

### 2. Phone Number Extraction
- Pattern: `(\+?\d{1,3})?[-.s]?(\(?\d{3}\)?[-.s]?\d{3}[-.s]?\d{4})`
- Supports international and domestic formats
- Flexible separator handling

### 3. URL Matching
- Pattern: `https?://(?:[-\w.])+(?:\:[0-9]+)?(?:/(?:[\w/_.])*(?:\?(?:[\w&=%.])*)?(?:\#(?:[\w.])*)?)??`
- Matches HTTP and HTTPS URLs
- Includes ports, paths, query strings, and fragments

### 4. Credit Card Validation
- Different patterns for each card type (Visa, MasterCard, etc.)
- Validates card number format and length
- Can identify card brand from number pattern

### 5. Password Strength Validation
- Multiple pattern checks for security requirements
- Validates length, character types, and complexity
- Provides specific feedback on missing requirements

### 6. Log File Parsing
- Extract structured data from log entries
- Parse timestamps, log levels, and messages
- Essential for system monitoring and debugging

**For complete implementation examples with Swift code, see the companion Playground files.**

---

## Handling Persian Text

### Unicode Support
Persian text requires Unicode-aware regex patterns:

```regex
# Persian letters range
[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]+

# Persian digits (۰-۹)
[\u06F0-\u06F9]+

# Mixed Persian and English
[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFFa-zA-Z0-9\s]+
```

### Common Persian Text Patterns
- **Persian phone numbers**: `09[0-9]{2}-?[0-9]{3}-?[0-9]{4}`
- **Persian postal codes**: `[0-9]{5}-?[0-9]{5}`
- **Persian names**: Unicode ranges for Arabic/Persian scripts
- **Persian digits**: `[\u06F0-\u06F9]` for ۰-۹

### Normalization Considerations
**Character Normalization:**
- Convert Arabic-Indic digits (٠-٩) to Persian digits (۰-۹)
- Normalize Arabic Yeh (ي) to Persian Yeh (ی)
- Normalize Arabic Kaf (ك) to Persian Kaf (ک)
- Handle diacritics and zero-width characters

**Text Direction:**
- Consider logical vs visual character order
- Use proper Unicode handling methods
- Account for mixed RTL/LTR text scenarios

---

## Performance Considerations

### 1. Compilation Cost
**Problem**: Recompiling regex patterns repeatedly
**Solution**: Compile once, reuse many times
- Cache compiled regex objects
- Avoid pattern compilation in loops
- Significant performance improvement for repeated use

### 2. Catastrophic Backtracking
**Problem**: Exponential time complexity with nested quantifiers
**Examples**: `(a+)+b`, `(x+x+)+y`
**Solutions**:
- Use atomic groups: `(?>a+)+b`
- Use possessive quantifiers: `a++b`
- Simplify patterns when possible

### 3. Optimization Tips

#### Use Anchors
- Anchor patterns to string boundaries when possible
- `^pattern$` is faster than unanchored `pattern`
- Reduces search space significantly

#### Avoid Unnecessary Capturing
- Use non-capturing groups `(?:...)` when you don't need the captured text
- Capturing groups have memory and processing overhead
- Only capture what you actually need

#### Use Character Classes Efficiently
- `[a-e]` is faster than `(a|b|c|d|e)`
- Character classes are optimized for single character matching
- Combine ranges when possible: `[a-zA-Z0-9]`

### 4. Performance Benchmarking
**Best Practices**:
- Measure actual performance with realistic data
- Test with various input sizes
- Compare different pattern approaches
- Consider memory usage along with speed

### 5. When NOT to Use Regex

**Use simpler alternatives for**:
- **Simple string operations**: `contains()`, `hasPrefix()`, `hasSuffix()`
- **Parsing structured data**: JSON/XML parsers
- **Complex grammar**: Dedicated parsing libraries
- **Performance-critical paths**: Finite state machines

**Example**: Checking for "@" in email is better done with `contains("@")` than regex.

---

## Regex Performance Analysis (Big-O)

Regular expression performance is measured using Big-O notation to describe how execution time scales with input size. Understanding this is crucial for writing efficient regex patterns.

### Basic Time Complexity Categories

#### O(n) - Linear Time (Optimal)
**Best case scenario** where the regex engine scans the input once.

```regex
# Simple literal matching
hello

# Character classes
[a-z]+

# Non-backtracking quantifiers
\d+
```

**Characteristics:**
- Each character is examined at most once
- No backtracking required
- Performance scales linearly with input length

#### O(n²) - Quadratic Time (Problematic)
**Occurs with moderate backtracking** in certain patterns.

```regex
# Overlapping alternatives
(a|a)*b

# Nested quantifiers (mild cases)
(ab?)+
```

#### O(2ⁿ) - Exponential Time (Catastrophic)
**Worst case scenario** causing catastrophic backtracking.

```regex
# Nested quantifiers
(a+)+b
(x+x+)+y

# Overlapping alternatives with quantifiers
(a|a)*b
(a*)*b
```

### How Backtracking Affects Complexity

#### The Backtracking Process

When a regex engine encounters multiple possible paths:

1. **Try first alternative**
2. **If it fails, backtrack** and try next alternative
3. **Repeat until match found** or all possibilities exhausted

#### Example: Catastrophic Backtracking

```regex
Pattern: (a+)+b
Input: "aaaaaaaaac"
```

**What happens:**
- `(a+)+` can match "aaaaaaaaaa" in multiple ways:
  - One group with all 10 a's
  - Two groups: 9 a's + 1 a
  - Two groups: 8 a's + 2 a's
  - ... and so on

**Number of combinations:** 2ⁿ⁻¹ where n = number of 'a's

For 10 a's: 2⁹ = 512 combinations to try!

### Regex Engine Types and Performance

#### 1. NFA (Non-deterministic Finite Automaton)
**Used by:** Most regex engines (PCRE, .NET, Java, JavaScript)

```
Time Complexity: O(2ⁿ) worst case
Space Complexity: O(n)
```

**Features:**
- Supports backreferences and lookarounds
- Prone to catastrophic backtracking
- Left-to-right, eager matching

#### 2. DFA (Deterministic Finite Automaton)
**Used by:** Some specialized engines (RE2, Rust regex)

```
Time Complexity: O(n) guaranteed
Space Complexity: O(2ⁿ) for pattern compilation
```

**Features:**
- No backtracking
- Limited feature set (no backreferences)
- Predictable performance

#### 3. Hybrid Approaches
**Used by:** Modern engines with optimizations

```
Time Complexity: O(n) for most cases, fallback for complex features
```

### Performance Analysis Examples

#### Example 1: Email Validation

```regex
# Inefficient (potential O(2ⁿ))
^([a-zA-Z0-9])+@([a-zA-Z0-9])+\.([a-zA-Z])+$

# Efficient (O(n))
^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+$
```

**Analysis:**
- First pattern: Unnecessary capturing groups create backtracking
- Second pattern: Character classes match efficiently without backtracking

#### Example 2: HTML Tag Matching

```regex
# Catastrophic (O(2ⁿ))
<.*>

# Better (O(n))
<[^>]*>
```

**Analysis:**
- `.*` is greedy and backtracks when looking for `>`
- `[^>]*` matches everything except `>`, no backtracking needed

#### Example 3: Number Extraction

```regex
# Potentially slow (O(n²))
(\d+\.\d+|\d+)

# Optimized (O(n))
\d+(?:\.\d+)?
```

**Analysis:**
- First: Alternation can cause backtracking
- Second: Optional non-capturing group is more efficient

### Measuring Regex Performance

#### Factors Affecting Performance

1. **Input Length (n)**
   - Linear scaling: Good
   - Exponential scaling: Bad

2. **Pattern Complexity**
   - Number of quantifiers
   - Nesting depth
   - Alternation branches

3. **Match vs. No-Match**
   - Failed matches often take longer
   - Must exhaust all possibilities

#### Benchmark Example

```
Pattern: (a+)+b
Input lengths and execution times:

n=10:  0.001ms  (2^9 = 512 combinations)
n=15:  0.032ms  (2^14 = 16,384 combinations)
n=20:  1.024ms  (2^19 = 524,288 combinations)
n=25:  32.768ms (2^24 = 16,777,216 combinations)
n=30:  1.049s   (2^29 = 536,870,912 combinations)
```

**Growth rate:** Each additional character doubles execution time!

### Optimization Strategies

#### 1. Eliminate Catastrophic Backtracking

```regex
# Bad: (a+)+
# Good: a+

# Bad: (.*)*
# Good: .*

# Bad: (a|a)*
# Good: a*
```

#### 2. Use Atomic Groups

```regex
# Prevents backtracking
(?>a+)+b

# Standard syntax equivalent
a++b  # Possessive quantifier
```

#### 3. Anchor Patterns

```regex
# Unanchored (searches entire string)
\d{3}-\d{3}-\d{4}

# Anchored (stops at first non-match)
^\d{3}-\d{3}-\d{4}$
```

#### 4. Use Character Classes

```regex
# Slower alternation
(a|b|c|d|e)

# Faster character class
[a-e]
```

#### 5. Avoid Unnecessary Captures

```regex
# Creates capture groups (overhead)
(\d{4})-(\d{2})-(\d{2})

# Non-capturing (when you don't need groups)
(?:\d{4})-(?:\d{2})-(?:\d{2})
```

### Real-World Performance Guidelines

#### Expected Performance Levels

| Pattern Type | Complexity | Acceptable For |
|-------------|------------|----------------|
| Simple literals | O(n) | Any input size |
| Character classes | O(n) | Any input size |
| Simple quantifiers | O(n) | Any input size |
| Complex patterns | O(n²) | Small to medium inputs |
| Nested quantifiers | O(2ⁿ) | **Avoid entirely** |

#### Performance Testing Approach

1. **Test with realistic data sizes**
2. **Measure worst-case scenarios** (non-matching inputs)
3. **Set timeout limits** for regex operations
4. **Use profiling tools** to identify bottlenecks
5. **Consider regex engine alternatives** (RE2 for guaranteed O(n))

### Key Takeaways

- **Linear O(n) complexity** is the goal for efficient regex
- **Exponential O(2ⁿ) complexity** occurs with catastrophic backtracking
- **Pattern design choices** significantly impact performance
- **Anchor patterns**, **avoid nesting**, and **use character classes** for optimization
- **Test with realistic data** and **set timeouts** for production use

Understanding these performance characteristics helps you write regex patterns that scale well and avoid the dreaded "regex that brings down the server" scenario.

---

## Summary

Regular expressions are a powerful tool for text processing, but they should be used judiciously:

- **Use for**: Pattern matching, validation, text extraction
- **Avoid for**: Simple string operations, complex parsing
- **Performance**: Compile once, use many times
- **Persian text**: Handle Unicode properly with normalization
- **Swift**: Leverage both Foundation and modern Regex APIs

Remember: "Some people, when confronted with a problem, think 'I know, I'll use regular expressions.' Now they have two problems." - Use regex when appropriate, but don't force it where simpler solutions exist.

---

## Additional Resources

- **Swift Playground Files**: Complete hands-on examples with runnable code
- **Practice Scenarios**: Real-world challenges for skill development
- **Persian Text Processing**: Specialized examples for RTL and Unicode handling
- **Performance Benchmarks**: Comparative analysis of different approaches
