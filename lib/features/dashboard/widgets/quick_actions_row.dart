// ════════════════════════════════════════════════════════════════
// FILE: lib/features/dashboard/widgets/quick_actions_row.dart
// SECTION 7 — Withdraw / Team / Earnings / Invite quick actions.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/models/user_model.dart';

class QuickActionsRow extends StatelessWidget {
  final UserModel user;
  const QuickActionsRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Action(Icons.account_balance_wallet, AppStrings.quickWithdraw, () {
        context.go(AppRoutes.withdrawal);
      }, AppColors.brandPrimary),
      _Action(Icons.group, AppStrings.quickTeam, () {
        context.go(AppRoutes.team);
      }, AppColors.success),
      _Action(Icons.bar_chart, AppStrings.quickEarnings, () {
        context.go(AppRoutes.earnings);
      }, AppColors.info),
      _Action(Icons.share, AppStrings.quickInvite, () {
        Share.share(
          'Join my PARTIX network! Use my referral code: ${user.referralCode} '
          'and start earning. Download PARTIX now.',
        );
      }, AppColors.brandAccent),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items
          .map((a) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: a.onTap,
                    borderRadius: BorderRadius.circular(14),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: a.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(a.icon, color: a.color, size: 24),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          a.label,
                          style: const TextStyle(fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
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
