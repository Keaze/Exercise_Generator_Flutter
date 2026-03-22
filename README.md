# Exercises Generator

A Flutter app for teachers that transforms text through configurable operations — useful for generating reading and spelling exercises from existing material.

Available in **English** and **German**. Runs on Windows, Android, Linux, macOS, and iOS.

## Features

| Transformation | Description |
|---|---|
| Shuffle words | Randomise word order |
| Scramble letters | Shuffle letters within each word |
| Mirror each word | Reverse every word individually (`Hallo` → `ollaH`) |
| Mirror entire text | Reverse the full string |
| Remove spaces | Strip all spaces |
| Uppercase / lowercase | Change case of the entire text |
| Replace letters | Substitute chosen letters with symbols (e.g. vowels → `@#$%`) |

Transformations are applied in a fixed, deterministic pipeline. Stochastic steps (shuffle, scramble, replace with multiple symbols) use a seeded random so the result is stable — use the re-roll button to get a new variation.

Settings and the theme preference (system / light / dark) persist across sessions.

## Screenshots

<!-- Add screenshots here -->

## Getting started

**Prerequisites:** Flutter SDK (stable channel), Dart ≥ 3.11.3

```sh
flutter pub get
flutter run
```

## Running tests

```sh
flutter test
```

## Building

**Android APK**

```sh
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Windows**

```sh
flutter build windows --release
# Output: build/windows/x64/runner/Release/
```

## Release

Releases are created via the **Release** GitHub Actions workflow (manual trigger). It runs the test suite, builds the Android APK and Windows package in parallel, and publishes a GitHub Release with both artifacts attached.

See [`.github/workflows/release.yml`](.github/workflows/release.yml).
