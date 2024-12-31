
# Swift Testing Documentation

## Introduction

This document provides a comprehensive overview of Swift's modern testing methodologies. From leveraging the `@Test` attribute to managing asynchronous code effectively, Swift Testing introduces powerful enhancements over traditional Unit Testing. With features like parallel testing, argument-driven tests, and better failure management, developers can create robust and maintainable test cases efficiently.

## Suits
In the past, we had to create a class containing several test methods. Now, we use a `suit` instead. A `suit` is a type containing test cases or other suits. It can be a `struct`, `class`, or `enum`.

Instead of using `set-up` or `tear-down`, we now use `init` and `deinit` for setup and teardown purposes.
&nbsp;

<img width="1107" alt="Suits" src="https://github.com/user-attachments/assets/2ca601f8-9ccb-4ae8-a0bf-4110e7c5381e" />

---

## @Test Attribute
The `@Test` attribute is used for each test method, indicating it as a test. This eliminates the need to prefix method names with `test`.

Additionally, traits can be added to the `@Test` attribute for custom configurations like test titles, tags, and more.
&nbsp;


<img width="932" alt="Screenshot 2024-12-31 at 9 33 30 PM" src="https://github.com/user-attachments/assets/b5463f49-5ea1-4659-a3be-041f13ffa9eb" />

---

## Expectations
Instead of using `XCTAssert`, Swift Testing offers three types of expectations:

1. **#expect(Boolean):**
   This allows you to place any expectation in a Boolean format.
&nbsp;
   <img width="688" alt="Screenshot 2024-12-31 at 9 35 32 PM" src="https://github.com/user-attachments/assets/dfadf6cc-64c2-4761-8599-6ba0c4922809" />
&nbsp;
2. **#expect(throws: ErrorType):**
   Used for testing errors and ensuring a test fails under specific conditions.
   &nbsp; 
<img width="557" alt="Screenshot 2024-12-31 at 9 37 49 PM" src="https://github.com/user-attachments/assets/a09c133f-24d9-4b84-83fd-37c4a2ddddd7" />
&nbsp;
4. **#require:**
   This stops the test execution upon failure of an expectation.
&nbsp;
   <img width="686" alt="Screenshot 2024-12-31 at 9 36 29 PM" src="https://github.com/user-attachments/assets/f4f518cb-ba08-4672-ba77-a0b2c3f7a46c" />
&nbsp;
   Previously, we had to set `continueAfterFailure` to `false` to stop execution when the first expectation failed. Now, we can simply use `require` for this purpose.
&nbsp;
 <img width="897" alt="Screenshot 2024-12-31 at 9 39 15 PM" src="https://github.com/user-attachments/assets/f17a5eeb-6d4a-45a9-ad25-af485b0aa80e" />

For optional binding, you can also use the following pattern:
&nbsp;
<img width="819" alt="Screenshot 2024-12-31 at 9 40 56 PM" src="https://github.com/user-attachments/assets/e70a5c29-5d13-489b-b3da-fb16e5123335" />

---

## Arguments
When performing repetitive tests with different initializations, arguments can be used to avoid redundant methods.

Instead of creating multiple repetitive methods, pass arguments and iterate over them. Arguments can have names, which makes them easier to identify in the test navigator. For example, you can loop through a collection of strings and test each one individually.
&nbsp;
<img width="748" alt="Screenshot 2025-01-01 at 12 14 33 AM" src="https://github.com/user-attachments/assets/ee8b5d8b-09ba-4d84-944f-696c76873790" />
&nbsp;
<img width="761" alt="Screenshot 2025-01-01 at 12 15 10 AM" src="https://github.com/user-attachments/assets/d5e19f08-0149-4da8-8a1e-642aa4fa7234" />
&nbsp;
Arguments can include a maximum of two collections that conform to `Sendable` protocol such as arrays, sets, option sets, etc.
&nbsp;
<img width="726" alt="Screenshot 2025-01-01 at 12 16 08 AM" src="https://github.com/user-attachments/assets/ad3e9359-88d5-430a-9bb0-835cc05c3d2c" />
&nbsp;
When running tests, the test navigator shows detailed information for each item. For better readability, inject your model into the `CustomTestStringConvertible` protocol to provide a description for each item.
&nbsp;
<img width="397" alt="Screenshot 2025-01-01 at 12 18 03 AM" src="https://github.com/user-attachments/assets/db0fa916-f3f6-4fcc-b7a2-e312edb7c1b7" />
&nbsp;
Solution:
&nbsp;
<img width="540" alt="Screenshot 2025-01-01 at 12 18 50 AM" src="https://github.com/user-attachments/assets/6b7e2753-b8ee-4313-b4a4-4ac161ac2f24" />

