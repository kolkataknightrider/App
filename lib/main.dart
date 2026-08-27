// ════════════════════════════════════════════════════════════════
// FILE: lib/main.dart
// PARTIX application entry point.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:partix/core/firebase/firebase_config.dart';
import 'package:partix/core/utils/device_info.dart';
import 'package:partix/core/services/offline_sync_service.dart';
import 'package:partix/core/providers/providers.dart';
import 'package:partix/shared/themes/app_theme.dart';
import 'package:partix/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize non-Firebase systems first so the app can at least render.
  await DeviceInfo.init();
  await OfflineSyncService.instance.init();

  // Firebase must be configured before running the main app.
  bool firebaseOk = false;
  try {
    await FirebaseConfig.initialize();
    firebaseOk = true;
  } catch (e) {
    debugPrint('Firebase not configured: $e');
    firebaseOk = false;
  }

  runApp(ProviderScope(child: PartixApp(firebaseOk: firebaseOk)));
}

class PartixApp extends StatelessWidget {
  final bool firebaseOk;
  const PartixApp({super.key, required this.firebaseOk});

  @override
  Widget build(BuildContext context) {
    if (!firebaseOk) return const ConfigErrorApp();
    return const _FirebaseApp();
  }
}

class _FirebaseApp extends ConsumerWidget {
  const _FirebaseApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Partix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: buildRouter(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
      ],
    );
  }
}

/// Shown when Firebase credentials have not been configured.
class ConfigErrorApp extends StatelessWidget {
  const ConfigErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D0D1A), Color(0xFF1A237E)],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 14),
                      decoration: BoxDecoration(
                        gradient: AppTheme.light.primaryColor == Colors.blue
                            ? null
                            : const LinearGradient(
                                colors: [Color(0xFF6C63FF), Color(0xFF06B6D4)]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('PARTIX',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 4)),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Firebase Not Configured',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Open lib/core/firebase/firebase_config.dart and replace '
                      'the YOUR_* placeholders with your real Firebase '
                      'project credentials. Then place google-services.json '
                      'in android/app/ and run again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, height: 1.5),
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
}
