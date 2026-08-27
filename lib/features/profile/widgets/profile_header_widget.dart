// ════════════════════════════════════════════════════════════════
// FILE: lib/features/profile/widgets/profile_header_widget.dart
// SECTION 11 — profile hero section.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/models/user_model.dart';
import 'package:partix/core/utils/currency_formatter.dart';
import 'package:partix/core/utils/date_formatter.dart';
import 'package:partix/shared/widgets/status_badge.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserModel user;
  final VoidCallback onPickPhoto;
  const ProfileHeaderWidget({
    super.key,
    required this.user,
    required this.onPickPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.brandPrimary.withOpacity(0.9),
            AppColors.brandAccent.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        children: [
          GestureDetector(
            onTap: onPickPhoto,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: AppDimensions.profilePhotoSize / 2,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  backgroundImage: user.profilePhotoUrl != null
                      ? NetworkImage(user.profilePhotoUrl!)
                      : null,
                  child: user.profilePhotoUrl == null
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 18, color: AppColors.brandPrimary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(user.fullName,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text(user.memberId, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          StatusBadge.rank(user.rank),
          const SizedBox(height: 6),
          Text(
            '${AppStrings.memberSince}: ${user.joiningDate != null ? DateFormatter.medium(user.joiningDate!) : '—'}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _stat('${user.totalTeamSize}', 'Team'),
              _stat('${user.directReferrals}', 'Direct'),
              _stat('${user.rankLevel}', 'Rank'),
              _stat(CurrencyFormatter.compact(user.grossCareerEarnings),
                  'Earned'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}
