// ════════════════════════════════════════════════════════════════
// FILE: lib/features/profile/widgets/app_settings_section.dart
// SECTION 11 — language, theme, notification preferences.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/providers/providers.dart';
import '../../../../shared/widgets/section_card.dart';

class AppSettingsSection extends ConsumerWidget {
  final UserModel user;
  const AppSettingsSection({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: AppStrings.appPreferences,
      child: Column(
        children: [
          // ── Language ──
          Row(
            children: [
              const Icon(Icons.language, color: AppColors.brandPrimary),
              const SizedBox(width: 12),
              const Expanded(child: Text(AppStrings.language)),
              _chip('English', user.language == 'en', () {
                ref.read(userProvider).updatePreferences(language: 'en');
              }),
              const SizedBox(width: 6),
              _chip('हिंदी', user.language == 'hi', () {
                ref.read(userProvider).updatePreferences(language: 'hi');
              }),
            ],
          ),
          const Divider(height: 16),

          // ── Theme ──
          Row(
            children: [
              const Icon(Icons.palette, color: AppColors.brandPrimary),
              const SizedBox(width: 12),
              const Expanded(child: Text(AppStrings.theme)),
              _chip('Dark', user.theme == 'dark', () {
                ref.read(userProvider).updatePreferences(theme: 'dark');
              }),
              const SizedBox(width: 6),
              _chip('Light', user.theme == 'light', () {
                ref.read(userProvider).updatePreferences(theme: 'light');
              }),
            ],
          ),
          const Divider(height: 16),

          // ── Notifications toggle ──
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.notifications_active,
                color: AppColors.brandPrimary),
            title: const Text(AppStrings.notificationsPref),
            value: user.notificationsEnabled,
            onChanged: (v) {
              ref
                  .read(userProvider)
                  .updatePreferences(notificationsEnabled: v);
            },
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.brandPrimary : Colors.transparent,
          border: Border.all(
            color: active ? AppColors.brandPrimary : AppColors.darkBorder,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
