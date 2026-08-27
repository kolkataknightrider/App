// ════════════════════════════════════════════════════════════════
// FILE: lib/features/team/widgets/team_member_card.dart
// SECTION 8 — list-view member card.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/models/team_member_model.dart';
import 'package:partix/shared/widgets/status_badge.dart';

class TeamMemberCard extends StatelessWidget {
  final TeamMemberModel member;
  const TeamMemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final rankColor = AppColors.rankColor(member.rank);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: rankColor.withOpacity(0.4)),
      ),
      child: InkWell(
        onTap: () => context.go(AppRoutes.memberDetailPath(member.userId)),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: rankColor.withOpacity(0.2),
                  backgroundImage: member.profilePhotoUrl != null
                      ? NetworkImage(member.profilePhotoUrl!)
                      : null,
                  child: member.profilePhotoUrl == null
                      ? Icon(Icons.person, color: rankColor, size: 20)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.fullName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      Text(member.memberId,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                StatusBadge.rank(member.rank),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _Info('Team', '${member.totalDownline}'),
                const SizedBox(width: 18),
                _Info('Direct', '${member.directReferrals}'),
                const SizedBox(width: 18),
                _Info('Level', 'L${member.level}'),
                const Spacer(),
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;
  const _Info(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        Text(label,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
      ],
    );
  }
}
