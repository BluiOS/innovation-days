# TODO

## Done

- Read and followed `INSTRUCTIONS.md`, `PRESENTATION_STRUCTURE.md`, and `REQUIREMENTS.md`.
- Built the presentation as a Vite + React + TypeScript website.
- Added slide-by-slide navigation with keyboard support for `ArrowLeft` and `ArrowRight`.
- Implemented a responsive single-slide presentation layout.
- Added a dark theme by default and a light/dark toggle.
- Added copy buttons for all Swift live-coding code blocks.
- Covered the required presentation sections, including:
  - title
  - date/time difficulty
  - mental model
  - Foundation primitives
  - primitive relationships
  - calendar arithmetic
  - common bugs
  - calendrical fallacies
  - timezone internals
  - calendar internals
  - formatting and parsing
  - ICU/CLDR
  - `davedelong/time`
  - API/storage design
  - testing
  - fun facts
  - dos and don’ts
  - closing
- Added per-slide references and a final references page.
- Verified the app builds successfully with `npm run build`.
- Generated `package-lock.json`.
- Revised `PRESENTATION_STRUCTURE.md` so sections can span multiple slides.
- Expanded the presentation content for timezone data, calendars, formatting standards, ICU/CLDR/tzdb, API contracts, and calendar facts.
- Merged the final dos and don'ts into the API contracts section.
- Moved previous/next navigation and theme switching into the top bar.
- Replaced the text theme switch with an icon button.
- Moved slide progress to a compact top progress bar.
- Added syntax highlighting for Swift, JSON, and text code blocks.
- Updated desktop slide sizing so the slide frame fills the browser height when possible.
- Fixed long reference URLs so they wrap inside their boxes.

## Not Done

- No presenter notes were added, intentionally, per the requirements.
- No extra slide animations or presenter mode were added.
- The `davedelong/time` section does not demonstrate unverified package APIs; it is intentionally limited to a docs-guided walkthrough setup.
