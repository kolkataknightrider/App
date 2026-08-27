// ════════════════════════════════════════════════════════════════
// FILE: lib/core/constants/app_routes.dart
// Route path constants used by GoRouter.
// ════════════════════════════════════════════════════════════════

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';

  // Bottom-nav shell + tabs
  static const String home = '/home';
  static const String dashboard = '/home/dashboard';
  static const String team = '/home/team';
  static const String memberDetail = '/home/team/:memberId';
  static const String earnings = '/home/earnings';
  static const String withdrawal = '/home/withdrawal';
  static const String withdrawalHistory = '/home/withdrawal/history';
  static const String profile = '/home/profile';

  static const String notificationsRoute = '/notifications';

  /// Build the member detail path for a given [memberId].
  static String memberDetailPath(String memberId) =>
      '/home/team/$memberId';

  /// Path helpers for named navigation if needed.
  static const String loginName = 'login';
  static const String dashboardName = 'dashboard';
  static const String teamName = 'team';
  static const String earningsName = 'earnings';
  static const String withdrawalName = 'withdrawal';
  static const String profileName = 'profile';
  static const String notificationsName = 'notifications';
}
