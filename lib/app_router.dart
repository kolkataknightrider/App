// ════════════════════════════════════════════════════════════════
// FILE: lib/app_router.dart
// GoRouter configuration (SECTION 16) with auth redirect + shell.
// All leaf routes use a fade+slide page transition (300ms easeInOut).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/constants/app_routes.dart';
import 'shared/widgets/page_transition.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/team/screens/team_screen.dart';
import 'features/team/screens/member_detail_screen.dart';
import 'features/earnings/screens/earnings_detail_screen.dart';
import 'features/withdrawal/screens/withdrawal_screen.dart';
import 'features/withdrawal/screens/withdrawal_history_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/notifications/screens/notifications_screen.dart';
import 'shared/widgets/shell_with_nav.dart';

/// Listenable that re-triggers router redirects on auth changes.
class AuthListenable extends ChangeNotifier {
  AuthListenable() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _isSignedIn = user != null;
      notifyListeners();
    });
  }

  bool _isSignedIn = FirebaseAuth.instance.currentUser != null;
  bool get isSignedIn => _isSignedIn;
}

final authListenable = AuthListenable();

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: authListenable,
    redirect: (context, state) {
      final loggedIn = authListenable.isSignedIn;
      final loc = state.matchedLocation;

      // Allow the splash screen to decide initial navigation.
      if (loc == AppRoutes.splash) return null;

      if (!loggedIn && loc != AppRoutes.login) return AppRoutes.login;
      if (loggedIn && loc == AppRoutes.login) return AppRoutes.dashboard;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (c, s) => fadeSlidePageBuilder(c, s, const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (c, s) => fadeSlidePageBuilder(c, s, const LoginScreen()),
      ),

      // ── Bottom-navigation shell ──
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => ShellWithNav(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                pageBuilder: (c, s) =>
                    fadeSlidePageBuilder(c, s, const DashboardScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.team,
                pageBuilder: (c, s) =>
                    fadeSlidePageBuilder(c, s, const TeamScreen()),
              ),
              GoRoute(
                path: AppRoutes.memberDetail,
                pageBuilder: (c, s) => scalePageBuilder(
                  c,
                  s,
                  MemberDetailScreen(
                    memberId: s.pathParameters['memberId'] ?? '',
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.earnings,
                pageBuilder: (c, s) =>
                    fadeSlidePageBuilder(c, s, const EarningsDetailScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.withdrawal,
                pageBuilder: (c, s) =>
                    fadeSlidePageBuilder(c, s, const WithdrawalScreen()),
              ),
              GoRoute(
                path: AppRoutes.withdrawalHistory,
                pageBuilder: (c, s) => fadeSlidePageBuilder(
                  c,
                  s,
                  const WithdrawalHistoryScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (c, s) =>
                    fadeSlidePageBuilder(c, s, const ProfileScreen()),
              ),
            ],
          ),
        ],
      ),

      // ── Notification center (outside shell) ──
      GoRoute(
        path: AppRoutes.notificationsRoute,
        pageBuilder: (c, s) =>
            fadeSlidePageBuilder(c, s, const NotificationsScreen()),
      ),
    ],
  );
}
