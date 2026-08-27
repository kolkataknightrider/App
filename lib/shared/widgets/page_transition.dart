// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/page_transition.dart
// Reusable GoRouter page transitions (SECTION 16: 300ms easeInOut).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Fade + subtle slide-up page transition.
Page<dynamic> fadeSlidePageBuilder(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offset = Tween<Offset>(
        begin: const Offset(0, 0.08),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ));
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: SlideTransition(position: offset, child: child),
      );
    },
  );
}

/// Scale-in page transition (great for modals / detail screens).
Page<dynamic> scalePageBuilder(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scale = Tween<double>(begin: 0.92, end: 1).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
      );
      return ScaleTransition(
        scale: scale,
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}
