// ════════════════════════════════════════════════════════════════
// FILE: lib/core/services/rank_service.dart
// Rank promotion logic & progress computation.
// ════════════════════════════════════════════════════════════════

import '../constants/mlm_config.dart';
import '../models/rank_model.dart';
import '../models/user_model.dart';

/// Determines current rank + progress toward the next rank.
class RankService {
  RankService._();

  /// The rank the user currently holds.
  static RankModel currentRank(UserModel user) {
    final map = MLMConfig.getCurrentRank(
      teamSize: user.totalTeamSize,
      careerEarnings: user.grossCareerEarnings,
    );
    return RankModel.fromMap(map);
  }

  /// The next rank, or null if already President.
  static RankModel? nextRank(UserModel user) {
    final current = MLMConfig.getCurrentRank(
      teamSize: user.totalTeamSize,
      careerEarnings: user.grossCareerEarnings,
    );
    final nextMap = MLMConfig.getNextRank(current['level'] as int - 1);
    if (nextMap == null) return null;
    return RankModel.fromMap(nextMap);
  }

  /// 0..100 progress toward the next rank (max of team-size and
  /// earnings constraints).
  static double progressPercent(UserModel user) {
    final next = nextRank(user);
    if (next == null) return 100.0;
    final teamProgress =
        next.minTeamSize == 0 ? 1.0 : user.totalTeamSize / next.minTeamSize;
    final earnProgress = next.minCareerEarnings == 0
        ? 1.0
        : user.grossCareerEarnings / next.minCareerEarnings;
    final p = (teamProgress < earnProgress ? teamProgress : earnProgress)
        .clamp(0.0, 1.0);
    return p * 100;
  }

  /// Human-readable gap to the next rank.
  static String nextRankRequirement(UserModel user) {
    final next = nextRank(user);
    if (next == null) return 'You have achieved the highest rank!';
    final needMembers = (next.minTeamSize - user.totalTeamSize)
        .clamp(0, next.minTeamSize);
    final needEarn = (next.minCareerEarnings - user.grossCareerEarnings)
        .clamp(0.0, next.minCareerEarnings);
    final parts = <String>[];
    if (needMembers > 0) parts.add('$needMembers more members');
    if (needEarn > 0) {
      parts.add('₹${needEarn.toStringAsFixed(0)} earnings');
    }
    return 'You need ${parts.join(' & ')} to reach ${next.name} rank!';
  }

  /// Whether the user qualifies for [target] rank.
  static bool qualifies(UserModel user, RankModel target) {
    return user.totalTeamSize >= target.minTeamSize &&
        user.grossCareerEarnings >= target.minCareerEarnings;
  }
}
