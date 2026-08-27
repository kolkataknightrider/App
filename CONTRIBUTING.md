# 🤝 Contributing to PARTIX

Thanks for your interest in improving PARTIX! This guide covers how to
get set up and the workflow we follow.

## 🧰 Prerequisites

- **Flutter 3.22+** (stable channel)
- **Dart 3.4+**
- A Firebase project (for runtime; see README setup)
- An editor with Flutter/Dart analysis (VS Code or Android Studio)

## 🚀 Local setup

```bash
git clone https://github.com/<org>/partix.git
cd partix
flutter pub get

# 1. Add Firebase credentials in lib/core/firebase/firebase_config.dart
# 2. Drop android/app/google-services.json (from Firebase Console)
# 3. Add Poppins TTFs to assets/fonts/ (see assets/fonts/README.md)
# 4. flutter run
```

## 🌿 Branch & workflow

We follow a simple **trunk-based** flow:

| Branch      | Purpose                                  |
|-------------|------------------------------------------|
| `main`      | Production-ready, protected branch       |
| `develop`   | Integration branch for active work       |
| `feature/*` | New features (e.g. `feature/kyc-flow`)   |
| `fix/*`     | Bug fixes (e.g. `fix/withdrawal-crash`)  |
| `release/*` | Release preparation                      |

1. Create a branch from `develop`: `git checkout -b feature/my-feature`.
2. Make small, focused commits with clear messages.
3. Ensure quality gates pass locally:
   ```bash
   dart format lib test
   flutter analyze
   flutter test
   ```
4. Open a **Pull Request** against `develop` using the PR template.
5. At least one maintainer review is required before merge.

## 📏 Code standards

- Follow the existing **SOLID** structure under `lib/core`, `lib/features`,
  `lib/shared`.
- Use **Riverpod** providers for state and **GoRouter** for navigation.
- Keep models plain `equatable`/`json_serializable`-style with `fromJson`/
  `toJson`.
- Never commit secrets or real `google-services.json` — use placeholders.
- UI must respect the PARTIX design system (dark/light themes, Poppins).

## 🧪 Tests

- Unit tests live in `test/`.
- Add a test for any new business logic in `core/services` or `core/constants`.
- Run with `flutter test`.

## 📦 Releases

- Tag releases `vX.Y.Z`; the **Release** workflow builds AAB + APK and
  publishes a GitHub Release (requires the `GOOGLE_SERVICES_JSON` secret).
- Only maintainers trigger releases.

## 💬 Questions?

Open a **Discussion** or an issue with the `question` label. Welcome aboard! 🎉
