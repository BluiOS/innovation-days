# Presentation structure

Sections may span multiple slides when the topic needs room for examples, diagrams, or code. Do not force every numbered section into exactly one slide.

## 1. Title

### Slide content

Title:

```text
Date & Time in Software Engineering
```

Subtitle:

```text
Why your assumptions are probably wrong
```

Small footer/reference:

```text
Swift · Foundation · Calendars · Timezones · Formatting · APIs
```

### What this section should explain

Open with the idea that date/time looks simple because every developer uses it, but it is one of the most rule-heavy parts of software engineering.

The first slide should make the topic feel practical, not academic.

Add an audience-facing overview slide or area:

```text
What we will cover:
- Mental models: instant, local date, clock time, formatted string
- Swift/Foundation primitives
- Calendar arithmetic and common bugs
- Formatting, parsing, ICU, CLDR, and tzdb
- API contracts and storage design
- Testing and edge cases
- Weird calendar facts
```

---

## 2. Why date/time is hard

### Slide content

Use short statements:

```text
A day is not always 24 hours.
A timezone is not just an offset.
A date is not always an instant.
A formatted date is not data.
UTC does not solve everything.
```

Add reference:

```text
Reference: yourcalendricalfallacyis.com
```

### What this section should explain

Explain that many bugs come from hidden assumptions.

The slide should introduce `yourcalendricalfallacyis.com` as a recurring reference throughout the talk. The site describes itself as helping navigate the complexity of calendrically correct date/time operations and lists fallacies like “days are 86,400 seconds long” and “days are 24 hours long.” Reference it directly.

Reference:

