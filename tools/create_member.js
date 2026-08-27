/**
 * ════════════════════════════════════════════════════════════════
 * PARTIX — Admin helper: create a member (Auth user + Firestore doc)
 * ════════════════════════════════════════════════════════════════
 * The app has NO self-registration: every member is issued by admin.
 * This script creates both halves of a member account.
 *
 * SETUP
 *   1. Firebase Console → Project Settings → Service accounts
 *        → "Generate new private key" → save as tools/service-account.json
 *      (NEVER commit that file — it is git-ignored.)
 *   2. npm init -y && npm install firebase-admin
 *
 * USAGE
 *   node tools/create_member.js PTX-2025-00001 "Ramesh Kumar" +919876543210 <password> [sponsorMemberId]
 *
 * The login e-mail is derived exactly like the app does:
 *   PTX-2025-00001  →  ptx-2025-00001@partix.com
 */

const admin = require('firebase-admin');
const serviceAccount = require('./service-account.json');

admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
const db = admin.firestore();

const [memberId, fullName, phone, password, sponsorId] = process.argv.slice(2);

if (!memberId || !fullName || !phone || !password) {
  console.error(
    'Usage: node tools/create_member.js <PTX-YYYY-NNNNN> <"Full Name"> <phone> <password> [sponsorMemberId]'
  );
  process.exit(1);
}
if (!/^PTX-\d{4}-\d{5}$/.test(memberId)) {
  console.error('Member ID must look like PTX-2025-00001');
  process.exit(1);
}
if (password.length < 8) {
  console.error('Password must be at least 8 characters (app enforces this).');
  process.exit(1);
}

const email = `${memberId.toLowerCase()}@partix.com`;

(async () => {
  // ── 1. Auth user ────────────────────────────────────────────
  let user;
  try {
    user = await admin.auth().createUser({ email, password, displayName: fullName });
    console.log(`✅ Auth user created: ${email} (uid ${user.uid})`);
  } catch (e) {
    if (e.code === 'auth/email-already-exists') {
      user = await admin.auth().getUserByEmail(email);
      await admin.auth().updateUser(user.uid, { password });
      console.log(`ℹ️  Auth user already existed — password reset (uid ${user.uid})`);
    } else {
      throw e;
    }
  }

  // ── 2. Resolve sponsor (optional) ───────────────────────────
  let sponsorUid = '';
  if (sponsorId) {
    const snap = await db.collection('users').where('memberId', '==', sponsorId).limit(1).get();
    if (snap.empty) {
      console.warn(`⚠️  Sponsor ${sponsorId} not found — creating member without upline.`);
    } else {
      sponsorUid = snap.docs[0].id;
    }
  }

  const now = admin.firestore.FieldValue.serverTimestamp();

  // ── 3. Firestore member document (matches UserModel) ────────
  await db.collection('users').doc(user.uid).set(
    {
      uid: user.uid,
      memberId,
      fullName,
      phone,
      email,
      profilePhotoUrl: '',
      address: '',
      joiningDate: now,
      joiningFee: 199,
      joiningFeePaid: true,
      isActive: true,

      sponsorId: sponsorId || '',
      sponsorUid,
      level: sponsorUid ? 1 : 0,
      position: 'child',
      referralCode: 'PTX' + memberId.slice(-5),

      rank: 'Associate',
      rankLevel: 1,
      rankPoints: 0,
      totalTeamSize: 0,
      directReferrals: 0,
      activeDirectReferrals: 0,
      thisMonthNewJoinings: 0,

      todayEarnings: 0,
      weeklyEarnings: 0,
      monthlyEarnings: 0,
      lastMonthEarnings: 0,
      yearlyEarnings: 0,
      grossCareerEarnings: 0,
      totalTeamEarnings: 0,
      availableBalance: 0,

      withdrawalCountThisMonth: 0,

      language: 'en',
      theme: 'dark',
      biometricEnabled: false,
      notificationsEnabled: true,
      fcmToken: '',

      createdAt: now,
      lastLogin: now,
      appVersion: '1.0.0',
    },
    { merge: true }
  );
  console.log(`✅ Firestore users/${user.uid} written`);

  // ── 4. Team-tree node ───────────────────────────────────────
  await db.collection('team_tree').doc(user.uid).set(
    {
      userId: user.uid,
      memberId,
      fullName,
      profilePhotoUrl: '',
      rank: 'Associate',
      rankLevel: 1,
      isActive: true,
      sponsorId: sponsorId || '',
      level1Children: [],
      level2Members: [],
      level3Members: [],
      level4Members: [],
      level5Members: [],
      totalDownline: 0,
    },
    { merge: true }
  );

  // Attach to sponsor's direct children.
  if (sponsorUid) {
    await db.collection('team_tree').doc(sponsorUid).set(
      { level1Children: admin.firestore.FieldValue.arrayUnion(user.uid) },
      { merge: true }
    );
    await db.collection('users').doc(sponsorUid).set(
      {
        directReferrals: admin.firestore.FieldValue.increment(1),
        activeDirectReferrals: admin.firestore.FieldValue.increment(1),
        totalTeamSize: admin.firestore.FieldValue.increment(1),
        thisMonthNewJoinings: admin.firestore.FieldValue.increment(1),
      },
      { merge: true }
    );
  }

  // ── 5. Global app config (created once) ─────────────────────
  await db.collection('app_config').doc('settings').set(
    {
      joiningFee: 199,
      minWithdrawalAmount: 1,
      maxWithdrawalPerMonth: 2,
      withdrawalGapDays: 15,
      withdrawalSlot1StartDay: 1,
      withdrawalSlot1EndDay: 15,
      withdrawalSlot2StartDay: 16,
      withdrawalSlot2EndDay: 31,
      maintenanceMode: false,
      maintenanceMessage: '',
      appVersion: '1.0.0',
      forceUpdateVersion: '1.0.0',
      commissionRates: { level1: 0.2, level2: 0.1, level3: 0.07, level4: 0.05, level5: 0.03 },
    },
    { merge: true }
  );

  console.log('\n🎉 Done. Login in the app with:');
  console.log(`   Member ID : ${memberId}`);
  console.log(`   Password  : ${password}`);
  process.exit(0);
})().catch((e) => {
  console.error('❌ Failed:', e);
  process.exit(1);
});
