// ════════════════════════════════════════════════════════════════
// FILE: lib/features/dashboard/widgets/quick_actions_row.dart
// SECTION 7 — Withdraw / Team / Earnings / Invite quick actions.
// Glass tiles with gradient icon wells and springy tap feedback.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/models/user_model.dart';
import 'package:partix/shared/widgets/glass.dart';

class QuickActionsRow extends StatelessWidget {
  final UserModel user;
  const QuickActionsRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final items = <_Action>[
      _Action(
        Icons.account_balance_wallet_rounded,
        AppStrings.quickWithdraw,
        () => context.go(AppRoutes.withdrawal),
        AppColors.brandPrimary,
      ),
      _Action(
        Icons.groups_2_rounded,
        AppStrings.quickTeam,
        () => context.go(AppRoutes.team),
        AppColors.success,
      ),
      _Action(
        Icons.insights_rounded,
        AppStrings.quickEarnings,
        () => context.go(AppRoutes.earnings),
        AppColors.info,
      ),
      _Action(
        Icons.ios_share_rounded,
        AppStrings.quickInvite,
        () => Share.share(
          'Join my PARTIX network! Use my referral code: ${user.referralCode} '
          'and start earning. Download PARTIX now.',
        ),
        AppColors.brandAccent,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < items.length; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TapScale(
                onTap: items[i].onTap,
                child: GlassCard(
                  radius: 20,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  accent: items[i].color,
                  interactive: false,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              items[i].color.withOpacity(0.85),
                              items[i].color.withOpacity(0.35),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: items[i].color.withOpacity(0.40),
                              blurRadius: 14,
                              spreadRadius: -3,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child:
                            Icon(items[i].icon, color: Colors.white, size: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        items[i].label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: (80 * i).ms, duration: 350.ms)
                  .slideY(begin: 0.4, end: 0, curve: Curves.easeOutBack),
            ),
          ),
      ],
    );
  }
}

class _Action {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _Action(this.icon, this.label, this.onTap, this.color);
}
