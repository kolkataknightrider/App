// ════════════════════════════════════════════════════════════════
// FILE: lib/shared/widgets/clay_animations.dart
// ANIMATION TOOLKIT — interactions inspired by reactbits.dev and
// vengenceui.com, rebuilt for Flutter + Claymorphism.
//
//   • Magnetic          — element pulls toward the pointer (magnetic)
//   • TiltCard          — 3D tilt that follows the cursor
//   • FlipText          — rotating word with a vertical flip reveal
//   • ShimmerText       — iridescent shimmer sweeping across text
//   • StaggeredReveal   — children fade+slide in one-by-one
//   • Spotlight         — radial light that tracks the pointer
//   • ClayBlobBackground— drifting, morphing clay blobs backdrop
// ════════════════════════════════════════════════════════════════

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:partix/core/constants/clay_palette.dart';

/// ── Magnetic ────────────────────────────────────────────────
/// The child magnetically pulls toward the pointer while it is over
/// (desktop hover) or pressed (touch), then springs back.
class Magnetic extends StatefulWidget {
  final Widget child;
  final double strength; // max translation in logical px
  const Magnetic({super.key, required this.child, this.strength = 18});

  @override
  State<Magnetic> createState() => _MagneticState();
}

class _MagneticState extends State<Magnetic> {
  double _dx = 0, _dy = 0;

  void _apply(Offset local, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final dx = local.dx - cx, dy = local.dy - cy;
    final len = math.max(1.0, math.sqrt(dx * dx + dy * dy));
    final scale = math.min(1.0, len / math.max(cx, cy)) * widget.strength;
    setState(() {
      _dx = dx / len * scale;
      _dy = dy / len * scale;
    });
  }

  void _reset() {
    if (_dx != 0 || _dy != 0) {
      setState(() {
        _dx = 0;
        _dy = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) => _apply(e.localPosition, context.size ?? const Size(1, 1)),
      onExit: (_) => _reset(),
      child: Listener(
        onPointerMove: (e) =>
            _apply(e.localPosition, context.size ?? const Size(1, 1)),
        onPointerUp: (_) => _reset(),
        onPointerCancel: (_) => _reset(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          transform: Matrix4.translationValues(_dx, _dy, 0),
          child: widget.child,
        ),
      ),
    );
  }
}

/// ── TiltCard ────────────────────────────────────────────────
/// Wraps any widget with a perspective 3D tilt that follows the pointer.
class TiltCard extends StatefulWidget {
  final Widget child;
  final double maxTilt; // radians
  const TiltCard({super.key, required this.child, this.maxTilt = 0.12});

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  double _rx = 0, _ry = 0;

  void _onMove(Offset local, Size size) {
    final dx = (local.dx / size.width) * 2 - 1;
    final dy = (local.dy / size.height) * 2 - 1;
    setState(() {
      _rx = -dy * widget.maxTilt;
      _ry = dx * widget.maxTilt;
    });
  }

  void _reset() {
    if (_rx != 0 || _ry != 0) {
      setState(() {
        _rx = 0;
        _ry = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) =>
          _onMove(e.localPosition, context.size ?? const Size(1, 1)),
      onExit: (_) => _reset(),
      child: Listener(
        onPointerMove: (e) =>
            _onMove(e.localPosition, context.size ?? const Size(1, 1)),
        onPointerUp: (_) => _reset(),
        onPointerCancel: (_) => _reset(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_rx)
            ..rotateY(_ry),
          transformAlignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}

/// ── FlipText ────────────────────────────────────────────────
/// Rotating words with a vertical flip reveal (vengenceui "flip-text").
class FlipText extends StatefulWidget {
  final List<String> words;
  final TextStyle? style;
  final Duration hold;
  const FlipText({
    super.key,
    required this.words,
    this.style,
    this.hold = const Duration(milliseconds: 1800),
  });

  @override
  State<FlipText> createState() => _FlipTextState();
}

class _FlipTextState extends State<FlipText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  );
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _loop();
  }

  Future<void> _loop() async {
    while (mounted) {
      await Future.delayed(widget.hold);
      if (!mounted) return;
      await _c.forward(from: 0);
      if (!mounted) return;
      setState(() => _index = (_index + 1) % widget.words.length);
      await _c.reverse();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w700,
        );
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        final angle = t * math.pi; // rotate around X axis
        final visible = t <= 0.5
            ? widget.words[_index]
            : widget.words[(_index + 1) % widget.words.length];
        final scaleY = math.cos(angle).abs().clamp(0.08, 1.0);
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(angle),
          child: Opacity(
            opacity: scaleY < 0.3 ? 0.0 : 1.0,
            child: Text(visible, style: style),
          ),
        );
      },
    );
  }
}

/// ── ShimmerText ─────────────────────────────────────────────
/// A light sweep glides across the text (gradient shader mask).
class ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  const ShimmerText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 2200),
  });

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration)..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        );
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final x = bounds.width * _c.value;
            return LinearGradient(
              colors: [
                style.color ?? Colors.white,
                Colors.white,
                style.color ?? Colors.white,
              ],
              stops: const [0.2, 0.5, 0.8],
              transform: _SlidingGradient(x),
            ).createShader(bounds);
          },
          child: Text(widget.text, style: style),
        );
      },
    );
  }
}

class _SlidingGradient extends GradientTransform {
  final double dx;
  const _SlidingGradient(this.dx);
  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(dx, 0, 0);
}

