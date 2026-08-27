// ════════════════════════════════════════════════════════════════
// FILE: lib/features/dashboard/widgets/greeting_header.dart
// SECTION 7 — Greeting header with name, member id, rank, team.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/models/user_model.dart';
import 'package:partix/shared/widgets/status_badge.dart';

class GreetingHeader extends StatelessWidget {
  final UserModel user;
  final String greeting;
  const GreetingHeader({super.key, required this.user, required this.greeting});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.memberId,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            StatusBadge.rank(user.rank),
            const SizedBox(height: 6),
            Text(
              'Team: ${user.totalTeamSize} members',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
