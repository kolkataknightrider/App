// ════════════════════════════════════════════════════════════════
// FILE: lib/features/dashboard/widgets/rank_progress_card.dart
// SECTION 7 — current rank → next rank progress.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/models/rank_model.dart';
import '../../../../core/services/rank_service.dart';
import '../../../../core/utils/currency_formatter.dart';

class RankProgressCard extends StatelessWidget {
  final UserModel user;
  const RankProgressCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final current = RankService.currentRank(user);
    final next = RankService.nextRank(user);
    final teamProgress = next == null
        ? 1.0
        : (user.totalTeamSize / next.minTeamSize).clamp(0.0, 1.0);
    final earnProgress = next == null
        ? 1.0
        : (user.grossCareerEarnings / next.minCareerEarnings).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            current.color.withOpacity(0.25),
            AppColors.brandAccent.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: current.color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${current.icon} ${current.name}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const Spacer(),
              if (next != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: next.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('→ ${next.icon} ${next.name}',
                      style: TextStyle(
                          fontSize: 11,
                          color: next.color,
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _progressRow('Team Size', user.totalTeamSize,
              next?.minTeamSize ?? 0, teamProgress),
          const SizedBox(height: 10),
          _progressRow(
              'Earnings',
              user.grossCareerEarnings,
              next?.minCareerEarnings ?? 0,
              earnProgress,
              isCurrency: true),
          const SizedBox(height: 12),
          if (next != null)
            Text(
              RankService.nextRankRequirement(user),
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            )
          else
            const Text('You have achieved the highest rank! 🎉',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _progressRow(String label, num value, num target, double percent,
      {bool isCurrency = false}) {
    final valueStr = isCurrency
        ? CurrencyFormatter.format(value.toDouble())
        : value.toString();
    final targetStr = isCurrency
        ? CurrencyFormatter.format(target.toDouble())
        : target.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            Text('$valueStr / $targetStr',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        LinearPercentIndicator(
          percent: percent,
          lineHeight: 8,
          backgroundColor: Colors.white.withOpacity(0.12),
          progressColor: AppColors.brandPrimary,
          barRadius: const Radius.circular(10),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