/// ── StaggeredReveal ─────────────────────────────────────────
/// Reveals its children one-by-one with a fade + slide.
class StaggeredReveal extends StatelessWidget {
  final List<Widget> children;
  final Duration interval;
  final Duration duration;
  final double slideOffset;
  final bool vertical;
  const StaggeredReveal({
    super.key,
    required this.children,
    this.interval = const Duration(milliseconds: 90),
    this.duration = const Duration(milliseconds: 480),
    this.slideOffset = 24,
    this.vertical = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < children.length; i++)
          _StaggeredItem(
            key: ValueKey(i),
            delay: interval * i,
            duration: duration,
            slideOffset: slideOffset,
            vertical: vertical,
            child: children[i],
          ),
      ],
    );
  }
}

class _StaggeredItem extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slideOffset;
  final bool vertical;
  const _StaggeredItem({
    super.key,
    required this.child,
    required this.delay,
    required this.duration,
    required this.slideOffset,
    required this.vertical,
  });

  @override
  State<_StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<_StaggeredItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _curve =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final v = _curve.value;
        final d = (1 - v) * widget.slideOffset;
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: widget.vertical ? Offset(0, d) : Offset(d, 0),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// ── Spotlight ───────────────────────────────────────────────
/// A radial light that tracks the pointer (vengenceui "spotlight").
class Spotlight extends StatefulWidget {
  final Widget child;
  final Color color;
  final double radius;
  final double opacity;
  const Spotlight({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.radius = 160,
    this.opacity = 0.16,
  });

  @override
  State<Spotlight> createState() => _SpotlightState();
}

class _SpotlightState extends State<Spotlight> {
  Offset? _pos;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) => setState(() => _pos = e.localPosition),
      onExit: (_) => setState(() => _pos = null),
      child: Listener(
        onPointerMove: (e) => setState(() => _pos = e.localPosition),
        onPointerUp: (_) => setState(() => _pos = null),
        onPointerCancel: (_) => setState(() => _pos = null),
        child: CustomPaint(
          painter: _SpotlightPainter(
            pos: _pos,
            color: widget.color,
            radius: widget.radius,
            opacity: widget.opacity,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Offset? pos;
  final Color color;
  final double radius;
  final double opacity;
  _SpotlightPainter({
    required this.pos,
    required this.color,
    required this.radius,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (pos == null) return;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(opacity),
          color.withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(center: pos!, radius: radius));
    canvas.drawCircle(pos!, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter old) =>
      old.pos != pos || old.radius != radius;
}

/// ── ClayBlobBackground ──────────────────────────────────────
/// Slowly drifting, morphing clay blobs (reactbits "soft aurora" style
/// but rendered in chunky pastel clay tones).
class ClayBlobBackground extends StatefulWidget {
  final Widget? child;
  final List<Color> colors;
  final int cycleSeconds;
  const ClayBlobBackground({
    super.key,
    this.child,
    this.colors = ClayPalette.blobColors,
    this.cycleSeconds = 16,
  });

  @override
  State<ClayBlobBackground> createState() => _ClayBlobBackgroundState();
}

class _ClayBlobBackgroundState extends State<ClayBlobBackground>
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
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: dark
                  ? const [
                      Color(0xFF17132B),
                      Color(0xFF201A3B),
                      Color(0xFF2A1F46)
                    ]
                  : const [
                      Color(0xFFEFECF8),
                      Color(0xFFE9E4F4),
                      Color(0xFFE0D8EE)
                    ],
            ),
          ),
        ),
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) => CustomPaint(
              painter: _BlobPainter(
                t: _c.value,
                colors: widget.colors,
                dark: dark,
              ),
            ),
          ),
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _BlobPainter extends CustomPainter {
  final double t;
  final List<Color> colors;
  final bool dark;
  _BlobPainter({required this.t, required this.colors, required this.dark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final blobs = [
      _blob(0, w, h, 0.22, 0.18, 0.66, 0.0),
      _blob(1, w, h, 0.80, 0.30, 0.52, 0.33),
      _blob(2, w, h, 0.42, 0.78, 0.62, 0.66),
      _blob(3, w, h, 0.14, 0.72, 0.42, 0.5),
    ];
    for (final b in blobs) {
      final color = colors[b.i % colors.length];
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(dark ? 0.34 : 0.42),
            color.withOpacity(dark ? 0.10 : 0.16),
            color.withOpacity(0),
          ],
          stops: const [0, 0.5, 1],
        ).createShader(Rect.fromCircle(center: b.center, radius: b.radius));
      canvas.drawCircle(b.center, b.radius, paint);
    }
  }

  _Blob _blob(
      int i, double w, double h, double bx, double by, double r, double phase) {
    final a = 2 * math.pi * (t + phase);
    final wobble = math.sin(2 * math.pi * (t * 0.6 + phase));
    return _Blob(
      i: i,
      center: Offset(
        w * (bx + 0.16 * math.sin(a)),
        h * (by + 0.12 * math.cos(a)),
      ),
      radius: w * (r + 0.06 * wobble),
    );
  }

  @override
  bool shouldRepaint(covariant _BlobPainter old) => old.t != t;
}

class _Blob {
  final int i;
  final Offset center;
  final double radius;
  const _Blob({required this.i, required this.center, required this.radius});
}
