import type { ReactNode } from 'react'

export type Slide = {
  id: string
  section: string
  title: string
  eyebrow?: string
  liveCoding?: boolean
  references?: Array<{ label: string; href: string }>
  render: () => ReactNode
}

type CalloutProps = {
  tone?: 'accent' | 'warning' | 'neutral'
  children: ReactNode
}

function Callout({ tone = 'neutral', children }: CalloutProps) {
  return <div className={`callout callout-${tone}`}>{children}</div>
}

function BulletGrid({ items }: { items: string[] }) {
  return (
    <div className="bullet-grid">
      {items.map((item) => (
        <div key={item} className="bullet-card">
          {item}
        </div>
      ))}
    </div>
  )
}

function Bullets({ items }: { items: string[] }) {
  return (
    <ul className="bullets">
      {items.map((item) => (
        <li key={item}>{item}</li>
      ))}
    </ul>
  )
}

function CodeBlock({
  title,
  code,
  caption,
  language = 'swift',
}: {
  title: string
  code: string
  caption?: string
  language?: 'swift' | 'json' | 'text'
}) {
  return (
    <article className="code-card">
      <div className="code-card-header">
        <h4>{title}</h4>
        <button
          type="button"
          className="copy-button"
          data-copy={code}
          aria-label={`Copy code from ${title}`}
        >
          Copy
        </button>
      </div>
      <pre className={`language-${language}`}>
        <code>{highlightCode(code, language)}</code>
      </pre>
      {caption ? <p className="code-caption">{caption}</p> : null}
    </article>
  )
}

function highlightCode(code: string, language: 'swift' | 'json' | 'text') {
  const lines = code.split('\n')

  return lines.map((line, lineIndex) => (
    <span key={`${lineIndex}-${line}`} className="code-line">
      {highlightLine(line, language)}
      {lineIndex < lines.length - 1 ? '\n' : null}
    </span>
  ))
}

function highlightLine(line: string, language: 'swift' | 'json' | 'text') {
  if (language === 'text') {
    return line
  }

  const tokens =
    line.match(/\/\/.*|"(?:\\.|[^"\\])*"|`[^`]*`|\b\d[\d_]*(?:\.\d+)?\b|\b[A-Za-z_]\w*\b|./g) ?? []
  const swiftKeywords = new Set([
    'import',
    'let',
    'var',
    'struct',
    'protocol',
    'func',
    'return',
    'from',
    'as',
    'Any',
  ])
  const jsonKeywords = new Set(['true', 'false', 'null'])

  return tokens.map((token, index) => {
    let className = ''

    if (token.startsWith('//')) {
      className = 'token-comment'
    } else if (token.startsWith('"') || token.startsWith('`')) {
      className = 'token-string'
    } else if (/^\d/.test(token)) {
      className = 'token-number'
    } else if (
      (language === 'swift' && swiftKeywords.has(token)) ||
      (language === 'json' && jsonKeywords.has(token))
    ) {
      className = 'token-keyword'
    } else if (language === 'swift' && /^[A-Z]\w+$/.test(token)) {
      className = 'token-type'
    }

    return className ? (
      <span key={`${token}-${index}`} className={className}>
        {token}
      </span>
    ) : (
      token
    )
  })
}

function ComparisonTable({
  headers,
  rows,
}: {
  headers: [string, string]
  rows: Array<[string, string]>
}) {
  return (
    <div className="comparison-table">
      <div className="comparison-head">{headers[0]}</div>
      <div className="comparison-head">{headers[1]}</div>
      {rows.flatMap(([left, right], index) => [
        <div key={`${index}-left`} className="comparison-cell">
          {left}
        </div>,
        <div key={`${index}-right`} className="comparison-cell">
          {right}
        </div>,
      ])}
    </div>
  )
}

function ThreeColumnTable({
  headers,
  rows,
}: {
  headers: [string, string, string]
  rows: Array<[string, string, string]>
}) {
  return (
    <div className="three-column-table">
      {headers.map((header) => (
        <div key={header} className="comparison-head">
          {header}
        </div>
      ))}
      {rows.flatMap(([first, second, third], index) => [
        <div key={`${index}-first`} className="comparison-cell">
          {first}
        </div>,
        <div key={`${index}-second`} className="comparison-cell mono">
          {second}
        </div>,
        <div key={`${index}-third`} className="comparison-cell">
          {third}
        </div>,
      ])}
    </div>
  )
}

const arithmeticDurationCode = `import Foundation

let now = Date()
let exactly24HoursLater = now.addingTimeInterval(86_400)

print(now)
print(exactly24HoursLater)`

const arithmeticCalendarCode = `import Foundation

let now = Date()

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let sameLocalTimeTomorrow = calendar.date(
    byAdding: .day,
    value: 1,
    to: now
)

print(sameLocalTimeTomorrow as Any)`

const arithmeticStartOfDayCode = `import Foundation

var calendar = Calendar(identifier: .persian)
calendar.timeZone = TimeZone(identifier: "Asia/Tehran")!

let manualMidnight = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 1398,
    month: 1,
    day: 1,
    hour: 0,
    minute: 0
).date

print("Manual 00:00:", manualMidnight as Any)

let noon = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 1398,
    month: 1,
    day: 1,
    hour: 12
).date!

print("startOfDay:", calendar.startOfDay(for: noon))`

const arithmeticComponentsCode = `import Foundation

var components = DateComponents()
components.calendar = Calendar(identifier: .gregorian)
components.timeZone = TimeZone(identifier: "Europe/Amsterdam")
components.year = 2026
components.month = 3
components.day = 29
components.hour = 2
components.minute = 30

let date = components.date

print(date as Any)`

const bugBirthdayCode = `import Foundation

struct Birthday {
    let month: Int
    let day: Int
}

let birthday = Birthday(month: 1, day: 11)`

const bugTimezoneCode = `import Foundation

let fixedOffset = TimeZone(secondsFromGMT: 3 * 60 * 60)
let realTimeZone = TimeZone(identifier: "Europe/Istanbul")

print(fixedOffset as Any)
print(realTimeZone as Any)`

const bugYearCode = `import Foundation

let formatter = DateFormatter()
formatter.locale = Locale(identifier: "en_US_POSIX")
formatter.timeZone = TimeZone(secondsFromGMT: 0)

formatter.dateFormat = "YYYY-MM-dd"
print("Week year:", formatter.string(from: Date()))

formatter.dateFormat = "yyyy-MM-dd"
print("Calendar year:", formatter.string(from: Date()))`

const bugBusinessTimezoneCode = `import Foundation

let paymentExecutionInstant = Date()

var userCalendar = Calendar.current

var businessCalendar = Calendar(identifier: .gregorian)
businessCalendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

print(userCalendar.component(.day, from: paymentExecutionInstant))
print(businessCalendar.component(.day, from: paymentExecutionInstant))`

