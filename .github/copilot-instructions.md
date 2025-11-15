# Flutter Tips & Tricks - AI Agent Guide

## Project Overview

This is an **educational Flutter project** demonstrating core Flutter concepts through:
- **Interactive demo app** (`lib/main.dart`) - Live comparison of StatelessWidget vs StatefulWidget
- **HTML educational guides** (Day1-Day10) - Interview preparation materials with visual examples
- **PDF generation** (`scripts/markdown_to_pdf.py`) - Converts markdown guides to formatted PDFs

**Primary Goal**: Create beginner-friendly learning materials with extensive inline documentation and visual demonstrations.

## Key Architecture Patterns

### Demo App Structure (`lib/main.dart`)
The app is architected as a **side-by-side comparison** demonstrating widget lifecycle:

```
MyApp (StatelessWidget)
└── WidgetComparisonScreen (StatefulWidget)
    ├── Control Panel (forces rebuilds)
    ├── StatelessWidgetExample (left) - receives external data
    └── StatefulWidgetExample (right) - manages internal state
```

**Critical Implementation Details**:
- `StatelessWidgetExample` uses static variables (`_statelessBuildCount`, `_statelessInternalCounter`) to demonstrate rebuild behavior
- Parent state changes trigger StatelessWidget rebuilds via `externalCounter` parameter
- Each widget includes extensive visual feedback (build counts, timestamps, color-coded cards)
- Console logging (`print()` statements) tracks build/setState cycles for debugging

### Educational Content Pattern
All HTML guides follow this structure:
1. **Child-friendly analogy** (e.g., "Cookie Basket" for InheritedWidget)
2. **Visual examples** with ASCII art and styled boxes
3. **Code examples** with syntax highlighting
4. **Comparison tables** for interview prep
5. **Gradient-based modern design** with emoji indicators

## Development Workflows

### Running the Demo App
```bash
flutter run
# Hot reload to observe StatelessWidget rebuild behavior
# Use "Force Rebuild" button in app to trigger parent setState
```

### Testing
The test file (`test/widget_test.dart`) is outdated and doesn't match current app structure:
- Current app has NO counter increment button (design changed)
- Tests should be rewritten to verify StatelessWidget/StatefulWidget behavior
- Use `flutter test` to run tests

### Building Documentation
```bash
# Generate PDFs from markdown guides (macOS-specific fonts)
python scripts/markdown_to_pdf.py const_vs_final_explained.md output.pdf
```

**PDF Script Conventions**:
- Strips emojis for professional output
- Requires Unicode font (Arial Unicode.ttf on macOS)
- Auto-generates cover pages from H1 headings
- Uses accent color `#00DE8E` for branding

### GitHub Pages Deployment
The project publishes HTML guides to GitHub Pages via `.github/workflows/deploy-pages.yml`:
- `index.html` serves as navigation hub
- All Day guides (Day1-Day10) are linked from index
- No build step needed - static HTML deployment

## Flutter-Specific Conventions

### Widget Naming
- Demo widgets include verbose inline comments explaining lifecycle
- Use descriptive names that indicate widget type: `WidgetComparisonScreen`, `StatelessWidgetExample`

### State Management Demonstrations
- **StatefulWidget pattern**: State class prefixed with `_` and suffixed with `State`
- **setState() calls** always include console logs for educational transparency
- **Build method comments** explain when/why rebuild occurs

### Visual Design Patterns
- **Color coding**: Blue for Stateless, Red for Stateful, Purple for controls
- **Card widgets** wrap distinct functional areas with elevation for depth
- **AnimatedContainer** for smooth state transitions in StatefulWidget example
- **Responsive sizing**: Uses `Expanded`, `Flexible` for split-screen layout

## Code Style Guidelines

### Comments
Prioritize **pedagogical comments** over typical code documentation:
```dart
// This demonstrates that even StatelessWidget can be rebuilt
// when its parent widget rebuilds (like during hot reload)
```

### Widget Organization
Each major widget section includes ASCII dividers:
```dart
// ===============================================
// STATEFUL WIDGET EXAMPLE (RIGHT HALF)
// ===============================================
```

### Debug Output
Maintain console logging for educational visibility:
```dart
print('StatelessWidget build() called #$_statelessBuildCount at $timeString');
```

## Educational Content Guidelines

### Writing HTML Guides
- **Start with analogy**: Physical world metaphor before technical explanation
- **Use visual hierarchy**: Gradient headers for day separators, colored boxes for concepts
- **Include code blocks**: Dark theme with syntax-highlighted snippets
- **Add comparison tables**: For interview scenarios
- **Progressive disclosure**: Simple explanation → code → real-world usage

### Emoji Usage
HTML guides use emojis extensively for engagement:
- 🍪 = Data sharing (InheritedWidget)
- 🔑 = Widget identification (Keys)
- 🏠 = Architecture concepts
- ✅/❌ = Valid/invalid code examples

PDF generation strips these emojis automatically.

## File Organization

```
lib/main.dart                    # Single-file demo app (no lib structure)
test/widget_test.dart            # Needs updating to match current app
scripts/markdown_to_pdf.py       # Python-based PDF generator
*.html                           # Day 1-10 educational guides
index.html                       # Navigation hub for all guides
const_vs_final_explained.md      # Example markdown source
```

**No multi-file Flutter structure** - entire app is intentionally in single `main.dart` for educational simplicity.

## Common Tasks

### Adding New Educational Day
1. Create `dayXX.html` using existing day templates
2. Update `index.html` navigation grid with new card
3. Follow analogy → explanation → code → table structure
4. Optionally create `.md` version for PDF generation

### Modifying Demo Behavior
When changing widget behavior in `main.dart`:
- Update inline comments to explain new behavior
- Add console logs for state changes
- Update visual indicators (colors, icons) to match concept
- Test both hot reload and hot restart behavior

### Updating Tests
Current tests fail because app structure changed:
```dart
// Expected: Counter widget with increment button
// Actual: StatelessWidget vs StatefulWidget comparison screen
```

Rewrite tests to verify:
- Widget rebuild behavior
- State changes in StatefulWidget
- StatelessWidget parameter updates

## Dependencies

**Minimal dependency footprint**:
- `flutter/material.dart` - Material Design widgets
- `cupertino_icons` - iOS-style icons
- No state management libraries (demonstrates raw Flutter)
- No third-party UI libraries (educational focus on Flutter core)

Python script requires:
- `fpdf` - PDF generation library
- macOS system fonts for Unicode support
