# Training: Reading and Writing Regexes

## Writing Regex

---

### 📧 Email validation (basic)

**Goal:** Match a simple email format like `user@example.com`

✅ **Matches**

```
user@example.com
john.doe@domain.co
swift.dev@apple.io
test_email123@my-site.net
```

❌ **Non-matches**

```
user@@example.com
john@.com
@domain.com
user@domain
userdomain.com
```

---

### 📞 Extract phone numbers

**Goal:** Match phone numbers in formats like:
`+1-202-555-0183`, `202-555-0183`, `(202) 555-0183`

✅ **Matches**

```
+1-202-555-0183
202-555-0183
(202) 555-0183
202.555.0183
```

❌ **Non-matches**

```
+12025550183   (no separators)
202/555/0183   (unsupported separators)
5550183        (too short)
```

---

### 📅 Match dates (dd/mm/yyyy)

**Goal:** Match dates like `21/09/2025`, `21-09-2025`, or `21-09-25`

✅ **Matches**

```
21/09/2025
05-12-1999
01/01/25
1/1/2025
```

❌ **Non-matches**

```
2025/09/21
32/01/2020
15.05.2020
1/1/2020
```

---

### 🔐 Password complexity

**Goal:** Must contain at least one uppercase, one lowercase, one digit, one special character, and be at least 8 characters long.

✅ **Matches**

```
Aa1@abcd
MyPassw0rd!
SwiftR0cks#2024
```

❌ **Non-matches**

```
password123
PASSWORD@123
Pass@
SwiftRocks
```

---

### #️⃣ Extract hashtags

**Goal:** Find hashtags in text like `#SwiftLang`, `#iOS`, `#regexRocks`

✅ **Matches**

```
#SwiftLang
#iOS
#regexRocks
#LearnRegexToday
```

❌ **Non-matches**

```
SwiftLang
#123abc (numbers only at start)
#-swift
```

---

### 🌐 Validate IPv4 addresses

**Goal:** Match IPs like `192.168.0.1` but not `999.888.777.666`

✅ **Matches**

```
192.168.0.1
10.0.0.255
172.16.254.3
```

❌ **Non-matches**

```
999.888.777.666
256.100.50.25
192.168.0
192.168.0.01
```

---

### 🏷️ HTML Tag Extraction

**Goal:** Match HTML tags like `<div>`, `</p>`, etc.

✅ **Matches**

```
<div>
</p>
<img src="test.png">
<a href="#">Link</a>
``

❌ **Non-matches**

```
<div
<p/>
text<div>
<a href="#"></a extra>
```

## Reading Regex

### 🟢 Easy
- Matches what kind of string?
    ```
    \d{3}-\d{2}-\d{4}
    ```
    ```
    ✅
    123-45-6789
    ❌
    1234-56-789
    12-345-6789
    ```

- Explain what this matches and why.
    ```
    ^[A-Z][a-z]+$
    ```
    ```
    ✅
    Swift
    Regex
    ❌
    swift
    Regex101
    SwiftLang!
    ```

### Intermediate

- Walk through each component and explain what this URL regex checks for.
    ```
    ^(https?):\/\/(www\.)?[a-zA-Z0-9-]+\.[a-z]{2,6}(/[a-zA-Z0-9#?&=_-]*)?$
    ```
    ```
    ✅
    http://swift.org/docs
    https://www.apple.com
    ❌
    ftp://example.com
    www.apple.com
    ```

- What does this match and how does the lookbehind work?
    ```
    (?<=@)\w+
    ```
    ```
    ✅
    In user@example, matches example
    In test@domain123, matches domain123
    ❌
    In @nothing, no match (since nothing after @)
    ```

- What’s being excluded here?
    ```
    \b(?!cat)\w+\b
    ```
    ```
    ✅
    dog
    regex
    swift
    ❌
    cat
    catnip (partial)

### Advanced

- Used to extract the text inside an HTML <title> tag — discuss lookahead/lookbehind concepts.
    ```
    (?<=<title>)(.*?)(?=<\/title>)
    ```
    ```
    ✅
    <title>Hello World</title> → matches Hello World
    <title>Regex 101</title> → matches Regex 101
    ❌
    <title>Hello<title> (no closing tag)
    ```

- Explain grouping and how it can be used for extraction in code.
    ```
    ^([A-Za-z0-9._%+-]+)@([A-Za-z0-9.-]+)\.([A-Za-z]{2,})$
    ```
    ```
    ✅
    user@example.com
    → groups:
        1️⃣ user
        2️⃣ example
        3️⃣ com
    ❌
    user@domain
    @example.com
    ```
