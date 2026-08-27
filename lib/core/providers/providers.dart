// ════════════════════════════════════════════════════════════════
// FILE: lib/core/providers/providers.dart
// Central Riverpod provider instances.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/themes/app_theme.dart';
import 'auth_provider.dart';
import 'user_provider.dart';
import 'dashboard_provider.dart';
import 'team_provider.dart';
import 'earnings_provider.dart';
import 'withdrawal_provider.dart';
import 'notification_provider.dart';

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
