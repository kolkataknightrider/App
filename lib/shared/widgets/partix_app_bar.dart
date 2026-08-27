// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/partix_app_bar.dart
// Frosted app bar: working ≡ menu, pulsing notification bell with
// live badge, and a tappable avatar that opens the profile.
// ════════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/shared/widgets/app_menu_sheet.dart';
import 'package:partix/shared/widgets/glass.dart';

class PartixAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showMenu;
  final bool showNotifications;
  final bool showAvatar;
  final String? avatarUrl;
  final int notificationCount;
  final VoidCallback? onMenuTap;

  /// Show a back arrow instead of the ≡ menu.
  final bool showBack;

  const PartixAppBar({
    super.key,
    this.title = AppStrings.appName,
    this.showMenu = true,
    this.showNotifications = true,
    this.showAvatar = true,
    this.avatarUrl,
    this.notificationCount = 0,
    this.onMenuTap,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.06),
                Colors.white.withOpacity(0.02),
              ],
            ),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.07)),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: kToolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    // ── Menu / back ──
                    if (showBack)
                      _CircleIcon(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.of(context).maybePop(),
                      )
                    else if (showMenu)
                      _CircleIcon(
                        icon: Icons.menu_rounded,
                        onTap: onMenuTap ?? () => showAppMenu(context),
                      ),

                    const SizedBox(width: 8),

                    // ── Wordmark ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.brandPrimary.withOpacity(0.45),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                            spreadRadius: -3,
                          ),
                        ],
                      ),
                      child: const Text(
                        'PARTIX',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: -0.15, end: 0),

                    const Spacer(),

                    // ── Notifications ──
                    if (showNotifications)
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _CircleIcon(
                            icon: Icons.notifications_none_rounded,
                            onTap: () =>
                                context.push(AppRoutes.notificationsRoute),
                          ),
                          if (notificationCount > 0)
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.error.withOpacity(0.6),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  notificationCount > 9
                                      ? '9+'
                                      : '$notificationCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .scaleXY(
                                    end: 1.18,
                                    duration: 900.ms,
                                    curve: Curves.easeInOut),
                        ],
                      ),

                    // ── Avatar → profile ──
                    if (showAvatar)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 6, right: AppDimensions.sm),
                        child: TapScale(
                          onTap: () => context.go(AppRoutes.profile),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.brandGradient,
                            ),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.darkBgTertiary,
                              backgroundImage:
                                  (avatarUrl != null && avatarUrl!.isNotEmpty)
                                      ? CachedNetworkImageProvider(avatarUrl!)
                                      : null,
                              child: (avatarUrl == null || avatarUrl!.isEmpty)
                                  ? const Icon(Icons.person_rounded,
                                      size: 17, color: AppColors.brandPrimary)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }
}
