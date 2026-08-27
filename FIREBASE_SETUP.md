# PARTIX — Firebase Live Setup Status

Project: **partix-app-9ad69** · Android package: **`com.partix`** · App ID: `1:314306763234:android:46164f2f41a478db1a01bb`

## ✅ Ab jo ho chuka hai (code side — kuch karne ki zarurat nahi)

| Item | Status |
|---|---|
| `lib/core/firebase/firebase_config.dart` me real credentials | ✅ Done |
| `android/app/google-services.json` (real, committed) | ✅ Done |
| Android `applicationId` + `namespace` = `com.partix` (Firebase se match) | ✅ Fixed |
| `MainActivity.kt` package rename | ✅ Done |
| `[core/duplicate-app]` crash fix (native default app reuse) | ✅ Done |
| "Firebase Not Configured" screen ab exact error bhi dikhata hai | ✅ Done |
| Flutter CI (format + analyze + tests) | ✅ Green |
| Android release APK build | ✅ Green |
| Email/Password Auth provider Firebase me enabled | ✅ Verified live |

## ⛔ Jo Firebase Console me AAPKO karna hai (2 minute)

### 1. Firestore Database banao — **ye abhi missing hai**
Live check ka result:

```
Cloud Firestore API has not been used in project partix-app-9ad69 before or it is disabled.
```

Console → **Build → Firestore Database → Create database**
- Location: `asia-south1` (Mumbai) ya `asia-southeast1`
- Mode: **Production mode** (rules niche step 2 me)

### 2. Security rules deploy karo
Repo me `firestore.rules` aur `storage.rules` already hain.
Console → Firestore → **Rules** tab → `firestore.rules` ka content paste → Publish.
Same Storage ke liye `storage.rules` se.

### 3. Firebase Storage enable karo
Console → **Build → Storage → Get started** (profile photo upload ke liye).

### 4. Pehla member (admin) account banao
App me **self-registration nahi hai** — har member admin banata hai. Iske liye script repo me hai:

```bash
# Console → Project Settings → Service accounts → Generate new private key
# usko save karo: tools/service-account.json   (ye git-ignored hai)

npm init -y && npm install firebase-admin
node tools/create_member.js PTX-2025-00001 "Ramesh Kumar" +919876543210 Partix@123
```

Ye ek saath banata hai:
- Firebase Auth user → `ptx-2025-00001@partix.com` / `Partix@123`
- `users/{uid}` document (poore UserModel schema ke saath)
- `team_tree/{uid}` node
- `app_config/settings` (joining fee ₹199, commission rates, withdrawal rules)

Downline member banane ke liye sponsor ka Member ID last me do:

```bash
node tools/create_member.js PTX-2025-00002 "Priya Sharma" +919812345678 Priya@123 PTX-2025-00001
```

### 5. App me login
Naya APK install karo (package badla hai — purana `com.partix.partix` wala alag app hai, use uninstall kar sakte ho).

```
Member ID : PTX-2025-00001
Password  : Partix@123
```

## 🔎 Agar phir bhi error screen aaye
Ab wo screen niche **asli error text** dikhati hai. Common cases:

| Error text | Matlab / Fix |
|---|---|
| `PERMISSION_DENIED` / `Cloud Firestore API has not been used` | Step 1 — Firestore database create nahi hua |
| `[core/duplicate-app]` | Fix ho chuka hai; purana APK chala rahe ho |
| `API key not valid` | `google-services.json` purana/dummy — repo wala use karo |
| Login pe "Account Deactivated" | `users/{uid}.isActive` ya `joiningFeePaid` false hai |
