# GenUI Shopping Assistant Demo

A Flutter demo app accompanying that showcases the potential of GenUI.

The app showcases a product/shopping assistant powered by **Firebase AI Logic** (Gemini) and **GenUI**, where the AI dynamically composes Flutter widget trees at runtime. No pre-coded UI branches required.

## Setup

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Configure Firebase

```bash
# Install FlutterFire CLI if needed
dart pub global activate flutterfire_cli

# Configure — this generates lib/firebase_options.dart
flutterfire configure
```

## GenUI version

This demo targets **GenUI v0.7.0** (alpha). Pin your versions and watch the changelog as the API may evolve before the stable release.
