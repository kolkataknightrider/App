// ════════════════════════════════════════════════════════════════
// FILE: lib/core/providers/providers.dart
// Central Riverpod provider instances.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partix/shared/themes/app_theme.dart';
import 'package:partix/core/providers/auth_provider.dart';
import 'package:partix/core/providers/user_provider.dart';
import 'package:partix/core/providers/dashboard_provider.dart';
import 'package:partix/core/providers/team_provider.dart';
import 'package:partix/core/providers/earnings_provider.dart';
import 'package:partix/core/providers/withdrawal_provider.dart';
import 'package:partix/core/providers/notification_provider.dart';

// Re-export the notifier classes so screens importing providers.dart can
// reference their types directly.
export 'package:partix/core/providers/auth_provider.dart';
export 'package:partix/core/providers/user_provider.dart';
export 'package:partix/core/providers/dashboard_provider.dart';
export 'package:partix/core/providers/team_provider.dart';
export 'package:partix/core/providers/earnings_provider.dart';
export 'package:partix/core/providers/withdrawal_provider.dart';
export 'package:partix/core/providers/notification_provider.dart';
export 'package:partix/core/providers/connectivity_provider.dart';

final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());

final userProvider =
    ChangeNotifierProvider<UserProvider>((ref) => UserProvider());

final dashboardProvider =
    ChangeNotifierProvider<DashboardProvider>((ref) => DashboardProvider());

final teamProvider =
    ChangeNotifierProvider<TeamProvider>((ref) => TeamProvider());

final earningsProvider =
    ChangeNotifierProvider<EarningsProvider>((ref) => EarningsProvider());

final withdrawalProvider =
    ChangeNotifierProvider<WithdrawalProvider>((ref) => WithdrawalProvider());

final notificationProvider = ChangeNotifierProvider<NotificationProvider>(
    (ref) => NotificationProvider());

/// Derives the active [ThemeMode] from the current user's preference.
final themeModeProvider = Provider<ThemeMode>((ref) {
  final theme = ref.watch(userProvider).user?.theme ?? 'dark';
  return AppTheme.modeFromName(theme);
});
