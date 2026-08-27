// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/partix_app_bar.dart
// PARTIX branded app bar with optional notification bell + avatar.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';

class PartixAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showMenu;
  final bool showNotifications;
  final bool showAvatar;
  final String? avatarUrl;
  final int notificationCount;
  final VoidCallback? onMenuTap;

  const PartixAppBar({
    super.key,
    this.title = AppStrings.appName,
    this.showMenu = true,
    this.showNotifications = true,
    this.showAvatar = true,
    this.avatarUrl,
    this.notificationCount = 0,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      leading: showMenu
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuTap ?? () {},
            )
          : null,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'PARTIX',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (showNotifications)
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () =>
                    context.push(AppRoutes.notificationsRoute),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      notificationCount > 9 ? '9+' : '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        if (showAvatar) ...[
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.md),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.brandPrimary.withOpacity(0.2),
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? const Icon(Icons.person, size: 18,
                      color: AppColors.brandPrimary)
                  : null,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
