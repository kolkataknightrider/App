// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/partix_bottom_nav.dart
// Floating CLAY tab bar — chunky clay surface, sliding gradient
// pill, icon bounce, haptics and live badges.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/constants/clay_palette.dart';
import 'package:partix/shared/widgets/clay.dart';

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

  static const _items = [
    _NavItem(Icons.space_dashboard_outlined, Icons.space_dashboard_rounded,
        AppStrings.dashboard, 0),
    _NavItem(
        Icons.groups_2_outlined, Icons.groups_2_rounded, AppStrings.myTeam, 1),
    _NavItem(Icons.insights_outlined, Icons.insights_rounded,
        AppStrings.earnings, 2),
    _NavItem(Icons.account_balance_wallet_outlined,
        Icons.account_balance_wallet_rounded, AppStrings.wallet, 3),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded,
        AppStrings.profile, 4),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(14, 0, 14, bottomInset > 0 ? 10 : 14),
      child: ClayContainer(
        radius: 28,
        elevation: 1.3,
        height: 68,
        child: LayoutBuilder(
          builder: (context, c) {
            final slot = c.maxWidth / _items.length;
            return Stack(
              children: [
                // ── Sliding gradient pill ──
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 380),
                  curve: Curves.easeOutBack,
                  left: slot * currentIndex + (slot - 58) / 2,
                  top: 7,
                  child: Container(
                    width: 58,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: ClayPalette.brandClayGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: ClayPalette.clayIndigo.withOpacity(0.55),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Tabs ──
                Row(
                  children: _items.map((item) {
                    final active = currentIndex == item.index;
                    final badge = item.index == 3
                        ? walletBadge
                        : (item.index == 0 ? homeBadge : 0);
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (active) return;
                          HapticFeedback.selectionClick();
                          context.go(_routes[item.index]);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                AnimatedScale(
                                  scale: active ? 1.14 : 1,
                                  duration: const Duration(milliseconds: 320),
                                  curve: Curves.easeOutBack,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 220),
                                    child: Icon(
                                      active ? item.filled : item.outlined,
                                      key: ValueKey(active),
                                      size: 23,
                                      color: active
                                          ? Colors.white
                                          : ClayColors.textDim(context),
                                    ),
                                  ),
                                ),
                                if (badge > 0)
                                  Positioned(
                                    right: -7,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.error,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            color: ClayColors.surface(context),
                                            width: 1.4),
                                      ),
                                      child: Text(
                                        badge > 9 ? '9+' : '$badge',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOut,
                              child: active
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        item.label,
                                        style: const TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(width: 1),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
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