&nbsp;
---
## Traits
Traits allow additional configuration for test cases. Examples include:

<img width="541" alt="Screenshot 2025-01-01 at 12 19 53 AM" src="https://github.com/user-attachments/assets/70bcdc31-63d3-4de0-ba82-85f22bed9f2c" />
&nbsp;
<img width="547" alt="Screenshot 2025-01-01 at 12 27 58 AM" src="https://github.com/user-attachments/assets/01096d48-98e4-4f27-8cd7-19c8e76bfa14" />
&nbsp;
1. Adding titles for clarity in the test navigator.
&nbsp;
<img width="567" alt="Screenshot 2025-01-01 at 12 20 13 AM" src="https://github.com/user-attachments/assets/c2357230-dac3-403c-aee4-37fabeb604a4" />
&nbsp;
2. Handling known issues without failing the entire pipeline using either:
   - `.disabled` trait.

   - `expected failure` by placing your code inside a `withKnownIssue` block. This runs the test without causing errors, displaying warnings instead.
&nbsp;
<img width="550" alt="Screenshot 2025-01-01 at 12 21 17 AM" src="https://github.com/user-attachments/assets/d97c7534-9429-4cd2-8c2e-0a29a3fbf5e9" />
&nbsp;
3. Tags:
   Tags enable grouping methods or suits. For example, if several methods test a common feature, group them into a suit and assign a tag to the suit rather than individual methods. Tags are created using the `@Tag` attribute.
&nbsp;
<img width="872" alt="Screenshot 2025-01-01 at 12 29 59 AM" src="https://github.com/user-attachments/assets/8fe5043e-0099-4d4c-a281-056b8a4635c6" />
&nbsp;
<img width="551" alt="Screenshot 2025-01-01 at 12 21 50 AM" src="https://github.com/user-attachments/assets/240c41a7-1428-4700-988a-524447f0366e" />
&nbsp;
5. Parallel Testing:
   Unlike XCTest, where tests are executed serially, Swift Testing runs tests in parallel and in a randomized order by default.
&nbsp;  
<img width="463" alt="Screenshot 2025-01-01 at 12 22 31 AM" src="https://github.com/user-attachments/assets/1b587a09-e43d-4998-90b4-f629907e13c5" />
&nbsp;
If a specific order is required, traits can enforce serialization. Internal suites automatically inherit these settings.
&nbsp;
<img width="669" alt="Screenshot 2025-01-01 at 12 23 15 AM" src="https://github.com/user-attachments/assets/b9ef2480-3c81-4893-8293-eccfb494e9ad" />

---

## Asynchronous Code Testing
While asynchronous code behaves as expected when using `wait` followed by `expect`, completion handling may require a customized approach.
&nbsp;
<img width="671" alt="Screenshot 2025-01-01 at 12 24 20 AM" src="https://github.com/user-attachments/assets/a09ad68c-5265-4817-b8b6-1f77dc1a9491" />
&nbsp;
<img width="559" alt="Screenshot 2025-01-01 at 12 25 23 AM" src="https://github.com/user-attachments/assets/0105be07-258a-455d-b5cf-425bc511c625" />

---

## Migrating from XCTest to Swift Testing
Migrating from XCTest to Swift Testing might not be straightforward in some cases. It requires adhering to specific guidelines:
&nbsp;
<img width="565" alt="Screenshot 2025-01-01 at 12 26 49 AM" src="https://github.com/user-attachments/assets/c213801a-6351-4533-8308-d8a9012da0a9" />

---

## Terminal Commands
Run tests via the terminal using:

```bash
swift test
```
&nbsp;
<img width="390" alt="Screenshot 2025-01-01 at 12 27 11 AM" src="https://github.com/user-attachments/assets/9503e6c1-ceda-4ff8-90e3-f7938d5325f9" />

---

## Differences Between XCTest and Swift Testing

1. Test Functions:
&nbsp;
<img width="557" alt="Screenshot 2025-01-01 at 12 30 56 AM" src="https://github.com/user-attachments/assets/60a2fa11-5cec-47d0-a5c6-b060ce99c6c7" />
&nbsp;
2. Expectations:
&nbsp;
<img width="553" alt="Screenshot 2025-01-01 at 12 31 49 AM" src="https://github.com/user-attachments/assets/4bc8d8e4-5403-4033-a8ab-0a3f84b45ed0" />
&nbsp;
3. Suits:
&nbsp;
<img width="554" alt="Screenshot 2025-01-01 at 12 32 18 AM" src="https://github.com/user-attachments/assets/8f83102c-8670-4d79-a00f-4543abc22758" />

