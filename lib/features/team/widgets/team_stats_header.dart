// ════════════════════════════════════════════════════════════════
// FILE: lib/features/team/widgets/team_stats_header.dart
// SECTION 8 — Total / Active / Direct / New stat cards.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/providers/providers.dart';

class TeamStatsHeader extends ConsumerWidget {
  const TeamStatsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamProvider);
    final stats = team.stats;
    final items = [
      _Stat(AppStrings.totalTeam, '${stats['total'] ?? 0}', Icons.groups,
          AppColors.brandPrimary),
      _Stat(AppStrings.activeMembers, '${stats['active'] ?? 0}',
          Icons.verified_user, AppColors.success),
      _Stat(AppStrings.directReferrals, '${stats['direct'] ?? 0}',
          Icons.person_add, AppColors.info),
      _Stat(AppStrings.newThisMonth, '+${stats['new'] ?? 0}',
          Icons.new_releases, AppColors.warning),
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.85,
      children: items
          .map((s) => Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(s.icon, color: s.color, size: 22),
                    const SizedBox(height: 6),
                    Text(s.value,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins')),
                    const SizedBox(height: 2),
                    Text(s.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 9, color: AppColors.textSecondary)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _Stat {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _Stat(this.label, this.value, this.icon, this.color);
}
