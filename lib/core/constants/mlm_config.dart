// ════════════════════════════════════════════════════════════════
// FILE: lib/core/constants/mlm_config.dart
// COMPLETE MLM COMPENSATION PLAN FOR PARTIX
// ════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';

/// PARTIX MLM business rules: joining fee, 5-level commissions,
/// withdrawal limits, and the 6-tier rank system.
class MLMConfig {
  MLMConfig._();

  // ── JOINING FEE ───────────────────────────────────────────
  static const double joiningFee = 199.0;

  // ── 5-LEVEL COMMISSION STRUCTURE ──────────────────────────
  // Every time someone joins under your network (at any level),
  // YOU earn a percentage of their ₹199 joining fee.
  //
  //  YOU ──── earns 20% = ₹39.80 from every L1 joiner
  //    └─ L1 Member
  //         └─ L2 Member ──── YOU earn 10% = ₹19.90
  //              └─ L3 Member ── YOU earn 7% = ₹13.93
  //                   └─ L4 Member ─ YOU earn 5% = ₹9.95
  //                        └─ L5 Member YOU earn 3% = ₹5.97
  static const Map<int, double> commissionRates = {
    1: 0.20, // Level 1 — Direct Referral: 20%  → ₹39.80
    2: 0.10, // Level 2 — Indirect:        10%  → ₹19.90
    3: 0.07, // Level 3 — Deep Network:     7%  → ₹13.93
    4: 0.05, // Level 4 — Extended:         5%  → ₹9.95
    5: 0.03, // Level 5 — Foundation:       3%  → ₹5.97
  };

  /// Commission earned on the joining fee for a given MLM [level].
  static double calculateCommission(int level) {
    final rate = commissionRates[level] ?? 0.0;
    return joiningFee * rate;
  }

  /// Commission rate (0..1) for a given [level].
  static double commissionRateFor(int level) => commissionRates[level] ?? 0.0;

  // ── WITHDRAWAL RULES ──────────────────────────────────────
  static const int maxWithdrawalsPerMonth = 2;
  static const int withdrawalGapDays = 15;
  static const int slot1StartDay = 1; // 1st of month
  static const int slot1EndDay = 15; // 15th of month
  static const int slot2StartDay = 16; // 16th of month
  static const int slot2EndDay = 31; // End of month

  /// Whether a withdrawal is currently allowed.
  static bool isWithdrawalEligible({
    required DateTime lastWithdrawalDate,
    required int withdrawalCountThisMonth,
  }) {
    if (withdrawalCountThisMonth >= maxWithdrawalsPerMonth) return false;
    final daysSinceLast =
        DateTime.now().difference(lastWithdrawalDate).inDays;
    return daysSinceLast >= withdrawalGapDays;
  }

  /// The earliest date the next withdrawal becomes available.
  static DateTime nextEligibleWithdrawalDate(DateTime lastDate) {
    return lastDate.add(const Duration(days: withdrawalGapDays));
  }

  /// Which slot (1 or 2) the given [day] of month falls into.
  static int slotForDay(int day) =>
      day >= slot2StartDay ? 2 : 1;

  /// Human-readable slot label, e.g. "Jan 2025 - Slot 1".
  static String periodLabel(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final slot = slotForDay(date.day);
    return '${months[date.month - 1]} ${date.year} - Slot $slot';
  }

  // ── 6-TIER PROFESSIONAL RANK SYSTEM ───────────────────────
  //
  // Ranks are based on TOTAL TEAM SIZE (active members in downline)
  // and TOTAL CAREER EARNINGS. Both conditions must be met.
  static const List<Map<String, dynamic>> ranks = [
    {
      'name': 'Associate',
      'level': 1,
      'colorHex': '#4FC3F7',
      'icon': '🔵',
      'minTeamSize': 0,
      'maxTeamSize': 9,
      'minCareerEarnings': 0.0,
      'rankBonus': 0.0,
    },
    {
      'name': 'Executive',
      'level': 2,
      'colorHex': '#81C784',
      'icon': '🟢',
      'minTeamSize': 10,
      'maxTeamSize': 24,
      'minCareerEarnings': 5000.0,
      'rankBonus': 500.0,
    },
    {
      'name': 'Manager',
      'level': 3,
      'colorHex': '#FFD54F',
      'icon': '🟡',
      'minTeamSize': 25,
      'maxTeamSize': 74,
      'minCareerEarnings': 15000.0,
      'rankBonus': 1500.0,
    },
    {
      'name': 'Director',
      'level': 4,
      'colorHex': '#FFB74D',
      'icon': '🟠',
      'minTeamSize': 75,
      'maxTeamSize': 199,
      'minCareerEarnings': 50000.0,
      'rankBonus': 5000.0,
    },
    {
      'name': 'Vice President',
      'level': 5,
      'colorHex': '#EF9A9A',
      'icon': '🔴',
      'minTeamSize': 200,
      'maxTeamSize': 499,
      'minCareerEarnings': 150000.0,
      'rankBonus': 15000.0,
    },
    {
      'name': 'President',
      'level': 6,
      'colorHex': '#CE93D8',
      'icon': '💎',
      'minTeamSize': 500,
      'maxTeamSize': 999999,
      'minCareerEarnings': 500000.0,
      'rankBonus': 50000.0,
    },
  ];

  /// The highest rank the member currently qualifies for.
  static Map<String, dynamic> getCurrentRank({
    required int teamSize,
    required double careerEarnings,
  }) {
    Map<String, dynamic> currentRank = ranks[0];
    for (final rank in ranks) {
      if (teamSize >= rank['minTeamSize'] &&
          careerEarnings >= rank['minCareerEarnings']) {
        currentRank = rank;
      }
    }
    return currentRank;
  }

  /// The next rank after [currentRankLevel], or null if at the top.
  static Map<String, dynamic>? getNextRank(int currentRankLevel) {
    if (currentRankLevel >= ranks.length) return null;
    return ranks[currentRankLevel]; // next index
  }

  /// Only the name + level needed for lightweight UI lookups.
  static String rankNameForLevel(int level) {
    for (final r in ranks) {
      if (r['level'] == level) return r['name'] as String;
    }
    return ranks[0]['name'] as String;
  }
}
