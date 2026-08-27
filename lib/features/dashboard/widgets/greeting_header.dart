// ════════════════════════════════════════════════════════════════
// FILE: lib/features/dashboard/widgets/greeting_header.dart
// Glass hero header: greeting, member id, rank chip and live
// team/balance strip.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/models/user_model.dart';
import 'package:partix/core/utils/currency_formatter.dart';
import 'package:partix/shared/widgets/glass.dart';

class GreetingHeader extends StatelessWidget {
  final UserModel user;
  final String greeting;
  const GreetingHeader({super.key, required this.user, required this.greeting});

  @override
  Widget build(BuildContext context) {
    final rankColor = AppColors.rankColor(user.rank);

    return GlassCard(
      radius: 26,
      padding: const EdgeInsets.all(18),
      accent: rankColor,
      overlay: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          rankColor.withOpacity(0.20),
          AppColors.brandPrimary.withOpacity(0.10),
          Colors.white.withOpacity(0.03),
        ],
      ),
      onTap: () => context.go(AppRoutes.profile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.badge_outlined,
                            size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 5),
                        Text(
                          user.memberId,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // rank chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [rankColor, rankColor.withOpacity(0.62)],
                  ),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: rankColor.withOpacity(0.45),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                      spreadRadius: -3,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium_rounded,
                        size: 13, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      user.rank,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
                  duration: 2400.ms, color: Colors.white.withOpacity(0.55)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Stat(
                icon: Icons.groups_2_rounded,
                label: 'Team',
                value: '${user.totalTeamSize}',
                color: AppColors.success,
              ),
              const _Divider(),
              _Stat(
                icon: Icons.hub_rounded,
                label: 'Direct',
                value: '${user.directReferrals}',
                color: AppColors.info,
              ),
              const _Divider(),
              _Stat(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Balance',
                value: CurrencyFormatter.formatCompact(user.availableBalance),
                color: AppColors.brandAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
                fontSize: 10, color: AppColors.textSecondary, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 26,
        color: Colors.white.withOpacity(0.10),
      );
}
