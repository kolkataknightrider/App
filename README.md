# PARTIX — MLM Earnings & Team Management App

A complete, production-grade **Flutter + Firebase** Android application for the
PARTIX network-marketing platform. Built around **transparency**, real-time
earnings visibility, and structured team-growth management.

> This repository was generated from the PARTIX master development prompt. Every
> screen, model, service and provider is fully implemented — there are **no
> `// TODO` stubs**. The only thing missing is your Firebase project credentials
> and the binary assets (fonts/images/Lottie), which cannot be committed here.

## 📊 Status

![Flutter CI](https://github.com/<org>/partix/actions/workflows/ci.yml/badge.svg)
![Android Build](https://github.com/<org>/partix/actions/workflows/build.yml/badge.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.22%2B-6C63FF)
![Platform](https://img.shields.io/badge/Platform-Android-brightgreen)

> Replace `<org>` with your GitHub org/user in the badges above.

---

## 🔄 GitHub Workflows

This repo is set up as a standard GitHub project under `.github/`:

| Workflow | File | Triggers | What it does |
|----------|------|----------|--------------|
| **Flutter CI** | `workflows/ci.yml` | push to `main`/`develop`, PRs | `dart format` check, `flutter analyze --fatal-*`, `flutter test` |
| **Android Build** | `workflows/build.yml` | push to `main`, manual | scaffolds native project if needed, injects a placeholder `google-services.json`, builds a release APK |
| **Release** | `workflows/release.yml` | `v*.*.*` tag | builds AAB + split APK, publishes a GitHub Release (needs `GOOGLE_SERVICES_JSON` secret) |

Governance: `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `LICENSE`
(MIT), Dependabot config, issue templates (bug/feature) and a PR template.

Branch model: `main` (protected) ← `develop` ← `feature/*` / `fix/*`.

---

## 🚀 Quick Start

```bash
# 0. (First time only) generate the native Android/iOS project.
#    This preserves lib/ and assets/ and only adds android/, ios/, etc.
flutter create --org com.partix --project-name partix .

# 1. Install dependencies
flutter pub get

# 2. Add your Firebase credentials
#    → edit lib/core/firebase/firebase_config.dart (replace YOUR_* values)
#    → drop google-services.json into android/app/

# 3. Add the Poppins font TTFs (see Assets section below)
# 4. Run
flutter run
```

> If Firebase isn't configured yet, the app launches a friendly
> **"Firebase Not Configured"** screen instead of crashing.

---

## 🔐 Firebase Setup (the ONLY manual step required)

Open **`lib/core/firebase/firebase_config.dart`** and replace these 6 values:

```
YOUR_ANDROID_API_KEY
YOUR_ANDROID_APP_ID
YOUR_MESSAGING_SENDER_ID
YOUR_PROJECT_ID
YOUR_STORAGE_BUCKET
YOUR_DATABASE_URL
```

Then:
1. Download `google-services.json` from the Firebase Console.
2. Place it in **`android/app/google-services.json`**.
3. In the Firebase Console enable: **Email/Password Auth**, **Cloud Firestore**,
   **Storage**, **Cloud Messaging**, **Crashlytics**, **Analytics**.

Security rules are provided in **`firestore.rules`** and **`storage.rules`** —
paste them into the Firebase Console (Rules tabs).

### Firestore Indexes (recommended)
Create a composite index for `withdrawals`:
- Fields: `userId` (Asc), `requestedAt` (Desc) — collection scope.

---

## 🗄️ Data Model

| Collection | Doc | Purpose |
|------------|-----|---------|
| `users` | `{uid}` | Full member profile, MLM structure, cached earnings, payment details |
| `earnings` | `{uid}/records/{id}` | Per-transaction commission records (written by Cloud Functions) |
| `withdrawals` | `{auto}` | Withdrawal requests (user-creatable, admin-updatable) |
| `team_tree` | `{uid}` | Pre-computed downline structure for fast tree/list rendering |
| `notifications` | `{uid}/messages/{id}` | FCM notification history |
| `app_config` | `settings` | Joining fee, commission rates, withdrawal rules |

The full schema and all field names live in
`lib/core/firebase/firestore_collections.dart`.

---

## 💼 MLM Business Logic

All compensation rules are centralized in **`lib/core/constants/mlm_config.dart`**:

- **Joining fee:** ₹199
- **5-level commission:** L1 20% · L2 10% · L3 7% · L4 5% · L5 3%
- **Withdrawals:** max 2/month, 15-day gap, slot system (1–15 / 16–31)
- **6-tier ranks:** Associate → Executive → Manager → Director → VP → President
  (promotion by team size **and** career earnings)

Helper engines: `mlm_calculator.dart`, `rank_service.dart`.

---

## 🧱 Architecture

```
lib/
├── main.dart                 # entry + Firebase init + theme + router
├── app_router.dart           # GoRouter (auth redirect + bottom-nav shell)
├── core/
│   ├── firebase/             # config, auth, firestore, storage, fcm services
│   ├── constants/            # colors, strings, routes, assets, mlm_config
│   ├── models/               # 8 fully-typed data models
│   ├── providers/            # Riverpod state (auth, user, dashboard, …)
│   ├── services/             # calculator, rank, biometric, pdf, offline sync
│   └── utils/                # currency, date, validators, encryption, device
├── features/
│   ├── auth/  dashboard/  team/  earnings/  withdrawal/  profile/  notifications/
├── shared/
│   ├── themes/               # dark + light + aggregator
│   └── widgets/              # app bar, bottom nav, buttons, states, shell
└── l10n/                     # English + Hindi (.arb)
```

State management uses **Riverpod** (`ChangeNotifierProvider`). Navigation uses
**GoRouter** with a `StatefulShellRoute.indexedStack` for the 5-tab bottom nav
and a `refreshListenable` for auth redirects.

---

## 📴 Offline-First

`OfflineSyncService` (Hive) caches users, earnings, team, withdrawals,
notifications and config. `connectivity_provider` drives the orange offline
banner. Firestore offline persistence + pull-to-refresh keep data fresh.

---

## 🌐 Localization

English + Hindi via `.arb` files in `lib/l10n/`. The app reads the user's
preferred language (`user.language`) for language selection in Settings; the
standard `flutter_localizations` delegates are wired in `main.dart`.

---

## 🎨 Assets You Must Add

The `pubspec.yaml` references these (declared so the app is ready to build):

- **Fonts** → `assets/fonts/Poppins-*.ttf` (Regular/Medium/SemiBold/Bold) —  
  download from <https://fonts.google.com/specimen/Poppins> (OFL).
- **Images** → `assets/images/partix_logo.png`, `partix_logo_white.png`,
  `onboarding_bg.png`.
- **Icons (SVG)** → `assets/icons/ic_home.svg`, `ic_team.svg`, `ic_earnings.svg`,
  `ic_wallet.svg`, `ic_profile.svg`.
- **Animations (Lottie)** → `assets/animations/{success_tick,loading_coins,
  empty_state,rank_up}.json`.

> The `assets/*/README.md` files explain exactly what goes where.

---

## ✅ Feature Checklist

- [x] Firebase config + init + security rules
- [x] Email/Password auth + biometric + lockout + secure storage
- [x] 8-metric real-time dashboard + trend chart + rank progress
- [x] Team tree (collapsible) + list (filter/sort/search) + member detail
- [x] Earnings detail (period/type/level/pagination) + PDF export
- [x] Withdrawal eligibility engine + request + history timeline
- [x] Profile (photo, info, UPI, encrypted bank, security, settings)
- [x] Push notifications (FCM) + in-app notification center
- [x] Offline-first Hive caching + connectivity banner
- [x] English/Hindi localization
- [x] Dark + Light themes, full design system

---

## 📦 Build

```bash
flutter build apk --release        # Android APK
flutter build appbundle --release  # Play Store AAB
```

Target APK keeps under ~25 MB by using `const` constructors, Hive for sync local
reads, cursor pagination, and compressed image uploads.