const formatModernCode = `import Foundation

let date = Date()

let text = date.formatted(
    .dateTime
        .year()
        .month(.wide)
        .day()
        .hour()
        .minute()
)

print(text)`

const formatLocaleCode = `import Foundation

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
print(nl)`

const formatIsoCode = `import Foundation

let string = "2026-04-28T12:30:00Z"

let formatter = ISO8601DateFormatter()
let date = formatter.date(from: string)

print(date as Any)`

const formatStableCode = `import Foundation

let formatter = DateFormatter()
formatter.locale = Locale(identifier: "en_US_POSIX")
formatter.timeZone = TimeZone(secondsFromGMT: 0)
formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"

let date = formatter.date(from: "2026-04-28T12:30:00Z")

print(date as Any)`

const calendarCode = `import Foundation

let date = Date()

let gregorian = Calendar(identifier: .gregorian)
let persian = Calendar(identifier: .persian)
let islamic = Calendar(identifier: .islamic)

print(gregorian.component(.year, from: date))
print(persian.component(.year, from: date))
print(islamic.component(.year, from: date))`

const calendarMonthCode = `import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(secondsFromGMT: 0)!

let jan31 = DateComponents(
    calendar: calendar,
    year: 2026,
    month: 1,
    day: 31
).date!

print(calendar.date(byAdding: .month, value: 1, to: jan31) as Any)`

const calendarMethodTourCode = `import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let instant = ISO8601DateFormatter()
    .date(from: "2026-04-28T12:30:00Z")!

print(calendar.component(.day, from: instant))
print(calendar.dateComponents([.year, .month, .day, .hour], from: instant))
print(calendar.dateInterval(of: .day, for: instant) as Any)
print(calendar.range(of: .day, in: .month, for: instant) as Any)
print(calendar.ordinality(of: .day, in: .year, for: instant) as Any)
print(calendar.isDateInWeekend(instant))
print(calendar.nextWeekend(startingAfter: instant) as Any)`

const arithmeticOrderCode = `import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(secondsFromGMT: 0)!

let start = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 2026,
    month: 1,
    day: 30,
    hour: 9
).date!

let dayThenMonth = calendar.date(byAdding: .month, value: 1, to:
    calendar.date(byAdding: .day, value: 1, to: start)!
)!

let monthThenDay = calendar.date(byAdding: .day, value: 1, to:
    calendar.date(byAdding: .month, value: 1, to: start)!
)!

print(dayThenMonth)
print(monthThenDay)

print(calendar.date(
    byAdding: DateComponents(month: 1, day: 1),
    to: start
) as Any)`

const matchingPolicyCode = `import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let beforeDSTJump = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 2026,
    month: 3,
    day: 28,
    hour: 12
).date!

let requested = DateComponents(hour: 2, minute: 30)

print(calendar.nextDate(
    after: beforeDSTJump,
    matching: requested,
    matchingPolicy: .nextTime
) as Any)

print(calendar.nextDate(
    after: beforeDSTJump,
    matching: requested,
    matchingPolicy: .strict
) as Any)`

const extractingComponentsCode = `import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let instant = ISO8601DateFormatter()
    .date(from: "2026-04-28T12:30:00Z")!
let nextInstant = ISO8601DateFormatter()
    .date(from: "2026-04-30T15:45:00Z")!

let local = calendar.dateComponents(
    [.year, .month, .day, .hour, .minute],
    from: instant
)
print(local)
print(calendar.component(.weekday, from: instant))
print(calendar.date(instant, matchesComponents: DateComponents(day: 28)))
print(calendar.dateComponents([.day, .hour], from: instant, to: nextInstant))

let amsterdamNoon = DateComponents(timeZone: calendar.timeZone, hour: 12)
let tehranEvening = DateComponents(
    timeZone: TimeZone(identifier: "Asia/Tehran"),
    hour: 17
)
print(calendar.dateComponents([.hour], from: amsterdamNoon, to: tehranEvening))
print(calendar.dateComponents(in: TimeZone(identifier: "Asia/Tehran")!, from: instant))`

const calendarInfoCode = `import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(secondsFromGMT: 0)!

let date = DateComponents(
    calendar: calendar,
    year: 2024,
    month: 2,
    day: 29
).date!

print(calendar.ordinality(of: .day, in: .year, for: date) as Any)
print(calendar.range(of: .day, in: .month, for: date) as Any)
print(calendar.range(of: .weekOfMonth, in: .month, for: date) as Any)`

const scanningDatesCode = `import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let start = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 2026,
    month: 3,
    day: 25
).date!
let end = calendar.date(byAdding: .day, value: 10, to: start)!

print(calendar.startOfDay(for: start))

calendar.enumerateDates(
    startingAfter: start,
    matching: DateComponents(hour: 9, minute: 30),
    matchingPolicy: .nextTime
) { date, exactMatch, stop in
    print(date as Any, exactMatch)
    stop = true
}

print(calendar.nextDate(
    after: start,
    matching: DateComponents(hour: 9, minute: 30),
    matchingPolicy: .nextTime
) as Any)

print(Array(calendar.dates(
    byAdding: .day,
    value: 2,
    startingAt: start,
    in: start..<end
).prefix(3)))`

const scanningSequencesCode = `import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let start = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 2026,
    month: 4,
    day: 1
).date!
let end = calendar.date(byAdding: .day, value: 20, to: start)!
let range = start..<end

let everyThreeDays = calendar.dates(
    byAdding: DateComponents(day: 3),
    startingAt: start,
    in: range
)

let mondayNine = calendar.dates(
    byMatching: DateComponents(hour: 9, weekday: 2),
    startingAt: start,
    in: range,
    matchingPolicy: .nextTime
)

print(Array(everyThreeDays.prefix(5)))
print(Array(mondayNine.prefix(3)))`

const calculatingDatesCode = `import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let base = DateComponents(
    calendar: calendar,
    timeZone: calendar.timeZone,
    year: 2026,
    month: 3,
    day: 29,
    hour: 12
).date!

print(calendar.date(from: DateComponents(year: 2026, month: 4, day: 28)) as Any)
print(calendar.date(byAdding: DateComponents(month: 1, day: 1), to: base) as Any)
print(calendar.date(byAdding: .day, value: 1, to: base) as Any)
print(calendar.date(bySetting: .day, value: 1, of: base) as Any)
print(calendar.date(
    bySettingHour: 2,
    minute: 30,
    second: 0,
    of: base,
    matchingPolicy: .nextTime
) as Any)`

