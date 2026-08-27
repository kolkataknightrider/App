// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/shell_with_nav.dart
// Bottom-navigation shell. Triggers home data streams + badges.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/core/firebase/auth_service.dart';
import 'package:partix/shared/widgets/partix_bottom_nav.dart';

class ShellWithNav extends ConsumerStatefulWidget {
  final StatefulNavigationShell shell;
  const ShellWithNav({super.key, required this.shell});

  @override
  ConsumerState<ShellWithNav> createState() => _ShellWithNavState();
}

class _ShellWithNavState extends ConsumerState<ShellWithNav> {
  bool _started = false;

  String? get _uid => AuthService.instance.currentUid;

  @override
  Widget build(BuildContext context) {
    if (!_started) {
      _started = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _startWatches());
    }

    final notifications = ref.watch(notificationProvider);
    final withdrawals = ref.watch(withdrawalProvider);
    final pendingWallet = withdrawals.history
        .where((w) => w.status == 'pending' || w.status == 'processing')
        .length;

    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: PartixBottomNav(
        currentIndex: widget.shell.currentIndex,
        walletBadge: pendingWallet,
        homeBadge: notifications.unreadCount,
      ),
    );
  }

  void _startWatches() {
    final uid = _uid;
    if (uid == null) return;
    final auth = ref.read(authProvider);
    if (auth.user != null) {
      ref.read(userProvider).setUser(auth.user!);
    }
    ref.read(userProvider).watchUser(uid);
    ref.read(dashboardProvider).watchEarnings(uid);
    ref.read(earningsProvider).watchEarnings(uid);
    ref.read(withdrawalProvider).watchHistory(uid);
    ref.read(notificationProvider).watch(uid);
  }
}