* [https://yourcalendricalfallacyis.com/](https://yourcalendricalfallacyis.com/)

---

## 3. Core mental model

### Slide content

Use a simple visual:

```text
Instant
≠
Local Date
≠
Clock Time
≠
Formatted String
```

Then:

```text
Human time = instant + rules + context
```

### What this section should explain

Define the main concepts:

* **Instant**: one exact point on the timeline.
* **Local date**: a calendar date, such as `2026-04-28`.
* **Clock time**: local wall-clock time, such as `09:30`.
* **Timezone**: rules that map instants to local time.
* **Calendar**: rules for years, months, weeks, and days.
* **Locale**: cultural formatting preferences.
* **Formatted string**: presentation, not source data.

Mention that Apple’s `Date` represents a point in time independent of calendar and timezone. The interpretation comes later through `Calendar`, `TimeZone`, and formatters.

Reference:

* [https://developer.apple.com/documentation/foundation/date](https://developer.apple.com/documentation/foundation/date)

---

## 4. Swift/Foundation primitives

### Slide content

Use a compact table:

```text
Date              → instant
Calendar          → calendar rules
DateComponents    → year/month/day/hour pieces
TimeZone          → local time rules
Locale            → user/cultural preferences
DateFormatter     → older formatting API
Date.FormatStyle  → modern Swift formatting API
```

### What this section should explain

Explain each Swift primitive briefly.

Important points:

* `Date` does not store timezone, calendar, or locale.
* `Calendar` converts between `Date` and components.
* `DateComponents` is not necessarily a complete date.
* `TimeZone(identifier:)` is usually better than fixed offsets for real places.
* `Locale` affects display.
* `DateFormatter` is older and mutable.
* `Date.FormatStyle` is modern, declarative, and locale-aware.

References:

* [https://developer.apple.com/documentation/foundation/date](https://developer.apple.com/documentation/foundation/date)
* [https://developer.apple.com/documentation/foundation/calendar](https://developer.apple.com/documentation/foundation/calendar)
* [https://developer.apple.com/documentation/foundation/dateformatter](https://developer.apple.com/documentation/foundation/dateformatter)
* [https://developer.apple.com/documentation/foundation/date/formatstyle](https://developer.apple.com/documentation/foundation/date/formatstyle)

---

## 5. How the primitives relate

### Slide content

Use a pipeline:

```text
Date
 + Calendar
 + TimeZone
 + Locale
 ↓
Human meaning
```

Example:

```text
2026-04-28T12:00:00Z
↓ Europe/Istanbul + Gregorian + en_US
April 28, 2026, 15:00
```

### What this section should explain

Explain that a `Date` becomes meaningful to humans only after applying:

* timezone
* calendar
* locale
* formatting rules

Add a small Swift example:

```swift
let instant = Date()

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Istanbul")!

let components = calendar.dateComponents(
    [.year, .month, .day, .hour, .minute],
    from: instant
)
```

The slide should not contain too much code. It can contain a concise snippet and short labels.

---

## 6. Calendar, Calendar Arithmetic and Common Wrong Assumptions

This section includes the first live coding part.

### Live coding section

Mark this section visually as:

```text
🧑‍💻 Live coding
Calendar and date arithmetic in Swift
```

### Important instruction for live-coding slides

Slides in this section must contain copyable Swift code blocks.

The code should be complete enough to paste into:

* a Swift Playground
* an Xcode project
* or a small command-line Swift file

### Slide content

Core question:

```text
What does “tomorrow” mean?
```

Show two different meanings:

```text
Exactly 24 hours later?
Same local calendar time tomorrow?
```

### What this section should explain

This section combines:

* `Calendar`
* date arithmetic
* duration vs calendar period
* common mistakes like `86400`
* extracting calendar components
* calendar information APIs
* scanning dates
* calculating dates from components
* intervals and comparisons
* common wrong assumptions from production date/time bugs

Explain that `addingTimeInterval(86_400)` means exact elapsed duration. It does not necessarily mean “same local time tomorrow.”

### Code slide 1: exact duration

```swift
import Foundation

let now = Date()
let exactly24HoursLater = now.addingTimeInterval(86_400)

print(now)
print(exactly24HoursLater)
```

Explain:

This is valid when you really mean exactly 24 elapsed hours.

### Code slide 2: calendar day

```swift
import Foundation

let now = Date()

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let sameLocalTimeTomorrow = calendar.date(
    byAdding: .day,
    value: 1,
    to: now
)

print(sameLocalTimeTomorrow as Any)
```

Explain:

This is better when the business meaning is “tomorrow in this calendar/timezone.”

### Code slide 3: start of day

```swift
import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Istanbul")!

let startOfToday = calendar.startOfDay(for: Date())

print(startOfToday)
```

Explain:

Do not manually create midnight unless you understand the timezone and calendar rules. Use `Calendar`.

### Code slide 4: constructing from components

```swift
import Foundation

var components = DateComponents()
components.calendar = Calendar(identifier: .gregorian)
components.timeZone = TimeZone(identifier: "Europe/Amsterdam")
components.year = 2026
components.month = 3
components.day = 29
components.hour = 2
components.minute = 30

let date = components.date

print(date as Any)
```

Explain:

This is useful for demonstrating invalid/ambiguous local times around DST transitions.

References:

* [https://developer.apple.com/documentation/foundation/calendar](https://developer.apple.com/documentation/foundation/calendar)
* [https://yourcalendricalfallacyis.com/](https://yourcalendricalfallacyis.com/)

### Calendar API examples to include

Include grouped live-coding slides and playground pages for:

```text
Extracting components:
- date(_:matchesComponents:)
- component(_:from:)
- dateComponents(_:from:)
- dateComponents(_:from:to:) for Date values
- dateComponents(_:from:to:) for DateComponents values
- dateComponents(in:from:)

Getting calendar information:
- ordinality(of:in:for:)
- range(of:in:for:)

Scanning dates:
- startOfDay(for:)
- enumerateDates(...)
- nextDate(...)
- dates(byAdding: DateComponents, ...)
- dates(byAdding: Calendar.Component, ...)
- dates(byMatching: ...)

Calculating dates from components:
- date(from:)
- date(byAdding: DateComponents, ...)
- date(byAdding: Calendar.Component, ...)
- date(bySetting:value:of:)
- date(bySettingHour:minute:second:of:...)

Intervals:
- dateInterval(of:for:)
- dateInterval(of:start:interval:for:)

Comparisons:
- compare(_:to:toGranularity:)
- isDate(_:equalTo:toGranularity:)
- isDate(_:inSameDayAs:)
- isDateInToday(_:)
- isDateInTomorrow(_:)
- isDateInYesterday(_:)
- isDateInWeekend(_:)
```

When a method can be misunderstood, show the wrong assumption first, then the correct calendar API.

### Common bugs and wrong assumptions

This content is part of the same merged live-coding section.

### Live coding section

Mark this section visually as:

```text
🧑‍💻 Live coding
Reproducing date/time bugs
```

### Important instruction

Each live-coding slide should include code to copy.

The goal is not to add more demos beyond the planned ones. The goal is to reproduce misconceptions.

### Bug 1: “Date means year/month/day”

Slide content:

```text
Date is an instant.
A birthday is not an instant.
```

Code:

```swift
import Foundation

struct Birthday {
    let month: Int
    let day: Int
}

let birthday = Birthday(month: 1, day: 11)
```

Explain:

A birthday should not automatically become midnight UTC.

---

### Bug 2: “Timezone is just an offset”

Slide content:

```text
UTC+03:00 is an offset.
Europe/Istanbul is a timezone.
```

Code:

```swift
import Foundation

let fixedOffset = TimeZone(secondsFromGMT: 3 * 60 * 60)
let realTimeZone = TimeZone(identifier: "Europe/Istanbul")

print(fixedOffset as Any)
print(realTimeZone as Any)
```

Explain:

An offset is only a number. A timezone is a rule set with historical/political changes.

References:

* [https://www.iana.org/time-zones](https://www.iana.org/time-zones)
* [https://data.iana.org/time-zones/tzdb/theory.html](https://data.iana.org/time-zones/tzdb/theory.html)

---

### Bug 3: `YYYY` vs `yyyy`

Slide content:

```text
YYYY = week-based year
yyyy = calendar year
```

Code:

```swift
import Foundation

let formatter = DateFormatter()
formatter.locale = Locale(identifier: "en_US_POSIX")
formatter.timeZone = TimeZone(secondsFromGMT: 0)

formatter.dateFormat = "YYYY-MM-dd"
print("Week year:", formatter.string(from: Date()))

formatter.dateFormat = "yyyy-MM-dd"
print("Calendar year:", formatter.string(from: Date()))
```

Explain:

This is a common source of wrong dates around New Year.

Reference:

* [https://developer.apple.com/documentation/foundation/dateformatter](https://developer.apple.com/documentation/foundation/dateformatter)
* [https://unicode-org.github.io/icu/userguide/format_parse/datetime/](https://unicode-org.github.io/icu/userguide/format_parse/datetime/)

---

### Bug 4: “Device timezone is always the business timezone”

Slide content:

```text
User timezone ≠ business timezone
```

Code:

```swift
import Foundation

let paymentExecutionInstant = Date()

var userCalendar = Calendar.current

var businessCalendar = Calendar(identifier: .gregorian)
businessCalendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

print(userCalendar.component(.day, from: paymentExecutionInstant))
print(businessCalendar.component(.day, from: paymentExecutionInstant))
```

Explain:

For banking, finance, scheduling, and statements, the business timezone may be more important than the device timezone.

---

## 7. Calendrical fallacies

### Slide content

Title:

```text
Your Calendrical Fallacy Is...
```

Show categories:

```text
Days
Months
Years
Timezones
Formatting
Distributed systems
```

Add link:

```text
https://yourcalendricalfallacyis.com/
```

### What this section should explain

Do not list the whole website. Instead, group common fallacies.

Explain categories:

1. **Days**

   * A day is not always 24 hours.
   * Tomorrow is not always `now + 86400`.

2. **Months and years**

   * Months have different lengths.
   * Leap years exist.
   * Week-year can differ from calendar year.

3. **Timezones**

   * Timezone is not offset.
   * Offsets can change.
   * Abbreviations are ambiguous.

4. **Formatting**

   * Date strings are not universal.
   * Locale changes output.
   * User settings matter.

5. **Distributed systems**

   * Server/client clocks may disagree.
   * Timestamp ordering is not always event ordering.

Reference:

* [https://yourcalendricalfallacyis.com/](https://yourcalendricalfallacyis.com/)

---

## 8. Under the hood: timezone data

### Slide content

Title:

```text
Where do timezone rules come from?
```

Main bullets:

```text
IANA tzdb / tzdata
Historical offsets
DST rules
Political changes
Timezone identifiers
```

Add examples:

```text
Europe/Amsterdam
Europe/Istanbul
Asia/Tehran
America/New_York
```

### What this section should explain

Explain that systems do not magically know timezone rules. They use timezone databases.

IANA tzdb contains historical and future civil-time rules. It is updated when governments change timezone rules, UTC offsets, or DST rules.

Explain:

* `Europe/Amsterdam` is not just `UTC+1`.
* `Asia/Tehran` is not just one stable offset across all history.
* `Europe/Istanbul` had historical changes.
* A backend and an old mobile device may have different tzdata versions.

Show a slide with a simplified conceptual model:

```text
Timezone ID
↓
Rule database
↓
Offset at a specific instant
↓
Local civil time
```

Add a technical example slide:

```text
Why a zone ID is not enough by itself:

Input:
- instant: 2026-04-28T12:00:00Z
- zone: Europe/Amsterdam

Lookup:
- tzdb version installed on the platform
- matching rule for that instant
- resulting offset and DST state

Output:
- local date/time
- offset for that instant
- abbreviation, if needed for display only
```

Add a Swift example:

```swift
import Foundation

let instant = ISO8601DateFormatter().date(from: "2026-04-28T12:00:00Z")!

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let components = calendar.dateComponents(
    [.year, .month, .day, .hour, .minute, .timeZone],
    from: instant
)

print(components)
```

Explain:

* timezone conversion is a rule lookup, not string formatting
* offsets must be computed for a specific instant
* future local events should store a timezone ID, not only an offset
* old clients may have old timezone data

References:

* [https://www.iana.org/time-zones](https://www.iana.org/time-zones)
* [https://data.iana.org/time-zones/tzdb/theory.html](https://data.iana.org/time-zones/tzdb/theory.html)
* [https://github.com/eggert/tz](https://github.com/eggert/tz)

---

## 9. Under the hood: calendars

### Slide content

Title:

```text
Calendar is also a rule system
```

Bullets:

```text
Year
Month
Day
Week
Era
Leap rules
First weekday
Minimum days in first week
```

Code:

```swift
import Foundation

let date = Date()

let gregorian = Calendar(identifier: .gregorian)
let islamic = Calendar(identifier: .islamic)

print(gregorian.component(.year, from: date))
print(islamic.component(.year, from: date))
```

### What this section should explain

Explain that the same instant can have different year/month/day values depending on calendar rules.

Mention:

* `Calendar.current` is useful for UI.
* Explicit calendar is better for business logic.
* Tests should usually fix calendar and timezone.
* calendar arithmetic is field-based, not duration-based.
* same instant can map to different year/month/day values in different calendar systems.
* "end of month" and "same day next month" need product rules for overflow.

Add examples:

```text
Gregorian:
2024-02-29 exists because 2024 is a leap year.

Persian:
New year starts around the March equinox.

Islamic:
Lunar months drift through the solar year.
```

Add a calendar arithmetic example:

```swift
import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "UTC")!

let jan31 = DateComponents(
    calendar: calendar,
    year: 2026,
    month: 1,
    day: 31
).date!

print(calendar.date(byAdding: .month, value: 1, to: jan31) as Any)
```

Reference:

* [https://developer.apple.com/documentation/foundation/calendar](https://developer.apple.com/documentation/foundation/calendar)

---

## 10. Formatting and parsing

This section includes live coding.

### Live coding section

Mark this section visually as:

```text
🧑‍💻 Live coding
Formatting and parsing in Swift
```

### Slide content

Title:

```text
Formatting is localization
```

Main points:

```text
Locale matters
Calendar matters
Timezone matters
User settings matter
OS/runtime version can matter
```

### What this section should explain

Explain that formatting is not just “convert date to string.”

Date formatting output depends on locale and user preferences. Apple documents that date/time styles are not exact because output depends on locale, preferences, and OS version.

Add a separate standards part:

```text
Date/time standards are contracts.

ISO 8601:
- broad international date/time representation standard
- common basis for machine-readable timestamps and local dates

RFC 3339:
- internet profile of ISO 8601
- common for JSON APIs and timestamps
- examples usually use UTC `Z` or explicit numeric offsets

HTTP-date / RFC 9110:
- used in HTTP headers such as Date, Expires, Last-Modified
- fixed English/GMT wire format

Unix time:
- numeric elapsed seconds from an epoch
- compact, but loses calendar meaning unless context is supplied
```

Explain:

* standards exist because humans, APIs, protocols, logs, and storage systems need different tradeoffs
* Swift commonly uses `ISO8601DateFormatter` or `Date.ISO8601FormatStyle` for ISO-like API timestamps
* JavaScript commonly uses ISO strings for `Date.prototype.toISOString()`
* HTTP clients and servers use HTTP-date for protocol headers, not for app model data
* UI strings should usually use localized format styles, not wire formats

References:

* [https://developer.apple.com/documentation/foundation/dateformatter](https://developer.apple.com/documentation/foundation/dateformatter)
* [https://developer.apple.com/documentation/foundation/dateformatter/style](https://developer.apple.com/documentation/foundation/dateformatter/style)
* [https://developer.apple.com/documentation/foundation/date/formatstyle](https://developer.apple.com/documentation/foundation/date/formatstyle)
* [https://fuckingformatstyle.com/](https://fuckingformatstyle.com/)
* [https://fuckingformatstyle.com/date-styles/](https://fuckingformatstyle.com/date-styles/)
* [https://www.rfc-editor.org/rfc/rfc3339](https://www.rfc-editor.org/rfc/rfc3339)
* [https://www.rfc-editor.org/rfc/rfc9110](https://www.rfc-editor.org/rfc/rfc9110)

### Code slide 1: modern `Date.FormatStyle`

```swift
import Foundation

let date = Date()

let text = date.formatted(
    .dateTime
        .year()
        .month(.wide)
        .day()
        .hour()
        .minute()
)

print(text)
```

### Code slide 2: locale-aware formatting

```swift
import Foundation

let date = Date()

let us = date.formatted(
    .dateTime
        .year()
        .month(.wide)
        .day()
        .locale(Locale(identifier: "en_US"))
)

let nl = date.formatted(
    .dateTime
        .year()
        .month(.wide)
        .day()
        .locale(Locale(identifier: "nl_NL"))
)

print(us)
print(nl)
```

### Code slide 3: API parsing with ISO 8601

```swift
import Foundation

let string = "2026-04-28T12:30:00Z"

let formatter = ISO8601DateFormatter()
let date = formatter.date(from: string)

print(date as Any)
```

### Code slide 4: stable parsing with `DateFormatter`

```swift
import Foundation

let formatter = DateFormatter()
formatter.locale = Locale(identifier: "en_US_POSIX")
formatter.timeZone = TimeZone(secondsFromGMT: 0)
formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"

let date = formatter.date(from: "2026-04-28T12:30:00Z")

print(date as Any)
```

### What to show from Fucking Format Style

Use it as a visual reference for:

* `Date.FormatStyle`
* composable date styles
* parseable format styles
* practical examples

Reference:

* [https://fuckingformatstyle.com/](https://fuckingformatstyle.com/)
* [https://fuckingformatstyle.com/date-styles/](https://fuckingformatstyle.com/date-styles/)

---

## 11. System time data: ICU, CLDR, and IANA tzdb

### Slide content

Title:

```text
What system libraries are built on
```

Visual:

```text
Foundation / Java / JavaScript Intl / backend runtimes
↓
ICU algorithms and APIs
↓
CLDR locale data
↓
IANA tzdb timezone rules
```

Main bullets:

```text
ICU: internationalization engine and APIs
CLDR: locale data, names, calendars, patterns
IANA tzdb: timezone IDs, offsets, DST, history
System libraries: ship versions of these data sets
```

### What this section should explain

Explain that many platforms rely on Unicode internationalization standards and data, plus IANA timezone rules.

ICU provides internationalization behavior and APIs, including date/time formatting, parsing, calendars, collation, number formatting, and locale handling.

CLDR provides locale data such as month names, date patterns, numbering systems, calendar names, plural rules, and cultural preferences.

IANA tzdb provides timezone identifiers and rule data such as historical offsets, DST transitions, and politically changed civil-time rules.

System libraries build on top of these layers:

```text
Your code
↓
Foundation Calendar / DateFormatter / FormatStyle
↓
OS internationalization library
↓
ICU + CLDR + tzdb data versions
```

Add repository examples:

```text
tzdb source files define zone rules in text files such as `europe`, `asia`, and `northamerica`.
CLDR stores locale data in XML, such as date formats and month names.
ICU contains library code and data build tooling that consumes CLDR/tzdb-like data.
```

Important point:

Even if platforms share standards, output can differ because:

* ICU version differs
* CLDR version differs
* OS version differs
* locale settings differ
* timezone data differs

References:

* [https://unicode-org.github.io/icu/userguide/format_parse/datetime/](https://unicode-org.github.io/icu/userguide/format_parse/datetime/)
* [https://cldr.unicode.org/translation/date-time/date-time-patterns](https://cldr.unicode.org/translation/date-time/date-time-patterns)
* [https://github.com/unicode-org/icu](https://github.com/unicode-org/icu)
* [https://github.com/unicode-org/cldr](https://github.com/unicode-org/cldr)
* [https://github.com/eggert/tz](https://github.com/eggert/tz)
* [https://www.iana.org/time-zones](https://www.iana.org/time-zones)

---

## 12. `davedelong/time`

### Slide content

Title:

```text
A safer model: davedelong/time
```

Bullets:

```text
Swift package
Type-safe date/time calculations
Clearer domain concepts
Reduces improper API usage
Useful docs to walk through
```

Links:

```text
GitHub:
https://github.com/davedelong/time

Docs:
https://swiftpackageindex.com/davedelong/time/documentation/time
```

### What this section should explain

This section should not try to fully teach the library.

The presenter will walk through the docs manually.

The slides should provide:

* basic info
* why the package exists
* what problem it tries to solve
* links to GitHub and documentation
* a simple comparison between Foundation and a more domain-specific approach

The GitHub README describes `Time` as a Swift package for robust and type-safe date/time calculations and says calendar work can be complicated and error-prone. It tries to clarify concepts and restrict improper usage through type-safe APIs.

References:

* [https://github.com/davedelong/time](https://github.com/davedelong/time)
* [https://swiftpackageindex.com/davedelong/time/documentation/time](https://swiftpackageindex.com/davedelong/time/documentation/time)

### Optional simple slide

```text
Foundation is powerful.
Time tries to make intent more explicit.
```

Do not include an invented code demo for the package. Reference links and a guided docs walkthrough are sufficient unless APIs are verified directly from the docs.

---

## 13. API contracts and storage design

Move this section before testing.

### Slide content

Title:

```text
What should the backend send?
```

Show three categories:

```text
1. Instant
2. Local date
3. Future local date/time + timezone
```

### What this section should explain

Explain that API design must preserve meaning.

This section also contains the final practical dos and don'ts. There should no longer be a standalone final dos and don'ts section.

## Category 1: exact instant

Use for:

* created at
* updated at
* transaction timestamp
* audit logs
* message sent time

Example:

```json
{
  "createdAt": "2026-04-28T12:30:00Z"
}
```

How to design it:

* use a clearly named field such as `createdAt`, `executedAt`, or `observedAt`
* transmit as RFC 3339 / ISO 8601 timestamp with `Z` or explicit offset
* store in databases as timestamp/instant types where possible
* do not rely on the client clock as authority for business/security truth

## Category 2: local date

Use for:

* birthday
* document expiry date
* statement date
* card expiry date
* due date where time is irrelevant

Example:

```json
{
  "birthDate": "1998-01-11"
}
```

How to design it:

* use `YYYY-MM-DD` strings for pure local dates
* do not silently convert to midnight UTC
* name fields by domain meaning, such as `birthDate`, `statementDate`, or `dueDate`
* document which calendar is assumed if non-Gregorian dates can appear

## Category 3: future local date/time with timezone

Use for:

* scheduled payments
* meetings
* reminders
* recurring events
* market opening/closing times

Example:

```json
{
  "date": "2026-10-25",
  "time": "09:00:00",
  "timeZone": "Europe/Amsterdam"
}
```

How to design it:

* keep local date, local time, and IANA timezone ID as separate contract fields
* preserve recurrence rules separately from generated occurrence instants
* compute the actual instant as late as possible when rules may change
* define behavior for invalid and ambiguous local times around DST transitions
* store the tzdb version if auditability matters

### Contract checklist

```text
For every date/time field, document:
- semantic type: instant, local date, local time, local date-time, duration, period
- timezone rule: user timezone, business timezone, event timezone, or UTC
- calendar: usually Gregorian unless explicitly modeled otherwise
- precision: date, minute, second, millisecond, nanosecond
- authority: server, client, third-party provider, user input
- parsing rule: accepted format and failure behavior
- display rule: localized UI, fixed machine string, or protocol header
```

### Banking examples

Use a compact table:

```text
Transaction timestamp → instant
Statement period      → local date range + business timezone
Scheduled payment     → local date/time + timezone
Card expiry           → month/year
Interest calculation  → business calendar
```

### Important warning

```text
UTC is excellent for instants.
UTC is not enough for every date/time domain.
```

### Dos and don'ts

Use two columns or a compact checklist:

```text
Do
- Store instants as RFC 3339 / ISO 8601 UTC or explicit-offset timestamps
- Use Calendar for calendar math
- Use IANA timezone IDs for real places and future events
- Use explicit calendar/timezone for business logic
- Use locale-aware formatting for UI
- Inject clocks in tests

Don't
- Treat every date-like value as Date
- Add 86400 seconds for “tomorrow”
- Store only offsets for future local events
- Parse display strings as source data
- Use YYYY when you mean yyyy
- Trust device time for business/security truth
```

---

## 14. Testing date/time logic

### Slide content

Title:

```text
Testing date/time requires control
```

Main bullets:

```text
Inject time
Fix timezone
Fix calendar
Fix locale
Test DST and boundary cases
```

### What this section should explain

Explain that date/time checks become unreliable when they depend on:

* current time
* current timezone
* current locale
* device settings
* OS formatting behavior

### Code slide: inject clock

```swift
import Foundation

protocol Clock {
    var now: Date { get }
}

struct SystemClock: Clock {
    var now: Date { Date() }
}

struct FixedClock: Clock {
    let now: Date
}
```

### Code slide: use clock

```swift
import Foundation

struct ExpiryChecker {
    let clock: Clock

    func isExpired(_ expiryDate: Date) -> Bool {
        expiryDate < clock.now
    }
}
```

### Code slide: stable environment

```swift
import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(secondsFromGMT: 0)!

let locale = Locale(identifier: "en_US_POSIX")
let timezone = TimeZone(secondsFromGMT: 0)!
```

### Edge cases to include

```text
DST start
DST end
Leap day
End of month
New year
Week-year boundary
Non-whole-hour timezone
Non-Gregorian calendar
Device timezone change
Server/client clock drift
```

---

## 15. Fun facts and calendar comparison

### Slide content

Title:

```text
Calendars are engineered compromises
```

Use a mix of bullets, compact comparisons, and small diagrams.

### What this section should explain

Include short memorable facts and technical context:

1. Some days are 23 or 25 hours.
2. Some local times happen twice.
3. Some local times never happen.
4. Timezone offsets are not always whole hours.
5. Timezone abbreviations are ambiguous.
6. Timezone rules are political.
7. `UTC everywhere` is good advice, but incomplete.
8. The same instant can be a different date in different timezones.
9. Calendars are cultural systems, not only astronomy.
10. Formatting output can change across OS versions.

Add leap year explanation:

```text
Earth's orbit is not exactly 365 days.
Calendar systems add leap days or leap months to keep civil dates aligned with seasons or lunar cycles.
```

Compare popular calendars using Persian calendar as the base:

```text
Persian / Solar Hijri:
- solar calendar
- year starts around the March equinox
- very accurate for seasonal alignment

Gregorian:
- solar calendar
- leap-year rule: divisible by 4, except centuries not divisible by 400
- common civil/business calendar worldwide

Julian:
- solar calendar
- leap every 4 years
- drifts faster than Gregorian

Islamic Hijri:
- lunar calendar
- 12 lunar months
- drifts through the solar seasons

Hebrew:
- lunisolar calendar
- leap months keep months aligned with seasons over cycles
```

Add weird calendar behaviors:

```text
- month lengths vary
- years can have leap days or leap months
- week-year can differ from calendar year
- new year does not mean the same thing in every calendar
- some calendars are observation-based or rule-based depending on implementation
```

Add leap second explanation:

```text
Leap seconds are occasional one-second adjustments to UTC to keep civil time close to Earth's irregular rotation.
They affect clocks and distributed systems more than calendar arithmetic.
```

Reference:

* [https://yourcalendricalfallacyis.com/](https://yourcalendricalfallacyis.com/)
* [https://www.iana.org/time-zones](https://www.iana.org/time-zones)

---

## 16. Closing

### Slide content

Main quote:

```text
Time is not just a value.
It is an instant interpreted through rules.
```

Secondary:

```text
Model the meaning first.
Choose the type second.
Format only at the boundary.
```

References footer:

```text
yourcalendricalfallacyis.com · IANA tzdb · ICU/CLDR · Apple Foundation · davedelong/time
```

# Corrected final section order

Use this exact order:

```text
1. Title
2. Why date/time is hard
3. Core mental model
4. Swift/Foundation primitives
5. How the primitives relate
6. Calendar, Calendar Arithmetic and Common Wrong Assumptions
7. Calendrical fallacies
8. Under the hood: timezone data
9. Under the hood: calendars
10. Formatting and parsing
11. System time data: ICU, CLDR, and IANA tzdb
12. davedelong/time
13. API contracts, storage design, and dos/don'ts
14. Testing date/time logic
15. Fun facts and calendar comparison
16. Closing
Appendix. References
```
