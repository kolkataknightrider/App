// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/animated_counter.dart
// Smooth count-up number animation (0 → value) for earnings.
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:partix/core/utils/currency_formatter.dart';

class AnimatedCounter extends StatefulWidget {
  final double value;
  final TextStyle? style;
  final bool currency;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.currency = true,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> {
  late double _from;

  @override
  void initState() {
    super.initState();
    _from = 0;
  }

  @override
  void didUpdateWidget(covariant AnimatedCounter old) {
    super.didUpdateWidget(old);
    _from = old.value;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _from, end: widget.value),
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        final text = widget.currency
            ? CurrencyFormatter.format(v)
            : CurrencyFormatter.number(v);
        return Text(
          text,
          style: widget.style ??
              const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
        );
      },
    );
  }
}
