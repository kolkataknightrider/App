// ════════════════════════════════════════════════════════════════
// FILE: lib/features/dashboard/widgets/earning_metric_card.dart
// Gradient + glass metric tile: counts the amount up, has a moving
// sheen, a large ghost icon and springy press feedback.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:partix/core/constants/app_dimensions.dart';
import 'package:partix/shared/widgets/animated_counter.dart';

class EarningMetricCard extends StatefulWidget {
  final String label;

  /// Pre-formatted amount (used when [value] is null).
  final String amount;

  /// Raw value — when provided the amount counts up smoothly.
  final double? value;

  final String? percentChange;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback? onTap;

  /// Large hero variant (gross career earnings).
  final bool large;

  const EarningMetricCard({
    super.key,
    required this.label,
    required this.amount,
    this.value,
    this.percentChange,
    required this.icon,
    required this.gradient,
    this.onTap,
    this.large = false,
  });

  @override
  State<EarningMetricCard> createState() => _EarningMetricCardState();
}

class _EarningMetricCardState extends State<EarningMetricCard>
    with SingleTickerProviderStateMixin {
  bool _down = false;

  late final AnimationController _sheen = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  )..repeat();

  @override
  void dispose() {
    _sheen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final negative = widget.percentChange?.startsWith('-') ?? false;
    final radius = BorderRadius.circular(widget.large ? 26 : 22);

    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onTap!();
            },
      child: AnimatedScale(
        scale: _down ? 0.965 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Container(
          height: widget.large ? 132 : AppDimensions.earningCardHeight,
          padding: EdgeInsets.all(widget.large ? 18 : 14),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: radius,
            border: Border.all(color: Colors.white.withOpacity(0.14)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // ghost icon
              Positioned(
                right: -14,
                bottom: -14,
                child: Icon(
                  widget.icon,
                  size: widget.large ? 96 : 74,
                  color: Colors.white.withOpacity(0.16),
                ),
              ),

              // moving sheen
              AnimatedBuilder(
                animation: _sheen,
                builder: (context, _) => Align(
                  alignment: Alignment(-1.8 + 3.6 * _sheen.value, -1),
                  child: Transform.rotate(
                    angle: 0.5,
                    child: Container(
                      width: 46,
                      height: 260,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0.13),
                            Colors.white.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(widget.icon,
                            size: 13, color: Colors.white.withOpacity(0.95)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.label.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: widget.value != null
                            ? AnimatedCounter(
                                value: widget.value!,
                                duration: const Duration(milliseconds: 900),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: widget.large ? 30 : 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                ),
                              )
                            : Text(
                                widget.amount,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: widget.large ? 30 : 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                ),
                              ),
                      ),
                      if (widget.percentChange != null) ...[
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                negative
                                    ? Icons.trending_down_rounded
                                    : Icons.trending_up_rounded,
                                size: 11,
                                color: negative
                                    ? const Color(0xFFFFB4B4)
                                    : const Color(0xFFB9FFD8),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  widget.percentChange!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: negative
                                        ? const Color(0xFFFFB4B4)
                                        : Colors.white.withOpacity(0.92),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
