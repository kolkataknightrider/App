// ════════════════════════════════════════════════════════════════
// FILE: lib/core/constants/app_strings.dart
// All hardcoded English strings (Hindi lives in l10n/app_hi.arb).
// For runtime bilingual text use the ARB + AppLocalizations instead.
// ════════════════════════════════════════════════════════════════

class AppStrings {
  AppStrings._();

  // ── GENERAL ───────────────────────────────────────────────
  static const String appName = 'Partix';
  static const String tagline = 'Build. Earn. Grow.';
  static const String appVersion = '1.0.0';

  // ── AUTH ─────────────────────────────────────────────────
  static const String loginTitle = 'Welcome to Partix';
  static const String memberIdLabel = 'Member ID';
  static const String memberIdHint = 'e.g. PTX-2024-00001';
  static const String passwordLabel = 'Password';
  static const String signInButton = 'Sign In to Partix';
  static const String biometricButton = 'Login with Fingerprint';
  static const String adminCredentialsNote =
      'Credentials are issued by Partix Admin only';
  static const String accountDeactivated =
      'Your account has been deactivated. Contact Partix Admin.';
  static const String joiningFeeNotPaid =
      'Joining fee not paid. Please complete your payment.';
  static const String invalidCredentials =
      'Invalid Member ID or Password.';
  static const String tooManyAttempts =
      'Too many failed attempts. Try again in 15 minutes.';
  static const String lockoutRemaining = 'Locked out. Try again in {minutes} min';

  // ── NAVIGATION ───────────────────────────────────────────
  static const String dashboard = 'Dashboard';
  static const String myTeam = 'My Team';
  static const String earnings = 'Earnings';
  static const String wallet = 'Wallet';
  static const String profile = 'Profile';
  static const String notifications = 'Notifications';

  // ── DASHBOARD ────────────────────────────────────────────
  static const String todayEarnings = "Today's Earnings";
  static const String weeklyEarnings = 'Weekly Earnings';
  static const String monthlyEarnings = 'Monthly Earnings';
  static const String lastMonthEarnings = 'Last Month';
  static const String yearlyEarnings = 'Yearly Earnings';
  static const String grossEarnings = 'Gross Career Earnings';
  static const String teamEarnings = 'Total Team Earnings';
  static const String availableBalance = 'Available Balance';
  static const String grossCareerEarnings = 'Gross Career Earnings';
  static const String pendingWithdrawal =
      '{count} Withdrawal Pending — ₹{amount}';
  static const String checkStatus = 'Check Status';
  static const String recentActivity = 'Recent Earnings';
  static const String viewAll = 'View All';
  static const String quickWithdraw = 'Withdraw';
  static const String quickTeam = 'My Team';
  static const String quickEarnings = 'Earnings';
  static const String quickInvite = 'Invite';
  static const String rankProgress = 'Rank Progress';

  // ── TEAM ─────────────────────────────────────────────────
  static const String treeView = 'Tree View';
  static const String listView = 'List View';
  static const String totalTeam = 'Total Team';
  static const String activeMembers = 'Active Members';
  static const String directReferrals = 'Direct L1';
  static const String newThisMonth = 'New This Month';
  static const String searchHint = 'Search by name or Member ID';

  // ── EARNINGS ─────────────────────────────────────────────
  static const String totalEarned = 'Total Earned';
  static const String earningsByType = 'Earnings by Type';
  static const String levelBreakdown = 'Level Breakdown';
  static const String transactions = 'Transactions';
  static const String downloadPdf = 'Download PDF Report';
  static const String copySummary = 'Copy Summary';

  // ── WITHDRAWAL ────────────────────────────────────────────
  static const String requestWithdrawal = 'Request Withdrawal';
  static const String withdrawalHistory = 'Withdrawal History';
  static const String selectPaymentMethod = 'Select Payment Method';
  static const String upiTransfer = 'UPI Transfer';
  static const String bankTransfer = 'Bank Transfer';
  static const String enterAmount = 'Enter Amount';
  static const String quickSelect = 'Quick Select';
  static const String confirmWithdrawal = 'Confirm Withdrawal?';
  static const String cancelRequest = 'Cancel Request';
  static const String downloadReceipt = 'Download Receipt';
  static const String retryWithdrawal = 'Retry Withdrawal';
  static const String withdrawalEligible =
      'You can withdraw now. {count} of 2 slots used this month.';
  static const String withdrawalLimitReached =
      'You have reached your 2 withdrawal limit for this month.';
  static const String withdrawalTooSoon =
      'Your next withdrawal is available in {days} days.';
  static const String nextWindow =
      'Next window opens on {date}.';
  static const String eligibleFrom = 'Eligible from: {date}';
  static const String max = 'MAX';
  static const String upiRecommended = 'Recommended — Faster';

  // ── PROFILE ──────────────────────────────────────────────
  static const String personalInformation = 'Personal Information';
  static const String paymentDetails = 'Payment Details';
  static const String upiAccount = 'UPI Account';
  static const String bankAccount = 'Bank Account';
  static const String referralCode = 'Your Referral Code';
  static const String security = 'Security';
  static const String changePassword = 'Change Password';
  static const String biometricLogin = 'Biometric Login';
  static const String activeSessions = 'Active Sessions';
  static const String appPreferences = 'App Preferences';
  static const String language = 'Language';
  static const String theme = 'Theme';
  static const String notificationsPref = 'Notifications';
  static const String support = 'Support';
  static const String whatsappSupport = 'WhatsApp Support';
  static const String emailSupport = 'Email Support';
  static const String terms = 'Terms & Conditions';
  static const String privacy = 'Privacy Policy';
  static const String logout = 'Logout from Partix';
  static const String logoutConfirm = 'Are you sure you want to logout?';
  static const String copy = 'Copy';
  static const String shareReferral = 'Share Referral Link';
  static const String memberSince = 'Member since';

  // ── STATUS ───────────────────────────────────────────────
  static const String pending = 'Pending';
  static const String processing = 'Processing';
  static const String completed = 'Completed';
  static const String rejected = 'Rejected';
  static const String verified = 'Verified';
  static const String active = 'Active';
  static const String inactive = 'Inactive';

  // ── OFFLINE / COMMON ─────────────────────────────────────
  static const String offlineBanner =
      "You're offline. Showing last synced data.";
  static const String lastUpdated = 'Last updated: {time}';
  static const String retryNow = 'Retry Now';
  static const String retry = 'Retry';
  static const String noData = 'No data available';
  static const String somethingWentWrong = 'Something went wrong.';
  static const String loading = 'Loading...';

  // ── RANKS ────────────────────────────────────────────────
  static const String rankAssociate = 'Associate';
  static const String rankExecutive = 'Executive';
  static const String rankManager = 'Manager';
  static const String rankDirector = 'Director';
  static const String rankVicePresident = 'Vice President';
  static const String rankPresident = 'President';

  // ── NOTIFICATION TYPES ───────────────────────────────────
  static const String notifEarning = 'earning';
  static const String notifWithdrawal = 'withdrawal';
  static const String notifRankUp = 'rank_up';
  static const String notifNewMember = 'new_member';
}
