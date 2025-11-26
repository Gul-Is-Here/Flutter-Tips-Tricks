<div align="center">

# Flutter Tips & Tricks – Stateless ⚡ Stateful

Interactive Flutter demo + neon-themed interview course with day-by-day study guides.

[Live guides](https://gul-is-here.github.io/Flutter-Tips-Tricks/) · [Full course hub](https://gul-is-here.github.io/Flutter-Tips-Tricks/course-index.html)

</div>

## Project overview

This repo serves two complementary learning experiences:

- **Flutter demo app** (`lib/main.dart`): split-screen experience that contrasts `StatelessWidget` vs `StatefulWidget`, complete with rebuild counters, console logs, and hot reload experiments.
- **Static learning hub**: a collection of HTML guides (`Day1–Day12`) and an 8-module interview course (`course-index.html`, `course-module*.html`) published through GitHub Pages.
- **Printable references**: Markdown + PDF workflow (`scripts/markdown_to_pdf.py`) for quickly exporting the HTML content into interview-ready cheat sheets.

## Repo map

```
├── lib/main.dart                # Flutter comparison app
├── index.html                   # Landing page with 12-day prep path
├── course-index.html            # 8-module deep-dive navigation grid
├── course-module1-8.html       # Individual module lessons
├── guides/day0X-*.html         # Bite-sized interview guides
├── scripts/markdown_to_pdf.py   # Markdown → PDF helper
├── test/widget_test.dart        # Widget tests (to be refreshed soon)
├── pubspec.yaml                 # Flutter dependencies (material + cupertino)
└── COURSE_COMPLETION_STRATEGY.md# Historical plan + status
```

## Running the Flutter demo locally

```bash
flutter pub get
flutter run
```

Open the “Force Rebuild” control in the app to watch how stateless and stateful widgets react differently. Use hot reload/restart to mirror the Day 4 guide.

### Tests

```bash
flutter test
```

(The bundled widget test still targets an older counter UI—update it if you rely on automated checks.)

## Viewing the course & guides

- **Live GitHub Pages:** https://gul-is-here.github.io/Flutter-Tips-Tricks/
- **Course hub:** https://gul-is-here.github.io/Flutter-Tips-Tricks/course-index.html
- **Local preview:** open `index.html` or any `course-module*.html` file directly in a browser; no build step required.

### Modules at a glance

| Module | Focus | Highlights |
| ------ | ----- | ---------- |
| 1 | Flutter Fundamentals | Stateful vs Stateless deep dive, Dart refreshers |
| 2 | UI & Layouts | Row/Column/Stack labs, scrollable widgets, Material + Cupertino |
| 3 | State Management | `setState`, InheritedWidget, Provider, Bloc, Riverpod tour |
| 4 | Routing & Navigation | Navigator 1.0/2.0, deep links, tab stacks |
| 5 | Advanced Concepts | Lifecycle observers, animation playbook, platform channels |
| 6 | Performance & Optimization | const constructors, keys, DevTools profiling |
| 7 | Testing | Unit, widget, and integration workflows with Mockito |
| 8 | Deployment & Release | Flavors, signing, CI/CD, crash monitoring |

Each module follows the same pedagogy: kid-friendly analogy → visual notes → code samples → comparison tables → interview Q&A.

### Day-by-day study path

The first six days live under `guides/`. Later days reuse the earlier HTML files:

- `guides/day01-stateless-vs-stateful.html`
- `guides/day02-const-vs-final.html`
- `guides/day03-build-context.html`
- `guides/day04-hot-reload-vs-restart.html`
- `guides/day05-main-vs-cross-axis.html`
- `future_vs_async(Day6).html`
- `Day7andDay8.html`
- `day9andday10.html`
- `Day11and12.html`

## Generating PDFs from Markdown

Use the helper script to convert markdown guides into a branded PDF (macOS + Arial Unicode recommended).

```bash
python scripts/markdown_to_pdf.py const_vs_final_explained.md const_vs_final_explained.pdf
```

The script strips emojis, adds branded cover pages, and uses the accent color `#00DE8E` automatically.

## Deployment

Static HTML is served via GitHub Pages (`main` branch → `/`), so any change to the HTML files is instantly deployable once pushed. The Flutter app itself is not deployed—run it locally or package it with `flutter build`.

---

Questions or ideas for new modules? Open an issue or drop a note—this repository is intentionally beginner-friendly and welcomes contributions.
