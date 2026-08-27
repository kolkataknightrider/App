// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/app_menu_sheet.dart
// The ≡ menu — a real, fully working navigation + actions sheet.
// ════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/core/services/offline_sync_service.dart';
import 'package:partix/shared/widgets/glass.dart';

/// Opens the main menu as a frosted bottom sheet.
Future<void> showAppMenu(BuildContext context) {
  HapticFeedback.mediumImpact();
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const AppMenuSheet(),
  );
}

class AppMenuSheet extends ConsumerWidget {
  const AppMenuSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final unread = ref.watch(notificationProvider).unreadCount;

    final entries = <_MenuEntry>[
      const _MenuEntry(Icons.space_dashboard_rounded, AppStrings.dashboard,
          'Earnings overview', AppColors.brandPrimary, AppRoutes.dashboard),
      _MenuEntry(
          Icons.groups_2_rounded,
          AppStrings.myTeam,
          '${user?.totalTeamSize ?? 0} members',
          AppColors.success,
          AppRoutes.team),
      const _MenuEntry(Icons.insights_rounded, AppStrings.earnings,
          'Level-wise breakdown', AppColors.info, AppRoutes.earnings),
      const _MenuEntry(
          Icons.account_balance_wallet_rounded,
          AppStrings.withdraw,
          'Request payout',
          AppColors.brandAccent,
          AppRoutes.withdrawal),
      const _MenuEntry(Icons.receipt_long_rounded, AppStrings.withdrawalHistory,
          'Past payouts', AppColors.warning, AppRoutes.withdrawalHistory),
      _MenuEntry(
          Icons.notifications_rounded,
          AppStrings.notifications,
          unread > 0 ? '$unread unread' : 'All caught up',
          AppColors.rankVicePresident,
          AppRoutes.notificationsRoute),
      const _MenuEntry(Icons.person_rounded, AppStrings.profile,
          'Account & payments', AppColors.brandSecondary, AppRoutes.profile),
    ];

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF16162B).withOpacity(0.96),
                const Color(0xFF0B0B18).withOpacity(0.98),
              ],
            ),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.14)),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // grab handle
                  Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),

                  // ── Header card ──
                  GlassCard(
                    onTap: () {
                      Navigator.pop(context);
                      context.go(AppRoutes.profile);
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.brandGradient,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            (user?.fullName.isNotEmpty ?? false)
                                ? user!.fullName[0].toUpperCase()
                                : 'P',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.fullName ?? 'Partix Member',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary),
                              ),
                              Text(
                                user?.memberId ?? '—',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: AppColors.textSecondary),
                      ],
                    ),
                  ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.2),

                  const SizedBox(height: 14),

                  // ── Navigation entries ──
                  ...entries.asMap().entries.map((e) {
                    final i = e.key;
                    final m = e.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        radius: 18,
                        accent: m.color,
                        onTap: () {
                          Navigator.pop(context);
                          if (m.route == AppRoutes.notificationsRoute) {
                            context.push(m.route);
                          } else {
                            context.go(m.route);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: m.color.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(m.icon, color: m.color, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m.title,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary)),
                                  Text(m.subtitle,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                size: 13, color: AppColors.textTertiary),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: (60 * i).ms, duration: 260.ms)
                        .slideX(
                            begin: 0.12, end: 0, curve: Curves.easeOutCubic);
                  }),

                  const SizedBox(height: 6),

                  // ── Actions row ──
                  Row(
                    children: [
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.ios_share_rounded,
                          label: 'Invite',
                          color: AppColors.brandAccent,
                          onTap: () {
                            Navigator.pop(context);
                            Share.share(
                              'Join my PARTIX network! Referral code: '
                              '${user?.referralCode ?? ''} — build your team and '
                              'earn from 5 levels.',
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.chat_rounded,
                          label: 'Support',
                          color: AppColors.success,
                          onTap: () async {
                            Navigator.pop(context);
                            final uri = Uri.parse(
                                '${AppStrings.supportWhatsAppUrl}?text=${Uri.encodeComponent('Hi Partix support, my Member ID is ${user?.memberId ?? ''}')}');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.logout_rounded,
                          label: 'Logout',
                          color: AppColors.error,
                          onTap: () async {
                            final ok = await _confirmLogout(context);
                            if (ok != true) return;
                            await ref.read(authProvider).logout();
                            await OfflineSyncService.instance.clearAll();
                            if (context.mounted) Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 420.ms, duration: 300.ms),

                  const SizedBox(height: 12),
                  const Text(
                    '${AppStrings.appName} v${AppStrings.appVersion}',
                    style:
                        TextStyle(fontSize: 11, color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmLogout(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.darkBgTertiary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(AppStrings.logout),
          content: const Text(AppStrings.logoutConfirm),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Logout'),
            ),
          ],
        ),
      );
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.14),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

class _MenuEntry {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String route;
  const _MenuEntry(
      this.icon, this.title, this.subtitle, this.color, this.route);
}
