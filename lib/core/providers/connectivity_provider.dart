// ════════════════════════════════════════════════════════════════
// FILE: lib/core/providers/connectivity_provider.dart
// Exposes offline/online status as Riverpod state.
// ════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partix/core/services/offline_sync_service.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  final controller = StreamController<bool>.broadcast();
  final sub = OfflineSyncService.instance.connectionStream.listen((online) {
    controller.add(online);
  });
  // Emit initial value.
  controller.add(OfflineSyncService.instance.isOnline);
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
