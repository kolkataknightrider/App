// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/shimmer_card.dart
// Shimmer skeleton placeholder used during initial loads.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:partix/core/constants/app_colors.dart';
import 'package:partix/core/constants/app_dimensions.dart';

class ShimmerCard extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const ShimmerCard({
    super.key,
    this.height = AppDimensions.earningCardHeight,
    this.width = double.infinity,
    this.radius = AppDimensions.radiusCard,
  });

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkSurface
        : Colors.grey.shade200;
    final highlight = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkBgTertiary
        : Colors.grey.shade100;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// A grid of shimmer cards for dashboard metrics.
class ShimmerGrid extends StatelessWidget {
  final int count;
  const ShimmerGrid({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: count,
      itemBuilder: (_, __) => const ShimmerCard(),
    );
  }
}
