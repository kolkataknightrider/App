// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/section_card.dart
// Shared "card with title + optional trailing" chrome (clay version).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/shared/widgets/clay.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsets? padding;

  const SectionCard({
    super.key,
    required this.title,
    this.trailing,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      title: title,
      trailing: trailing,
      padding: padding ?? const EdgeInsets.all(AppDimensions.md),
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      child: child,
    );
  }
}
