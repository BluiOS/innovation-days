Act as a senior iOS engineer, technical educator, and frontend presentation builder.

Create a complete technical knowledge-sharing presentation as a website using common web tools and JavaScript/TypeScript.

Topic:
Date and Time in Software Engineering, especially in Swift.

Audience:
Mostly iOS developers, with some backend engineers.

Tone:
Technical, practical, clear, slightly fun. Emojis are allowed, but keep them tasteful.

Output:
A website-style presentation, not a PowerPoint.
Use JavaScript or TypeScript.
Prefer a common modern stack such as:
- Vite + React + TypeScript
- or Next.js + TypeScript
- or plain HTML/CSS/TypeScript if simpler

The presentation should be easy to run locally with:
npm install
npm run dev

Important workflow:
1. First gather and organize the content.
2. Then design the website/presentation structure.
3. Then generate the actual website files.
4. Use references in the slides.
5. Keep slides visually clean: not too much text.
6. Slides should be self-contained enough to understand without the speaker, but still leave room for the presenter to explain verbally.
7. Do not include long speaker notes.

Files:
- PRESENTATION_STRUCTURE.md: contains the structure and basic contents that the presentation is built around.
- REQUIREMENTS.md: Technical requirements and presentation requirements that should be followed.

Primary references to include:
- Your Calendrical Fallacy Is:
  https://yourcalendricalfallacyis.com/
- davedelong/time GitHub repo:
  https://github.com/davedelong/time
- davedelong/time documentation on Swift Package Index:
  https://swiftpackageindex.com/davedelong/time/documentation/time
- Fucking Format Style:
  https://fuckingformatstyle.com/
- Date styles:
  https://fuckingformatstyle.com/date-styles/
- Apple Date documentation:
  https://developer.apple.com/documentation/foundation/date
- Apple Calendar documentation:
  https://developer.apple.com/documentation/foundation/calendar
- Apple DateFormatter documentation:
  https://developer.apple.com/documentation/foundation/dateformatter
- Apple Date.FormatStyle documentation:
  https://developer.apple.com/documentation/foundation/date/formatstyle
- IANA Time Zone Database:
  https://www.iana.org/time-zones
- IANA tzdb theory:
  https://data.iana.org/time-zones/tzdb/theory.html
- Unicode ICU date/time formatting:
  https://unicode-org.github.io/icu/userguide/format_parse/datetime/
- Unicode CLDR date/time patterns:
  https://cldr.unicode.org/translation/date-time/date-time-patterns

Core thesis:
Most date/time bugs happen because developers confuse:
- instants
- local dates
- calendar rules
- timezone rules
- durations
- calendar periods
- locale formatting
- API contracts

The presentation should repeatedly reinforce:
Date is not a calendar date.
Timezone is not just an offset.
UTC solves instants, not every date/time problem.
Formatting is localization, not simple string conversion.
Calendar arithmetic is different from duration arithmetic.