const intervalComparisonCode = `import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let first = ISO8601DateFormatter()
    .date(from: "2026-04-28T12:00:00Z")!
let second = ISO8601DateFormatter()
    .date(from: "2026-04-28T21:00:00Z")!

print(calendar.dateInterval(of: .day, for: first) as Any)

var start = Date()
var duration: TimeInterval = 0
print(calendar.dateInterval(of: .month, start: &start, interval: &duration, for: first))
print(start, duration)

print(calendar.compare(first, to: second, toGranularity: .day).rawValue)
print(calendar.isDate(first, equalTo: second, toGranularity: .day))
print(calendar.isDate(first, inSameDayAs: second))
print(calendar.isDateInToday(first))
print(calendar.isDateInTomorrow(first))
print(calendar.isDateInYesterday(first))
print(calendar.isDateInWeekend(first))`

const tzdbSourceSnippet = `Rule Iran 2021 2022 - Mar 21 24:00 1:00 -
Rule Iran 2021 2022 - Sep 21 24:00 0 -
Zone Asia/Tehran 3:25:44 - LMT 1916
                  3:25:44 - TMT 1935 Jun 13
                  3:30 Iran %z 1977 Oct 20 24:00
                  4:00 Iran %z 1978 Nov 10 24:00
                  3:30 Iran %z`

const persianCalendarSourceSnippet = `static const int8_t kPersianMonthLength[] =
    {31,31,31,31,31,31,30,30,30,30,30,29};

static const int8_t kPersianLeapMonthLength[] =
    {31,31,31,31,31,31,30,30,30,30,30,30};`

const cldrPersianNamesSnippet = `"persian": {
  "months": {
    "format": {
      "wide": {
        "1": "فروردین",
        "2": "اردیبهشت",
        "3": "خرداد",
        "12": "اسفند"
      }
    }
  }
}`

const timezoneLookupCode = `import Foundation

let instant = ISO8601DateFormatter()
    .date(from: "2026-04-28T12:00:00Z")!

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Amsterdam")!

let components = calendar.dateComponents(
    [.year, .month, .day, .hour, .minute, .timeZone],
    from: instant
)

print(components)`

const exactInstantJson = `{
  "createdAt": "2026-04-28T12:30:00Z"
}`

const localDateJson = `{
  "birthDate": "1998-01-11"
}`

const futureLocalJson = `{
  "date": "2026-10-25",
  "time": "09:00:00",
  "timeZone": "Europe/Amsterdam"
}`

const testingClockCode = `import Foundation

protocol Clock {
    var now: Date { get }
}

struct SystemClock: Clock {
    var now: Date { Date() }
}

struct FixedClock: Clock {
    let now: Date
}`

const testingExpiryCode = `import Foundation

struct ExpiryChecker {
    let clock: Clock

    func isExpired(_ expiryDate: Date) -> Bool {
        expiryDate < clock.now
    }
}`

const testingStableCode = `import Foundation

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(secondsFromGMT: 0)!

let locale = Locale(identifier: "en_US_POSIX")
let timezone = TimeZone(secondsFromGMT: 0)!`

const slideReferences = {
  calendrical: {
    label: 'Your Calendrical Fallacy Is',
    href: 'https://yourcalendricalfallacyis.com/',
  },
  falsehoodsProgrammersBelieveTime: {
    label: 'Falsehoods programmers believe about time',
    href: 'https://gist.github.com/timvisee/fcda9bbdff88d45cc9061606b4b923ca',
  },
  date: {
    label: 'Apple Date',
    href: 'https://developer.apple.com/documentation/foundation/date',
  },
  calendar: {
    label: 'Apple Calendar',
    href: 'https://developer.apple.com/documentation/foundation/calendar',
  },
  formatter: {
    label: 'Apple DateFormatter',
    href: 'https://developer.apple.com/documentation/foundation/dateformatter',
  },
  formatStyle: {
    label: 'Apple Date.FormatStyle',
    href: 'https://developer.apple.com/documentation/foundation/date/formatstyle',
  },
  iana: {
    label: 'IANA Time Zones',
    href: 'https://www.iana.org/time-zones',
  },
  ianaTheory: {
    label: 'IANA tzdb Theory',
    href: 'https://data.iana.org/time-zones/tzdb/theory.html',
  },
  tzGitHub: {
    label: 'IANA tzdb GitHub mirror',
    href: 'https://github.com/eggert/tz',
  },
  icu: {
    label: 'Unicode ICU Date/Time',
    href: 'https://unicode-org.github.io/icu/userguide/format_parse/datetime/',
  },
  icuGitHub: {
    label: 'Unicode ICU GitHub',
    href: 'https://github.com/unicode-org/icu',
  },
  icuPersianCalendarSource: {
    label: 'ICU PersianCalendar source',
    href: 'https://github.com/unicode-org/icu/blob/main/icu4c/source/i18n/persncal.cpp',
  },
  icuPersianCalendarDocs: {
    label: 'ICU PersianCalendar docs',
    href: 'https://unicode-org.github.io/icu-docs/apidoc/dev/icu4j/com/ibm/icu/util/PersianCalendar.html',
  },
  cldr: {
    label: 'Unicode CLDR Date/Time Patterns',
    href: 'https://cldr.unicode.org/translation/date-time/date-time-patterns',
  },
  cldrGitHub: {
    label: 'Unicode CLDR GitHub',
    href: 'https://github.com/unicode-org/cldr',
  },
  rfc3339: {
    label: 'RFC 3339',
    href: 'https://www.rfc-editor.org/rfc/rfc3339',
  },
  rfc9110: {
    label: 'RFC 9110 HTTP Semantics',
    href: 'https://www.rfc-editor.org/rfc/rfc9110',
  },
  ffs: {
    label: 'Fucking Format Style',
    href: 'https://fuckingformatstyle.com/',
  },
  ffsDates: {
    label: 'Fucking Format Style: Date Styles',
    href: 'https://fuckingformatstyle.com/date-styles/',
  },
  timeGitHub: {
    label: 'davedelong/time GitHub',
    href: 'https://github.com/davedelong/time',
  },
  timeDocs: {
    label: 'davedelong/time Docs',
    href: 'https://swiftpackageindex.com/davedelong/time/documentation/time',
  },
}

