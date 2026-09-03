# 日常集 · Life Workbench

> An all-in-one life-logging app: expense & finance tracking / habit & health / weight-loss & fitness / schedule planning / shopping list / books-movies-music collection.
> Fully local-first, works offline, small package size, fast startup, with a cloud-sync-ready architecture.

---

## What is this

DailyHub consolidates the six most common types of daily records into a single app, so you don't have to install a pile of scattered standalone tools.
It's ready to use the moment you open it — just jot things down. The UI is clean and restrained, and every chart is hand-drawn with no third-party charting library.

**Current version: v1.0.0 (versionCode 1)** · Platform: Android (iOS code lives in the same repo; awaits a macOS build environment)

## Features

| Module | Features |
|--------|----------|
| **Today Overview** | A pinned "To handle today" section: overdue items marked in red, due-date reminders, and yesterday's unfinished items auto-rolled over |
| **Expense & Finance** | Income/expense records, category management, monthly switching, category filtering, spending-structure pie chart (hand-drawn with CustomPaint) |
| **Habit & Health** | Custom habit add/remove, supporting three check-in modes — toggle / count / numeric value — plus a 30-day check-in heatmap and streak counter |
| **Weight Loss & Fitness** | Weight / body-fat records, line chart with 7-day moving average, BMI, and goal progress |
| **Schedule Planning** | Schedule item management, organized by date, with status transitions |
| **Shopping List** | Items, quantities, estimated prices, and "purchased" markers |
| **Books · Movies · Music** | Categories for books / films / music, with status tracking, star ratings, short reviews, and a dual cover-wall + list view |

## Tech Stack

- **Flutter 3.44** (Dart 3.12) — one codebase running on both Android and iOS
- **State management**: Flutter's built-in `ChangeNotifier` + `InheritedWidget`, with no third-party state library (smaller package size, lower maintenance cost)
- **Local storage**: `shared_preferences` (KV persistence, key prefix `wb_`)
- **Charts**: Pure `CustomPaint` hand-drawn (pie / line / heatmap), no external charting library
- **Internationalization**: Official gen_l10n (`flutter_localizations` + ARB); switch between **Simplified Chinese / English** with one tap in the Settings panel at the top-right of the home screen — the choice takes effect instantly and persists
- **Dependencies**: `shared_preferences` + `intl` + the SDK-bundled `flutter_localizations` — a minimal dependency surface

## Project Structure

```
lib/
├── main.dart                 # Entry point: LocalStore → LocalRepository → AppState
├── theme.dart                # Global theme (warm off-white background + dark-green primary)
├── models/                   # Data models for the six modules (pure Dart, hand-written toJson/fromJson)
│   ├── money_record.dart     # Expense tracking
│   ├── habit.dart            # Habits (iconCodePoint + const icon table for guaranteed tree-shaking)
│   ├── fitness_record.dart   # Weight loss
│   ├── plan_item.dart        # Schedule
│   ├── shopping_item.dart    # Shopping list
│   └── media_item.dart       # Books / movies / music
├── data/
│   └── local_store.dart      # Local KV storage wrapper
├── repository/               # ★ Data-access abstraction layer
│   ├── data_repository.dart  # Abstract interface
│   └── local_repository.dart # Local implementation
├── state/
│   └── app_state.dart        # Global state + locale + CRUD for each module
├── l10n/                     # Internationalization
│   ├── app_zh.arb            # Simplified Chinese source (template)
│   ├── app_en.arb            # English source
│   ├── data_labels.dart      # Bilingual data-label mapping (translates categories/types at display time, storage values unchanged)
│   └── generated/            # gen_l10n-generated AppLocalizations (committed to the repo)
├── screens/                  # Seven screens (Today Overview + six modules)
└── widgets/
    └── common.dart           # SoftCard / SectionTitle / EmptyState / fmtMoney
```

## Architecture Highlights

- **Repository abstraction layer**: Business logic depends only on the `DataRepository` interface and does not care whether data lives locally or in the cloud. The current implementation is `LocalRepository`; to add cloud sync later, you only need a new `CloudRepository` implementing the same interface, and business code can switch over with zero changes.
- **Data models aligned with the web version**: The JSON field structure matches the online version of the WorkBuddy web library, paving the way for future web-side data integration.
- **Icon-font tree-shaking**: Models store `int iconCodePoint` (rather than a runtime `IconData`), shrinking MaterialIcons from 1.6MB to 8KB (99.5%).

## Build & Packaging

```bash
# Domestic mirrors (recommended; add to your shell or environment variables)
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
# Gradle cache directory: on Windows you must use an absolute path with a drive letter
# Writing /d/.gradle is resolved as "current drive + /d/.gradle",
# so running inside a project on drive E actually creates E:\d\.gradle instead of the D: cache directory.
export GRADLE_USER_HOME="D:/.gradle"
export ANDROID_HOME="D:/Android/Sdk"
export JAVA_HOME="D:/Android/Android Studio/jbr"

# Run on a physical device / emulator
flutter run

# Debug build (debug only, large size)
flutter build apk --debug

# Release universal build (signed)
flutter build apk --release

# Release split per-ABI (separate per CPU architecture, smaller size)
flutter build apk --release --split-per-abi

# iOS (requires macOS + Xcode)
flutter build ios
```

**Output location**: `build/app/outputs/flutter-apk/`

### Official Signing (Important)

- Release builds are signed with the official keystore (`signingConfigs.release` is enabled in `android/app/build.gradle.kts`).
- **Full details of the keystore and password config file are in the local file `android/SIGNING-INFO.local.md`** (this file is not committed and is not distributed with the repo; it stays only on the machine owner's local disk).
- Key-related files (`.jks` / `key.properties`, etc.) are all added to `.gitignore` and will not enter version control.

> ⚠️ **Be sure to back up the keystore file (see the local note above).**
> If the keystore is lost, you will be unable to ship further updates to the published app (a signature mismatch prevents overwriting the installed build).

### Historical Builds

- v1.0.0 universal build: `日常集生活工作台_v1.0.0.apk` (~48MB, copied to desktop)
- v1.0.0 split builds: arm64-v8a 17.0MB / armeabi-v7a 14.5MB / x86_64 18.4MB

## Testing

```bash
flutter test test/models_test.dart   # Data-model JSON (de)serialization round-trip test
flutter analyze                      # Static analysis (currently no errors/warnings)
```

## Data & Privacy

- 100% of data is stored locally on the device (`shared_preferences`); nothing is uploaded to any server, and everything works fully offline.
- Device migration: currently via reinstall + manual re-entry; automatic migration will be possible once cloud sync is added.

## Roadmap

1. **Cloud sync**: Add a `CloudRepository` to connect with the online data tables of the library, enabling multi-device sync
2. **iOS build**: Integrate a macOS build environment and ship a TestFlight build
3. **Data export**: Full data export to JSON for backup / restore
4. **Desktop widgets**: Quick-entry for expense tracking and a habit-check-in desktop widget
