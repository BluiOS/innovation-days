
# Swift Testing Documentation

## Introduction

This document provides a comprehensive overview of Swift's modern testing methodologies. From leveraging the `@Test` attribute to managing asynchronous code effectively, Swift Testing introduces powerful enhancements over traditional Unit Testing. With features like parallel testing, argument-driven tests, and better failure management, developers can create robust and maintainable test cases efficiently.

## Suits
In the past, we had to create a class containing several test methods. Now, we use a `suit` instead. A `suit` is a type containing test cases or other suits. It can be a `struct`, `class`, or `enum`.

Instead of using `set-up` or `tear-down`, we now use `init` and `deinit` for setup and teardown purposes.

<img width="917" alt="Screenshot 2024-12-31 at 8 32 24 PM" src="https://github.com/user-attachments/assets/45bcae53-d33e-46f6-b6aa-b687685c6282" />

---

## @Test Attribute
The `@Test` attribute is used for each test method, indicating it as a test. This eliminates the need to prefix method names with `test`.

Additionally, traits can be added to the `@Test` attribute for custom configurations like test titles, tags, and more.

![Image Placeholder]

---

## Expectations
Instead of using `XCTAssert`, Swift Testing offers three types of expectations:

1. **#expect(Boolean):**
   This allows you to place any expectation in a Boolean format.

2. **#expect(throws: ErrorType):**
   Used for testing errors and ensuring a test fails under specific conditions.

   ![Image Placeholder]

3. **#require:**
   This stops the test execution upon failure of an expectation.

   ![Image Placeholder]
   
   Previously, we had to set `continueAfterFailure` to `false` to stop execution when the first expectation failed. Now, we can simply use `require` for this purpose.

    ![Image Placeholder]
 
For optional binding, you can also use the following pattern:

![Image Placeholder]

---

## Arguments
When performing repetitive tests with different initializations, arguments can be used to avoid redundant methods.

![Image Placeholder]

Instead of creating multiple repetitive methods, pass arguments and iterate over them. Arguments can have names, which makes them easier to identify in the test navigator. For example, you can loop through a collection of strings and test each one individually.

![Image Placeholder]

Arguments can include a maximum of two collections such as arrays, sets, option sets, etc.

![Image Placeholder]

When running tests, the test navigator shows detailed information for each item. For better readability, inject your model into the `CustomTestStringConvertible` protocol to provide a description for each item.

![Image Placeholder]

---

## Traits
Traits allow additional configuration for test cases. Examples include:

1. Adding titles for clarity in the test navigator.
   ![Image Placeholder]

2. Handling known issues without failing the entire pipeline using either:
   - `.disabled` trait.
     ![Image Placeholder]
   - `expected failure` by placing your code inside a `withKnownIssue` block. This runs the test without causing errors, displaying warnings instead.
     ![Image Placeholder]

3. Tags:
   Tags enable grouping methods or suits. For example, if several methods test a common feature, group them into a suit and assign a tag to the suit rather than individual methods. Tags are created using the `@Tag` attribute.

   ![Image Placeholder]

4. Parallel Testing:
   Unlike XCTest, where tests are executed serially, Swift Testing runs tests in parallel and in a randomized order by default. If a specific order is required, traits can enforce serialization. Internal suites automatically inherit these settings.
   ![Image Placeholder]

---

## Asynchronous Code Testing
While asynchronous code behaves as expected when using `wait` followed by `expect`, completion handling may require a customized approach.

![Image Placeholder]

---

## Migrating from XCTest to Swift Testing
Migrating from XCTest to Swift Testing might not be straightforward in some cases. It requires adhering to specific guidelines:

![Image Placeholder]

---

## Terminal Commands
Run tests via the terminal using:

```bash
swift test
```

---

## Differences Between XCTest and Swift Testing
![Image Placeholder]

