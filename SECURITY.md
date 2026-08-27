# 🔐 Security Policy

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## 🐛 Reporting a Vulnerability

If you discover a security vulnerability in PARTIX, **please do not open a
public issue.**

Instead, report it privately:

- Email: **security@partix.example**
- Or use GitHub's [private vulnerability reporting](
  https://docs.github.com/en/code-security/security-advisories/guidelines-for-reporting-and-disclosing-vulnerabilities)

We will acknowledge your report within **72 hours** and aim to provide a
remediation timeline within **7 days** for critical issues.

## 🔑 Handling Credentials

- Never commit `google-services.json`, `GoogleService-Info.plist`, API keys,
  or service-account files.
- Firebase credentials belong in `lib/core/firebase/firebase_config.dart`
  **only for your local build** — use environment-specific config in CI via
  encrypted secrets (`GOOGLE_SERVICES_JSON`).
- Bank account numbers are encrypted at rest (see
  `core/utils/encryption_helper.dart`) and displayed masked (last 4 digits).

## 🧩 Hardening Checklist (for deployments)

- Firestore + Storage security rules must be applied (see `firestore.rules`,
  `storage.rules`) before going live.
- Enforce email-verified auth and server-side commission logic via Cloud
  Functions — never trust client-computed earnings.
- Enable Firebase App Check for production builds.
