// ════════════════════════════════════════════════════════════════
// FILE: lib/core/utils/device_info.dart
// Android device info helpers (package_info_plus).
// ════════════════════════════════════════════════════════════════

import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfo {
  DeviceInfo._();

  static PackageInfo? _info;

  /// Load package metadata once.
  static Future<void> init() async {
    _info ??= await PackageInfo.fromPlatform();
  }

  static String get appVersion => _info?.version ?? '1.0.0';
  static String get buildNumber => _info?.buildNumber ?? '1';
  static String get appName => _info?.appName ?? 'Partix';

  /// Formats the current app version string used across the app.
  static String get versionLabel => 'v$appVersion';
}
