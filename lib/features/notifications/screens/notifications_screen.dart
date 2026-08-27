// ════════════════════════════════════════════════════════════════
// FILE: lib/features/notifications/screens/notifications_screen.dart
// Notification center (SECTION 13). Marks read on tap + deep links.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/core/constants/app_strings.dart';
import 'package:partix/core/constants/app_routes.dart';
import 'package:partix/core/firebase/auth_service.dart';
import 'package:partix/core/models/notification_model.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/core/utils/date_formatter.dart';
import 'package:partix/shared/widgets/empty_state_widget.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = AuthService.instance.currentUid;
      if (uid != null) ref.read(notificationProvider).watch(uid);
    });
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'earning':
        return Icons.paid;
      case 'withdrawal':
        return Icons.account_balance_wallet;
      case 'rank_up':
        return Icons.military_tech;
      case 'new_member':
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  void _onTap(NotificationModel n) {
    ref
        .read(notificationProvider)
        .markRead(AuthService.instance.currentUid!, n.id);
    switch (n.type) {
      case 'withdrawal':
        context.go(AppRoutes.withdrawalHistory);
        break;
      case 'new_member':
        context.go(AppRoutes.team);
        break;
      case 'rank_up':
      case 'earning':
      default:
        context.go(AppRoutes.earnings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notif = ref.watch(notificationProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: notif.loading
          ? const Center(child: CircularProgressIndicator())
          : notif.items.isEmpty
              ? const EmptyStateWidget(message: 'No notifications yet')
              : ListView.separated(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  itemCount: notif.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final n = notif.items[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: n.isRead
                            ? Theme.of(context).cardColor
                            : AppColors.brandPrimary.withOpacity(0.08),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusCard),
                      ),
                      child: ListTile(
                        onTap: () => _onTap(n),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.brandPrimary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_iconFor(n.type),
                              color: AppColors.brandPrimary),
                        ),
                        title: Text(n.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.body,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12)),
                            Text(DateFormatter.timeAgo(n.createdAt),
                                style: const TextStyle(
                                    color: AppColors.textTertiary,
                                    fontSize: 10)),
                          ],
                        ),
                        trailing: n.isRead
                            ? null
                            : const Icon(Icons.circle,
                                size: 10, color: AppColors.brandPrimary),
                      ),
                    );
                  },
                ),
    );
  }
}
