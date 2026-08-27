// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/partix_bottom_nav.dart
// 5-tab bottom navigation (Home, Team, Earnings, Wallet, Profile).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as badges;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';

class PartixBottomNav extends StatelessWidget {
  final int currentIndex;
  final int walletBadge;
  final int homeBadge;

  const PartixBottomNav({
    super.key,
    required this.currentIndex,
    this.walletBadge = 0,
    this.homeBadge = 0,
  });

  static const _routes = [
    AppRoutes.dashboard,
    AppRoutes.team,
    AppRoutes.earnings,
    AppRoutes.withdrawal,
    AppRoutes.profile,
  ];

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(Icons.home_outlined, Icons.home, AppStrings.dashboard, 0),
      _NavItem(Icons.group_outlined, Icons.group, AppStrings.myTeam, 1),
      _NavItem(Icons.bar_chart_outlined, Icons.bar_chart, AppStrings.earnings, 2),
      _NavItem(Icons.account_balance_wallet_outlined,
          Icons.account_balance_wallet, AppStrings.wallet, 3),
      _NavItem(Icons.person_outline, Icons.person, AppStrings.profile, 4),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) {
              final active = currentIndex == item.index;
              Widget icon = Icon(
                active ? item.filled : item.outlined,
                color: active
                    ? AppColors.brandPrimary
                    : AppColors.textTertiary,
                size: 26,
              );
              if (item.index == 3 && walletBadge > 0) {
                icon = badges.Badge(
                  badgeContent: Text('$walletBadge',
                      style: const TextStyle(color: Colors.white, fontSize: 9)),
                  child: icon,
                );
              }
              if (item.index == 0 && homeBadge > 0) {
                icon = badges.Badge(
                  badgeContent: Text('$homeBadge',
                      style: const TextStyle(color: Colors.white, fontSize: 9)),
                  child: icon,
                );
              }
              return GestureDetector(
                onTap: () => context.go(_routes[item.index]),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.brandPrimary.withOpacity(0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon,
                      if (active) ...[
                        const SizedBox(height: 4),
                        Text(item.label,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.brandPrimary,
                            )),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData outlined;
  final IconData filled;
  final String label;
  final int index;
  const _NavItem(this.outlined, this.filled, this.label, this.index);
}
