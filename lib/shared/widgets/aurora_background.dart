// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/aurora_background.dart
// Living "aurora" backdrop — slowly drifting colour orbs behind a
// dark gradient. Used on splash, login and screen headers.
// ════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:partix/core/constants/app_colors.dart';

class AuroraBackground extends StatefulWidget {
  final Widget child;

  /// Blob colours (3 recommended).
  final List<Color> colors;

  /// Seconds for one full drift cycle.
  final int cycleSeconds;

  /// Base gradient behind the blobs.
  final Gradient? base;

  /// Blob intensity 0..1.
  final double intensity;

  const AuroraBackground({
    super.key,
    required this.child,
    this.colors = const [
      AppColors.brandPrimary,
      AppColors.brandAccent,
      AppColors.brandSecondary,
    ],
    this.cycleSeconds = 18,
    this.base,
    this.intensity = 1,
  });

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: Duration(seconds: widget.cycleSeconds),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Deep base gradient ──
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: widget.base ??
                const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF07070F),
                    Color(0xFF0C0C1D),
                    Color(0xFF140B2E),
                  ],
                ),
          ),
        ),

        // ── Drifting light orbs ──
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) => CustomPaint(
              painter: _AuroraPainter(
                t: _c.value,
                colors: widget.colors,
                intensity: widget.intensity,
              ),
            ),
          ),
        ),

        // ── Vignette so content stays readable ──
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 1.1,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.45),
              ],
            ),
          ),
        ),

        widget.child,
      ],
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final double t;
  final List<Color> colors;
  final double intensity;

  _AuroraPainter({
    required this.t,
    required this.colors,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final blobs = <_Blob>[
      _Blob(
        center: Offset(
          w * (0.25 + 0.20 * math.sin(2 * math.pi * t)),
          h * (0.18 + 0.10 * math.cos(2 * math.pi * t)),
        ),
        radius: w * 0.62,
        color: colors[0],
      ),
      _Blob(
        center: Offset(
          w * (0.82 + 0.14 * math.cos(2 * math.pi * (t + 0.33))),
          h * (0.34 + 0.12 * math.sin(2 * math.pi * (t + 0.33))),
        ),
        radius: w * 0.55,
        color: colors.length > 1 ? colors[1] : colors[0],
      ),
      _Blob(
        center: Offset(
          w * (0.45 + 0.18 * math.sin(2 * math.pi * (t + 0.66))),
          h * (0.82 + 0.10 * math.cos(2 * math.pi * (t + 0.66))),
        ),
        radius: w * 0.70,
        color: colors.length > 2 ? colors[2] : colors[0],
      ),
    ];

    for (final b in blobs) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            b.color.withOpacity(0.42 * intensity),
            b.color.withOpacity(0.16 * intensity),
            b.color.withOpacity(0),
          ],
          stops: const [0, 0.45, 1],
        ).createShader(Rect.fromCircle(center: b.center, radius: b.radius));
      canvas.drawCircle(b.center, b.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter old) => old.t != t;
}

class _Blob {
  final Offset center;
  final double radius;
  final Color color;
  const _Blob({
    required this.center,
    required this.radius,
    required this.color,
  });
}

/// Soft glowing ring used behind the logo (login / splash).
class GlowRing extends StatefulWidget {
  final double size;
  final Color color;
  const GlowRing({
    super.key,
    this.size = 200,
    this.color = AppColors.brandPrimary,
  });

  @override
  State<GlowRing> createState() => _GlowRingState();
}

class _GlowRingState extends State<GlowRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final v = Curves.easeInOut.transform(_c.value);
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // outer pulsing halo
              Container(
                width: widget.size * (0.72 + 0.20 * v),
                height: widget.size * (0.72 + 0.20 * v),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.color.withOpacity(0.30 * (1 - v) + 0.10),
                      widget.color.withOpacity(0),
                    ],
                  ),
                ),
              ),
              // rotating conic ring
              Transform.rotate(
                angle: 2 * math.pi * _c.value,
                child: Container(
                  width: widget.size * 0.62,
                  height: widget.size * 0.62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        widget.color.withOpacity(0),
                        widget.color.withOpacity(0.55),
                        AppColors.brandAccent.withOpacity(0.55),
                        widget.color.withOpacity(0),
                      ],
                      stops: const [0.0, 0.35, 0.65, 1.0],
                    ),
                  ),
                ),
              ),
              // inner mask so only the ring shows
              Container(
                width: widget.size * 0.52,
                height: widget.size * 0.52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0A0A16).withOpacity(0.85),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