export const slides: Slide[] = [
  {
    id: 'title',
    section: '01',
    title: 'Date & Time in Software Engineering',
    eyebrow: 'Swift · Foundation · Calendars · Timezones · Formatting · APIs',
    references: [slideReferences.date, slideReferences.calendar],
    render: () => (
      <div className="hero-layout">
        <p className="hero-kicker">Why your assumptions are probably wrong</p>
        <h1>Date &amp; Time in Software Engineering</h1>
        <p className="hero-body">
          A practical field guide for iOS and backend engineers who have been
          betrayed by `Date`, midnight, and “tomorrow”.
        </p>
      </div>
    ),
  },
  {
    id: 'overview',
    section: '01',
    title: 'Talk Overview',
    references: [slideReferences.date, slideReferences.calendar],
    render: () => (
      <div className="split-layout">
        <div className="section-headline">
          <h3>We will move from mental models to production contracts.</h3>
          <p>
            The goal is not to memorize every calendar rule. The goal is to
            model what the value means before choosing `Date`, `Calendar`,
            `TimeZone`, a string format, or an API field.
          </p>
        </div>
        <Bullets
          items={[
            'Instants, local dates, clock times, formatted strings',
            'Swift/Foundation primitives and how they compose',
            'Calendar arithmetic, DST, and reproducible bugs',
            'Formatting, parsing, ISO 8601, RFC 3339, ICU, CLDR, tzdb',
            'Backend/frontend API contracts and storage choices',
            'Testing boundaries, weird calendars, and leap seconds',
          ]}
        />
      </div>
    ),
  },
  {
    id: 'why-hard',
    section: '02',
    title: 'Why Date/Time Is Hard',
    references: [slideReferences.calendrical],
    render: () => (
      <div className="split-layout">
        <div className="section-headline">
          <h3>The hard part is not storing a timestamp.</h3>
          <p>
            The hard part is preserving what the user, business rule, protocol,
            or database meant by a date-like value. The same string can mean an
            instant, a birthday, a local appointment, or only a UI label.
          </p>
        </div>
        <Bullets
          items={[
            'A calendar day can be 23 or 25 hours when DST changes.',
            '`UTC+03:00` is an offset; `Europe/Istanbul` is a rule set.',
            '`2026-04-28` is a local date, not automatically midnight UTC.',
            '`Apr 28, 2026` is presentation text, not a stable API format.',
            'UTC fixes exact instants; it does not model birthdays, due dates, or future local schedules.',
          ]}
        />
      </div>
    ),
  },
  {
    id: 'mental-model',
    section: '03',
    title: 'Core Mental Model',
    references: [slideReferences.date],
    render: () => (
      <div className="stack-lg">
        <div className="equation">
          <span>Instant</span>
          <span>≠</span>
          <span>Local Date</span>
          <span>≠</span>
          <span>Clock Time</span>
          <span>≠</span>
          <span>Formatted String</span>
        </div>
        <p className="body-copy">
          Start every date/time decision by naming the domain concept. An
          instant answers “when on the timeline?” A local date answers “which
          calendar day?” A clock time answers “what wall-clock time?” A
          formatted string answers “how should a human see it?”
        </p>
        <Bullets
          items={[
            'Instant: `2026-04-28T12:30:00Z`, useful for logs and audit events.',
            'Local date: `2026-04-28`, useful for birthdays and statement dates.',
            'Clock time: `09:30`, useful only with a date, timezone, or recurrence rule.',
            'Formatted string: localized output at the UI boundary.',
          ]}
        />
        <Callout tone="accent">
          Human meaning = value + calendar rules + timezone rules + locale or
          business context.
        </Callout>
      </div>
    ),
  },
  {
    id: 'primitives',
    section: '04',
    title: 'Swift/Foundation Primitives',
    references: [
      slideReferences.date,
      slideReferences.calendar,
      slideReferences.formatter,
      slideReferences.formatStyle,
    ],
    render: () => (
      <div className="split-layout">
        <div className="section-headline">
          <h3>Foundation gives you small pieces, not one magic type.</h3>
          <p>
            `Date` is the instant. The calendar, timezone, locale, and
            formatter are separate because interpretation and display are
            separate operations.
          </p>
        </div>
        <Bullets
          items={[
            '`Date`: timeline instant, no stored timezone, calendar, or locale.',
            '`Calendar`: converts between instants and date components using calendar rules.',
            '`DateComponents`: partial or complete pieces such as year, month, day, hour.',
            '`TimeZone`: civil-time rules for a region or fixed offset.',
            '`Locale`: cultural display preferences.',
            '`DateFormatter` / `Date.FormatStyle`: turn values into strings or parse fixed formats.',
          ]}
        />
      </div>
    ),
  },
  {
    id: 'pipeline',
    section: '05',
    title: 'How The Primitives Relate',
    references: [slideReferences.date, slideReferences.calendar],
    render: () => (
      <div className="pipeline-layout">
        <p className="body-copy">
          A `Date` becomes useful to a person only after you choose the rules
          for interpreting it. The same instant can be Tuesday afternoon in one
          place and Tuesday morning somewhere else, and a different calendar can
          give it a different year or month.
        </p>
        <div className="pipeline-card">
          <span className="mono">2026-04-28T12:00:00Z</span>
          <span className="pipeline-arrow">↓</span>
          <span>Europe/Istanbul + Gregorian + en_US</span>
          <span className="pipeline-arrow">↓</span>
          <strong>April 28, 2026, 15:00</strong>
        </div>
        <CodeBlock
          title="Meaning appears when you add rules"
          code={`let instant = Date()

var calendar = Calendar(identifier: .gregorian)
calendar.timeZone = TimeZone(identifier: "Europe/Istanbul")!

let components = calendar.dateComponents(
    [.year, .month, .day, .hour, .minute],
    from: instant
)`}
          caption="`Date` stays calendar-free until you interpret it."
        />
      </div>
    ),
  },
  {
    id: 'arithmetic',
    section: '06',
    title: 'Calendar, Calendar Arithmetic and Common Wrong Assumptions',
    liveCoding: true,
    references: [slideReferences.calendar, slideReferences.calendrical],
    render: () => (
      <>
        <div className="section-headline">
          <h3>What does “tomorrow” mean?</h3>
          <p>Exactly 24 elapsed hours, or the same local calendar time?</p>
        </div>
        <div className="code-grid">
          <CodeBlock
            title="Exact elapsed duration"
            code={arithmeticDurationCode}
            caption="Use when you truly mean 86,400 elapsed seconds."
          />
          <CodeBlock
            title="Same local time tomorrow"
            code={arithmeticCalendarCode}
            caption="Use calendar arithmetic when the meaning is civil time."
          />
          <CodeBlock
            title="Start of day"
            code={arithmeticStartOfDayCode}
            caption="Manual 00:00 is not the same as asking the calendar for the start of a day."
          />
          <CodeBlock
            title="Construct local components"
            code={arithmeticComponentsCode}
            caption="Useful for ambiguous or invalid DST moments."
          />
        </div>
      </>
    ),
  },
  {
    id: 'extracting-components',
    section: '06',
    title: 'Extracting Components',
    liveCoding: true,
    references: [slideReferences.calendar],
    render: () => (
      <div className="split-layout">
        <div className="stack-lg">
          <div className="section-headline">
            <h3>Component extraction always has a calendar and timezone.</h3>
            <p>
              The common wrong move is to read `.day` or `.hour` with whatever
              `Calendar.current` happens to be, then use that as business data.
              Choose the calendar/timezone that owns the meaning.
            </p>
          </div>
          <Bullets
            items={[
              '`date(_:matchesComponents:)` checks a date against component constraints.',
              '`component(_:from:)` reads one field.',
              '`dateComponents(_:from:)` reads a set of fields.',
              '`dateComponents(_:from:to:)` calculates field differences.',
              '`dateComponents(in:from:)` reads fields as if in a given timezone.',
            ]}
          />
        </div>
        <CodeBlock
          title="Extracting and comparing components"
          code={extractingComponentsCode}
          caption="The playground version keeps this as a focused method-by-method demo."
        />
      </div>
    ),
  },
  {
    id: 'calendar-info-methods',
    section: '06',
    title: 'Getting Calendar Information',
    liveCoding: true,
    references: [slideReferences.calendar],
    render: () => (
      <div className="split-layout">
        <div className="section-headline">
          <h3>Ask the calendar what is valid.</h3>
          <p>
            Do not hard-code “February has 28 days” or “day of year is simple
            subtraction”. Leap years, calendar systems, and locale rules make
            those assumptions brittle.
          </p>
        </div>
        <CodeBlock
          title="ordinality and range"
          code={calendarInfoCode}
          caption="Use `ordinality` and `range` for calendar facts instead of manual tables."
        />
      </div>
    ),
  },
  {
    id: 'calendar-methods',
    section: '06',
    title: 'Calendar API Tour',
    liveCoding: true,
    references: [slideReferences.calendar],
    render: () => (
      <div className="split-layout">
        <div className="stack-lg">
          <div className="section-headline">
            <h3>`Calendar` is the rule engine.</h3>
            <p>
              Use it to extract components, build dates from components, ask
              for intervals and ranges, compare by granularity, find weekends,
              and search for the next matching local time.
            </p>
          </div>
          <Bullets
            items={[
              '`component` and `dateComponents` read calendar fields.',
              '`date(from:)` turns local components into an instant if possible.',
              '`dateInterval` and `range` describe calendar boundaries.',
              '`nextDate` searches using matching policies around DST edges.',
            ]}
          />
        </div>
        <CodeBlock
          title="Calendar methods in one place"
          code={calendarMethodTourCode}
          caption="The playground page includes a longer version with comparison and weekend APIs."
        />
      </div>
    ),
  },
  {
    id: 'scanning-dates',
    section: '06',
    title: 'Scanning Dates',
    liveCoding: true,
    references: [slideReferences.calendar],
    render: () => (
      <div className="code-grid">
        <CodeBlock
          title="startOfDay, enumerateDates, nextDate, dates by component"
          code={scanningDatesCode}
          caption="Use scanning APIs when you need calendar matches, not arithmetic guesses."
        />
        <CodeBlock
          title="dates sequences"
          code={scanningSequencesCode}
          caption="Sequence APIs are useful for generating occurrences within a bounded range."
        />
      </div>
    ),
  },
  {
    id: 'calculating-dates',
    section: '06',
    title: 'Calculating Dates From Components',
    liveCoding: true,
    references: [slideReferences.calendar],
    render: () => (
      <div className="split-layout">
        <div className="section-headline">
          <h3>Constructing and changing dates can fail or shift.</h3>
          <p>
            `date(from:)`, `date(bySetting:)`, and
            `date(bySettingHour:minute:second:of:)` all need policy thinking
            when the requested local value is invalid or ambiguous.
          </p>
        </div>
        <CodeBlock
          title="from components, adding, and setting"
          code={calculatingDatesCode}
          caption="Prefer explicit calendar methods over mutating string fragments or timestamp math."
        />
      </div>
    ),
  },
  {
    id: 'intervals-and-comparisons',
    section: '06',
    title: 'Intervals And Comparisons',
    liveCoding: true,
    references: [slideReferences.calendar],
    render: () => (
      <div className="split-layout">
        <div className="section-headline">
          <h3>Compare at the granularity you mean.</h3>
          <p>
            Two instants can be different but still be in the same calendar
            day, month, weekend, or business period. Make that granularity
            explicit.
          </p>
        </div>
        <CodeBlock
          title="dateInterval and comparison helpers"
          code={intervalComparisonCode}
          caption="These APIs avoid manual boundary checks and string-based comparison."
        />
      </div>
    ),
  },
  {
    id: 'arithmetic-order',
    section: '06',
    title: 'Arithmetic Order Matters',
    liveCoding: true,
    references: [slideReferences.calendar],
    render: () => (
      <div className="split-layout">
        <div className="stack-lg">
          <div className="section-headline">
            <h3>Calendar arithmetic is not commutative.</h3>
            <p>
              Adding a day and then adding a month can produce a different
              result than adding a month and then adding a day. End-of-month
              rollover makes the order observable.
            </p>
          </div>
          <Callout tone="warning">
            If the product rule is “add this calendar period”, prefer one
            combined `DateComponents` operation over accidental step-by-step
            arithmetic.
          </Callout>
        </div>
        <CodeBlock
          title="Day then month vs month then day"
          code={arithmeticOrderCode}
          caption="Choose the operation order deliberately, or encode the whole period in one `DateComponents` value."
        />
      </div>
    ),
  },
  {
    id: 'calendar-matching-policies',
    section: '06',
    title: 'Matching Policies Around DST',
    liveCoding: true,
    references: [slideReferences.calendar],
    render: () => (
      <div className="split-layout">
        <div className="section-headline">
          <h3>Some local times do not exist.</h3>
          <p>
            Around DST start, a local time such as 02:30 may be skipped.
            `Calendar.nextDate` lets you decide whether to take the next
            available time or require a strict match.
          </p>
        </div>
        <CodeBlock
          title="nextDate matching policies"
          code={matchingPolicyCode}
          caption="Use matching policies instead of silently accepting whatever date construction returns."
        />
      </div>
    ),
  },
  {
    id: 'bugs',
    section: '06',
    title: 'Common Wrong Assumptions',
    liveCoding: true,
    references: [
      slideReferences.formatter,
      slideReferences.iana,
      slideReferences.ianaTheory,
      slideReferences.icu,
    ],
    render: () => (
      <div className="code-grid">
        <CodeBlock
          title="Bug 1: Birthday is not a Date"
          code={bugBirthdayCode}
          caption="A birthday is a local recurring concept, not a midnight UTC instant."
        />
        <CodeBlock
          title="Bug 2: Timezone is not offset"
          code={bugTimezoneCode}
          caption="Offsets are numbers. Timezones are political rule sets."
        />
        <CodeBlock
          title="Bug 3: `YYYY` is not `yyyy`"
          code={bugYearCode}
          caption="Week-based year bites around New Year."
        />
        <CodeBlock
          title="Bug 4: Device zone ≠ business zone"
          code={bugBusinessTimezoneCode}
          caption="Statements, payments, and ledgers often follow business time."
        />
      </div>
    ),
  },
  {
    id: 'fallacies',
    section: '07',
    title: 'Calendrical Fallacies',
    references: [
      slideReferences.calendrical,
      slideReferences.falsehoodsProgrammersBelieveTime,
    ],
    render: () => (
      <>
        <BulletGrid
          items={[
            'Days: tomorrow is not always `now + 86400`.',
            'Months and years: variable lengths and leap rules exist.',
            'Timezones: abbreviations and offsets are lossy.',
            'Formatting: strings are locale-shaped output.',
            'Distributed systems: clock order is not event truth.',
          ]}
        />
      </>
    ),
  },
  {
    id: 'timezone-data',
    section: '08',
    title: 'Under The Hood: Timezone Data',
    references: [
      slideReferences.iana,
      slideReferences.ianaTheory,
      slideReferences.tzGitHub,
    ],
    render: () => (
      <div className="stack-lg">
        <div className="equation">
          <span>Timezone ID</span>
          <span>↓</span>
          <span>Rule Database</span>
          <span>↓</span>
          <span>Offset At One Instant</span>
          <span>↓</span>
          <span>Local Civil Time</span>
        </div>
        <p className="body-copy">
          A timezone conversion is a data lookup. The platform takes a zone
          identifier, finds the matching rule for one instant, and computes the
          offset and local civil time for that instant.
        </p>
        <Bullets
          items={[
            '`Europe/Amsterdam` is not just `UTC+01:00`; summer and winter can differ.',
            '`Asia/Tehran` has changed civil-time behavior across history.',
            '`Europe/Istanbul` has had political rule changes.',
            'A stale phone and a patched backend can disagree about a future local time.',
          ]}
        />
        <CodeBlock
          title="Actual tzdb-style source"
          language="text"
          code={tzdbSourceSnippet}
          caption="`zic` reads the `Zone Asia/Tehran` timeline top to bottom. When a row references `Iran`, matching `Rule Iran` rows add or remove DST for the date range; `%z` formats the resulting numeric offset."
        />
      </div>
    ),
  },
  {
    id: 'timezone-lookup',
    section: '08',
    title: 'Timezone Lookup Is Computation',
    references: [
      slideReferences.calendar,
      slideReferences.ianaTheory,
      slideReferences.tzGitHub,
    ],
    render: () => (
      <div className="split-layout">
        <div className="stack-lg">
          <div className="section-headline">
            <h3>Offset is the output, not the model.</h3>
            <p>
              Store the timezone ID when the business fact belongs to a place.
              Compute the offset for a specific instant or local occurrence.
            </p>
          </div>
          <Bullets
            items={[
              'Input: instant + timezone ID',
              'Lookup: installed tzdb version and matching transition rule',
              'Output: local date/time + offset at that instant',
              'Audit-heavy systems may also store the tzdb version used.',
            ]}
          />
        </div>
        <CodeBlock
          title="Rule lookup through Calendar"
          code={timezoneLookupCode}
          caption="Foundation hides the tzdb lookup behind `Calendar` and `TimeZone`."
        />
      </div>
    ),
  },
  {
    id: 'calendars',
    section: '09',
    title: 'Under The Hood: Calendars',
    references: [
      slideReferences.calendar,
      slideReferences.icuPersianCalendarDocs,
      slideReferences.icuPersianCalendarSource,
      slideReferences.cldr,
    ],
    render: () => (
      <div className="stack-lg">
        <p className="body-copy">
          Calendars are not usually stored as transition databases like tzdb.
          Libraries combine calendar algorithms with locale data: ICU computes
          calendar fields, while CLDR supplies localized names, patterns, and
          preferences.
        </p>
        <BulletGrid
          items={[
            'Year, month, day, week, era',
            'Leap rules',
            'First weekday',
            'Minimum days in first week',
            'Business logic should usually choose an explicit calendar',
            'Calendar arithmetic is field-based, not elapsed-time math',
          ]}
        />
        <CodeBlock
          title="Same instant, different calendar"
          code={calendarCode}
          caption="`Calendar.current` is excellent for UI, not always for domain rules."
        />
        <CodeBlock
          title="Actual ICU Persian calendar source"
          language="text"
          code={persianCalendarSourceSnippet}
          caption="ICU's Persian calendar implementation encodes month lengths in code: the first six months have 31 days, the next five have 30, and Esfand is 29 or 30 depending on the leap-year calculation."
        />
        <CodeBlock
          title="CLDR Persian localized names"
          language="json"
          code={cldrPersianNamesSnippet}
          caption="CLDR data supplies locale-specific labels such as Persian month names. Calendar math comes from the calendar implementation; display names and patterns come from locale data."
        />
      </div>
    ),
  },
  {
    id: 'calendar-overflow',
    section: '09',
    title: 'Calendar Arithmetic Has Product Semantics',
    references: [slideReferences.calendar],
    render: () => (
      <div className="split-layout">
        <div className="stack-lg">
          <div className="section-headline">
            <h3>What is one month after January 31?</h3>
            <p>
              Calendar arithmetic asks a rule system to move fields. Product
              logic still has to define overflow behavior, end-of-month
              behavior, and what happens when a target local time is invalid.
            </p>
          </div>
          <Bullets
            items={[
              'End-of-month billing needs explicit rules.',
              'Recurring events need local date/time plus timezone.',
              'Leap days force a policy for non-leap years.',
              'Week-year rules can move January dates into the previous reporting year.',
            ]}
          />
        </div>
        <CodeBlock
          title="Month addition is not duration addition"
          code={calendarMonthCode}
          caption="The calendar decides how to resolve an impossible February 31."
        />
      </div>
    ),
  },
  {
    id: 'formatting',
    section: '10',
    title: 'Formatting And Parsing',
    liveCoding: true,
    references: [
      slideReferences.formatter,
      slideReferences.formatStyle,
      slideReferences.ffs,
      slideReferences.ffsDates,
    ],
    render: () => (
      <>
        <div className="section-headline">
          <h3>Formatting is localization</h3>
          <p>Locale, calendar, timezone, user settings, and runtime versions all shape output.</p>
        </div>
        <div className="code-grid">
          <CodeBlock
            title="Modern `Date.FormatStyle`"
            code={formatModernCode}
            caption="Prefer declarative formatting for UI in modern Swift."
          />
          <CodeBlock
            title="Locale-aware output"
            code={formatLocaleCode}
            caption="Same instant, different human strings."
          />
          <CodeBlock
            title="ISO 8601 API parsing"
            code={formatIsoCode}
            caption="Use structured parsers for machine timestamps."
          />
          <CodeBlock
            title="Stable `DateFormatter` parsing"
            code={formatStableCode}
            caption="Use `en_US_POSIX` when fixed-format parsing is unavoidable."
          />
        </div>
      </>
    ),
  },
  {
    id: 'format-standards',
    section: '10',
    title: 'Wire Formats Are Contracts',
    references: [
      slideReferences.rfc3339,
      slideReferences.rfc9110,
      slideReferences.formatStyle,
    ],
    render: () => (
      <div className="stack-lg">
        <div className="section-headline">
          <h3>We have many standards because the jobs are different.</h3>
          <p>
            A UI string, JSON timestamp, HTTP header, log line, database
            timestamp, and recurring calendar event do not all need the same
            representation.
          </p>
        </div>
        <ThreeColumnTable
          headers={['Format', 'Sample', 'Typical use']}
          rows={[
            ['ISO 8601', '2026-04-28T12:30:00+02:00', 'Broad family of date/time representations used for machine-readable dates and timestamps'],
            ['RFC 3339', '2026-04-28T12:30:00Z', 'Internet timestamp profile commonly used in JSON APIs'],
            ['HTTP-date / RFC 9110', 'Tue, 28 Apr 2026 12:30:00 GMT', 'Protocol headers such as `Date`, `Expires`, and `Last-Modified`'],
            ['Unix time', '1777389000', 'Compact numeric instant, but no calendar meaning by itself'],
          ]}
        />
        <Bullets
          items={[
            'Swift: `ISO8601DateFormatter` or `Date.ISO8601FormatStyle` for API timestamps.',
            'JavaScript: `Date.prototype.toISOString()` emits an ISO-like UTC timestamp.',
            'HTTP clients: use HTTP-date for protocol headers, not product model data.',
            'UI: use localized format styles instead of wire formats.',
          ]}
        />
      </div>
    ),
  },
  {
    id: 'icu-cldr',
    section: '11',
    title: 'System Time Data: ICU, CLDR, tzdb',
    references: [
      slideReferences.icu,
      slideReferences.cldr,
      slideReferences.iana,
    ],
    render: () => (
      <div className="stack-lg">
        <div className="pipeline-card">
          <span>Foundation / Java / JavaScript Intl / backend runtimes</span>
          <span className="pipeline-arrow">↓</span>
          <span>ICU algorithms and APIs</span>
          <span className="pipeline-arrow">↓</span>
          <span>CLDR locale data</span>
          <span className="pipeline-arrow">↓</span>
          <strong>IANA tzdb timezone rules</strong>
        </div>
        <Bullets
          items={[
            'ICU provides internationalization behavior: date formatting, parsing, calendars, numbers, collation, and locale APIs.',
            'CLDR provides data: month names, date patterns, numbering systems, calendar names, plural rules, and locale preferences.',
            'IANA tzdb provides timezone IDs, historical offsets, DST transitions, and civil-time rule changes.',
            'System libraries ship versions of these data sets, so output can differ across OS/runtime versions.',
          ]}
        />
      </div>
    ),
  },
  {
    id: 'data-repos',
    section: '11',
    title: 'The Rules Are In Repositories',
    references: [
      slideReferences.icuGitHub,
      slideReferences.cldrGitHub,
      slideReferences.tzGitHub,
    ],
    render: () => (
      <div className="stack-lg">
        <p className="body-copy">
          These are not magic constants inside `DateFormatter`. They are
          maintained data and code projects that platforms package and update.
        </p>
        <ComparisonTable
          headers={['Repository', 'What to look for']}
          rows={[
            ['unicode-org/icu', 'Internationalization library code and data build tooling'],
            ['unicode-org/cldr', 'Locale XML data, including calendars, date fields, and patterns'],
            ['eggert/tz', 'Text rule files such as `europe`, `asia`, and `northamerica`'],
          ]}
        />
        <CodeBlock
          title="Repository-style rule examples"
          language="text"
          code={`tzdb files define zones and transition rules as source data.
CLDR XML stores locale-specific names, fields, and date/time patterns.
ICU consumes data and exposes platform-facing internationalization APIs.`}
          caption="The exact generated data shipped on a device depends on platform and OS version."
        />
      </div>
    ),
  },
  {
    id: 'time-package',
    section: '12',
    title: 'davedelong/time',
    references: [slideReferences.timeGitHub, slideReferences.timeDocs],
    render: () => (
      <div className="stack-lg">
        <ComparisonTable
          headers={['Foundation', 'Time package']}
          rows={[
            ['Powerful and flexible', 'More domain-specific intent'],
            ['Easy to misuse under pressure', 'Type-safe modeling aims to prevent misuse'],
            ['You compose the rules yourself', 'The library tries to surface better concepts'],
          ]}
        />
        <Callout tone="accent">
          Foundation gives you the building blocks. `Time` explores stronger
          domain types so date/time intent is harder to lose in application
          code.
        </Callout>
      </div>
    ),
  },
  {
    id: 'api-contracts',
    section: '13',
    title: 'API Contracts: Preserve Meaning',
    references: [slideReferences.date, slideReferences.iana, slideReferences.rfc3339],
    render: () => (
      <div className="stack-lg">
        <p className="body-copy">
          Backend/frontend contracts should say what the value means, who owns
          it, how precise it is, and which rules are needed to interpret it.
          A field named `date` is usually not enough.
        </p>
        <BulletGrid
          items={[
            'Transaction timestamp → instant',
            'Statement period → local date range + business timezone',
            'Scheduled payment → local date/time + timezone',
            'Card expiry → month/year',
          ]}
        />
        <Callout tone="warning">
          UTC is excellent for instants. It is not enough for every business
          date/time domain.
        </Callout>
      </div>
    ),
  },
  {
    id: 'api-contract-shapes',
    section: '13',
    title: 'Three Common Contract Shapes',
    references: [slideReferences.rfc3339, slideReferences.iana],
    render: () => (
      <div className="code-grid code-grid-three">
        <CodeBlock
          title="Exact instant"
          language="json"
          code={exactInstantJson}
          caption="Use for created/updated timestamps, audit logs, sent-at times, and executed transactions."
        />
        <CodeBlock
          title="Pure local date"
          language="json"
          code={localDateJson}
          caption="Use for birthdays, due dates, statement dates, expiry dates, and date-only facts."
        />
        <CodeBlock
          title="Future local schedule"
          language="json"
          code={futureLocalJson}
          caption="Use for payments, meetings, reminders, recurring events, and market hours."
        />
      </div>
    ),
  },
  {
    id: 'api-contract-howto',
    section: '13',
    title: 'Contract Design Checklist',
    references: [slideReferences.calendar, slideReferences.iana],
    render: () => (
      <div className="split-layout">
        <div className="stack-lg">
          <h3 className="subheading">Document every field.</h3>
          <Bullets
            items={[
              'Semantic type: instant, local date, local time, duration, or period',
              'Timezone rule: user, business, event, UTC, or explicit zone ID',
              'Calendar rule: Gregorian by default, or explicit non-Gregorian model',
              'Precision: day, minute, second, millisecond, or nanosecond',
              'Authority: server, client, provider, or user input',
              'Failure behavior: invalid local time, ambiguous local time, parse failure',
            ]}
          />
        </div>
        <div className="stack-lg">
          <h3 className="subheading">Store for future change.</h3>
          <Bullets
            items={[
              'Keep recurrence rules separate from generated occurrence instants.',
              'For future local events, store local date, local time, and IANA timezone ID.',
              'Compute instants late when timezone laws can change.',
              'For audit-heavy systems, persist the tzdb version used for calculation.',
              'Keep display strings out of source data.',
            ]}
          />
        </div>
      </div>
    ),
  },
  {
    id: 'api-dos-donts',
    section: '13',
    title: 'Contract Dos And Don’ts',
    references: [
      slideReferences.date,
      slideReferences.calendar,
      slideReferences.iana,
      slideReferences.formatStyle,
    ],
    render: () => (
      <ComparisonTable
        headers={['Do', 'Don’t']}
        rows={[
          ['Store instants as RFC 3339 / ISO 8601 UTC or explicit-offset timestamps', 'Treat every date-like value as `Date`'],
          ['Use `Calendar` for calendar math', 'Add `86400` seconds for “tomorrow”'],
          ['Use IANA timezone IDs for real places and future events', 'Store only offsets for future local events'],
          ['Use explicit calendar/timezone for business logic', 'Parse display strings as source data'],
          ['Use locale-aware formatting for UI', 'Use `YYYY` when you mean `yyyy`'],
          ['Inject clocks where behavior depends on now', 'Trust device time for business/security truth'],
        ]}
      />
    ),
  },
  {
    id: 'testing',
    section: '14',
    title: 'Testing Date/Time Logic',
    references: [slideReferences.calendar, slideReferences.formatter],
    render: () => (
      <>
        <BulletGrid
          items={[
            'Inject time',
            'Fix timezone',
            'Fix calendar',
            'Fix locale',
            'Test DST and boundary cases',
          ]}
        />
        <div className="code-grid code-grid-three">
          <CodeBlock
            title="Inject a clock"
            code={testingClockCode}
            caption="Stop binding tests to the actual current time."
          />
          <CodeBlock
            title="Use the clock"
            code={testingExpiryCode}
            caption="Pure logic becomes deterministic."
          />
          <CodeBlock
            title="Fix test context"
            code={testingStableCode}
            caption="Calendar, locale, and timezone should be explicit."
          />
        </div>
      </>
    ),
  },
  {
    id: 'fun-facts',
    section: '15',
    title: 'Calendars Are Engineered Compromises',
    references: [slideReferences.calendrical, slideReferences.iana],
    render: () => (
      <div className="stack-lg">
        <p className="body-copy">
          The Earth does not give us a neat integer API. Calendar systems add
          leap days, leap months, and rules to keep civil time aligned with
          seasons, lunar phases, religious observance, or administrative needs.
        </p>
        <BulletGrid
          items={[
            'Some days are 23 or 25 hours.',
            'Some local times happen twice.',
            'Some local times never happen.',
            'Some offsets are not whole hours.',
            'Timezone abbreviations are ambiguous.',
            'The same instant can be a different date elsewhere.',
          ]}
        />
      </div>
    ),
  },
  {
    id: 'leap-years',
    section: '15',
    title: 'Why Leap Years Exist',
    references: [slideReferences.calendar],
    render: () => (
      <div className="split-layout">
        <div className="section-headline">
          <h3>A solar year is not exactly 365 days.</h3>
          <p>
            Leap rules keep calendar dates near the seasons. Without
            correction, the same month would slowly drift through the solar
            year.
          </p>
        </div>
        <Bullets
          items={[
            'Gregorian: add February 29 in years divisible by 4, except most century years, unless divisible by 400.',
            'Persian / Solar Hijri: leap years keep Nowruz near the March equinox.',
            'Julian: leap every 4 years, which is simpler but drifts faster.',
            'Hebrew: adds leap months in a lunisolar cycle.',
            'Islamic Hijri: lunar calendar; months move through solar seasons.',
          ]}
        />
      </div>
    ),
  },
  {
    id: 'calendar-comparison',
    section: '15',
    title: 'Calendar Comparison',
    references: [slideReferences.calendar],
    render: () => (
      <ComparisonTable
        headers={['Using Persian calendar as baseline', 'Comparison']}
        rows={[
          ['Persian / Solar Hijri', 'Solar, equinox-aligned, highly accurate for seasonal alignment'],
          ['Gregorian', 'Solar, globally dominant civil/business calendar, less directly equinox-based'],
          ['Julian', 'Solar and simple, but drifts more against the seasons'],
          ['Islamic Hijri', 'Lunar, religiously important, intentionally moves through solar seasons'],
          ['Hebrew', 'Lunisolar, uses leap months to keep lunar months seasonally aligned'],
        ]}
      />
    ),
  },
  {
    id: 'leap-seconds',
    section: '15',
    title: 'Leap Seconds',
    references: [slideReferences.iana, slideReferences.ianaTheory],
    render: () => (
      <div className="stack-lg">
        <div className="section-headline">
          <h3>Sometimes clocks get a one-second correction.</h3>
          <p>
            Leap seconds are occasional adjustments to UTC that keep civil time
            close to Earth’s irregular rotation. They matter more to clocks,
            logging, ordering, and distributed systems than to ordinary calendar
            arithmetic.
          </p>
        </div>
        <Bullets
          items={[
            'Not every minute is guaranteed to have exactly 60 UTC seconds.',
            'Some systems step the clock; others smear the leap second over a time window.',
            'Many APIs hide leap seconds or model time as Unix-like elapsed seconds.',
            'For high-precision systems, document the clock source and leap-second behavior.',
          ]}
        />
      </div>
    ),
  },
  {
    id: 'closing',
    section: '16',
    title: 'Closing',
    references: [
      slideReferences.calendrical,
      slideReferences.ianaTheory,
      slideReferences.icu,
      slideReferences.timeDocs,
    ],
    render: () => (
      <div className="hero-layout closing-layout">
        <h2>Time is not just a value.</h2>
        <p className="hero-kicker">
          It is an instant interpreted through rules.
        </p>
        <p className="hero-body">
          Model the meaning first. Choose the type second. Format only at the
          boundary.
        </p>
      </div>
    ),
  },
  {
    id: 'references',
    section: 'Appendix',
    title: 'References',
    references: Object.values(slideReferences),
    render: () => (
      <div className="reference-page">
        {Object.values(slideReferences).map((reference) => (
          <a
            key={reference.href}
            className="reference-link-card"
            href={reference.href}
            target="_blank"
            rel="noreferrer"
          >
            <strong>{reference.label}</strong>
            <span>{reference.href}</span>
          </a>
        ))}
      </div>
    ),
  },
]
