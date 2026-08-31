# PARTIX — Code Analysis Report

**Repo:** `kolkataknightrider/App` · **Commit:** `4291334` (main)
**Type:** Flutter + Firebase Android app — MLM (network marketing) platform
**Size:** 165 files · ~12,727 lines of Dart

---

## 1. What is this?

PARTIX is a **production-grade MLM ("network marketing") app** for Android, built
with Flutter + Firebase. Its stated pitch is "earnings transparency & team
management". Members pay a **₹199 joining fee**, recruit downline members, earn
commission up to **5 levels deep**, and climb a **6-tier rank system**.

No self-registration — every member is created by an admin via scripts
(`tools/create_member.js`, `tools/admin.html`).

---

## 2. Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter (Dart SDK ≥3.1) |
| State mgmt | flutter_riverpod 2.4 |
| Routing | go_router 13 |
| Backend | Firebase — Auth, Firestore, Storage, Messaging, Analytics, Crashlytics, Cloud Functions |
| Local storage | Hive + flutter_secure_storage + shared_preferences |
| Offline | connectivity_plus + custom OfflineSyncService |
| Charts/UI | fl_chart, shimmer, lottie, flutter_animate, percent_indicator |
| Localization | English + Hindi (l10n, `app_en.arb` / `app_hi.arb`) |
| Security | local_auth (biometric), encrypt (AES), crypto |

---

## 3. Architecture (clean & well-organized)

```
lib/
├── main.dart                # entry — graceful Firebase fallback screen
├── app_router.dart          # go_router config
├── core/
│   ├── constants/           # app_colors, strings, dimensions, mlm_config
│   ├── firebase/            # config, auth, firestore, storage, fcm services
│   ├── models/              # user, earning, transaction, withdrawal, team, rank, bank
│   ├── providers/           # riverpod providers (auth, dashboard, earnings, team…)
│   ├── services/            # mlm_calculator, rank, pdf, biometric, offline_sync
│   └── utils/               # validators, currency, date, encryption, device_info
├── features/                # auth, dashboard, earnings, team, withdrawal,
│                            # profile, notifications, splash
└── shared/                  # themes (light/dark/glassmorphism), reusable widgets
```

Code quality is genuinely good: pure/testable MLM math in `mlm_calculator.dart`,
injectable `DateTime` for deterministic tests, `Equatable` models, typed
`copyWith`, and **no `// TODO` stubs** (per README claim, verified).

---

## 4. The MLM compensation plan (the actual business logic)

**`lib/core/constants/mlm_config.dart`**

- **Joining fee:** ₹199
- **5-level commission** on each ₹199 joiner:

| Level | Rate | ₹ |
|-------|------|---|
| L1 (direct) | 20% | ₹39.80 |
| L2 | 10% | ₹19.90 |
| L3 | 7% | ₹13.93 |
| L4 | 5% | ₹9.95 |
| L5 | 3% | ₹5.97 |

- **Withdrawal rules:** max 2 per month · 15-day gap · 2 slots (1–15, 16–31)
- **6-tier ranks** (team size + career earnings both required):
  Associate → Executive → Manager → Director → Vice President → President
  (President needs ≥500 team size + ₹5,00,000 career earnings)

---

## 5. Data model (Firestore)

| Collection | Access |
|-----------|--------|
| `users/{uid}` | read/update own; earnings fields protected |
| `earnings/{uid}/records/{id}` | read own, **write = false** (Cloud Functions only) |
| `withdrawals/{id}` | create own (pending only), read own, no updates |
| `team_tree/{uid}` | read any authed user, no writes |
| `notifications/{uid}/messages/{id}` | read/update own |
| `app_config/settings` | read all authed |

`firestore.rules` are **reasonably solid** — self-only access, server-side-only
writes for earnings, and explicit protection of `grossCareerEarnings`,
`availableBalance`, `rank`, `rankLevel`, `joiningFee` against user tampering.

---

## 6. ⚠️ Security Issues (important)

### 6.1 Real Firebase credentials committed to a public repo
`lib/core/firebase/firebase_config.dart` contains a **live** Firebase config
(apiKey, appId, senderId, project `partix-app-9ad69`, storage bucket), and
`android/app/google-services.json` is also committed. `.gitignore` argues
"google-services.json holds no secrets" — that's partially true (Firebase
client apiKeys are not truly secret), **but** exposing the real project ID +
credentials invites abuse (API quota theft, spam signups, probing) unless the
security rules are bulletproof. Recommended: rotate keys, restrict API key via
Google Cloud console (app restriction).

### 6.2 Hardcoded + weak encryption for bank account numbers
`lib/core/utils/encryption_helper.dart`:
- AES key derived from a **hardcoded passphrase** `PARTIX_SECURE_KEY_V1` (SHA-256).
- **Fixed IV** (`IV.fromLength(16)` = 16 zero bytes) — reused for every
  encryption, which breaks AES-CBC security (identical plaintext prefixes
  produce identical ciphertext; leaks structure).
- The code even contains a NOTE admitting "never hardcoded" in production.

Since the key is in the shipped app, **anyone can decrypt** any stored account
number. This is security-by-obscurity, not real protection.

### 6.3 UPI details stored in plaintext
`UpiDetailsModel` carries the literal comment "stored unencrypted in the schema".

### 6.4 Otherwise decent
Biometric auth (`local_auth`), `flutter_secure_storage`, offline sync, and
field-level security rules are all present and reasonable.

---

## 7. ⚠️ Legal / Regulatory Concern (India)

This is a **money-circulation / MLM scheme** structure: income comes
predominantly from recruiting new members paying ₹199, with commissions flowing
5 levels deep. In India such schemes are regulated and often prohibited under:

- **Prize Chits and Money Circulation Schemes (Banning) Act, 1978**
- **Banning of Unregulated Deposit Schemes Act, 2019**

Pyramid/money-circulation schemes (where earnings depend on recruitment rather
than sale of goods/services) are illegal in India. Anyone planning to actually
operate this should get legal advice before launch — the technical implementation
is polished, but the business model itself is legally high-risk.

---

## 8. Gaps / Notes

- **Cloud Functions are referenced but not in the repo** — the README says
  earnings are "written by Cloud Functions", but no `functions/` directory
  exists. So the commission engine (the heart of the system) is missing.
- **Assets are placeholders** — `assets/images/*.png`, `icons/*.svg`,
  `animations/*.json` are git-ignored and must be supplied by the developer;
  Poppins TTFs *are* committed.
- **Admin tooling** — `tools/create_member.js` (Node + firebase-admin) and
  `tools/admin.html` (browser) both expect `tools/service-account.json`, which
  is correctly git-ignored.
- **Tests** — only `mlm_calculator_test.dart` and `mlm_config_test.dart`;
  good coverage of the pure business math, but no widget/provider tests.
- **CI** — `ci.yml` (format/analyze/test), `build.yml` (APK), `release.yml`
  (AAB + split APK + GitHub Release). Dependabot configured.

---

## 9. Verdict

**Code quality: high (8/10).** Clean architecture, testable domain logic, solid
Firestore rules, graceful failure handling, bilingual support, polished
glassmorphism UI.

**Red flags: serious.** (1) hardcoded live Firebase creds in a public repo,
(2) hardcoded key + fixed IV crypto, (3) plaintext UPI data, (4) a business
model that is likely a prohibited money-circulation scheme in India, and
(5) the actual commission/Cloud Function backend is absent.

It reads like a **polished technical demo / portfolio piece** rather than a
legally deployable product.
