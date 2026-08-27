// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/section_card.dart
// Shared "card with title + optional trailing" chrome.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/shared/widgets/glass.dart';

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
    return GlassCard(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      padding: padding ?? const EdgeInsets.all(AppDimensions.md),
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 15,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15.5, fontWeight: FontWeight.w700)),
                ],
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
