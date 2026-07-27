# Date & Time in Software Engineering

Website-based technical presentation about date and time modeling in software engineering, with a strong focus on Swift and Foundation.

## What The Talk Covers

This talk explains why date/time bugs usually come from confusing different concepts:

- instants, local dates, clock times, and formatted strings
- `Date`, `Calendar`, `DateComponents`, `TimeZone`, `Locale`, `DateFormatter`, and `Date.FormatStyle`
- duration arithmetic versus calendar arithmetic
- common wrong assumptions such as `Date` meaning year/month/day, timezone meaning offset, and `YYYY` meaning calendar year
- Calendar APIs for extracting components, scanning dates, calculating dates, intervals, comparisons, and DST edge cases
- formatting and parsing with ISO 8601, RFC 3339, ICU, CLDR, and localized display rules
- API contract design for instants, local dates, future local schedules, and business timezone rules
- testing strategies for date/time logic
- calendar weirdness, leap years, Persian calendar comparison, and leap seconds

## Run The Slides

Install dependencies:

```sh
npm install
```

Start the local development server:

```sh
npm run dev
```

Then open the URL printed by Vite, usually:

```text
http://localhost:5173
```

Build the production version:

```sh
npm run build
```

Preview the production build:

```sh
npm run preview
```

## Sample Code

Swift sample code lives in:

```text
DateAndTime.playground
```

Open it with Xcode:

```sh
open DateAndTime.playground
```

The playground contains separate pages for the presentation examples, including:

- calendar interpretation and component extraction
- exact duration versus calendar-day arithmetic
- Persian calendar `startOfDay(for:)` example
- DST and invalid local time examples
- timezone versus offset
- week-year versus calendar-year formatting
- Calendar scanning, matching policies, date intervals, and comparison APIs
- `Date.FormatStyle`, locale-aware formatting, ISO 8601 parsing, and stable `DateFormatter` parsing
- clock injection examples for deterministic date/time logic

Live-coding slides include an `Open Playground` button that points to this playground package.
