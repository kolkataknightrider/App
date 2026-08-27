// ════════════════════════════════════════════════════════════════
// FILE: lib/features/dashboard/widgets/earning_metric_card.dart
// SECTION 7 — gradient earnings metric card (110px, radius 18).
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';

class EarningMetricCard extends StatelessWidget {
  final String label;
  final String amount;
  final String? percentChange;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback? onTap;

  const EarningMetricCard({
    super.key,
    required this.label,
    required this.amount,
    this.percentChange,
    required this.icon,
    required this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.earningCardHeight,
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -8,
              bottom: -8,
              child:
                  Icon(icon, size: 64, color: Colors.white.withOpacity(0.18)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      amount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (percentChange != null)
                      Row(
                        children: [
                          Icon(
                            percentChange!.startsWith('-')
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            size: 12,
                            color: percentChange!.startsWith('-')
                                ? AppColors.error
                                : Colors.white,
                          ),
                          Text(
                            percentChange!,
                            style: TextStyle(
                              color: percentChange!.startsWith('-')
                                  ? AppColors.error
                                  : Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }
}
