import 'package:flutter/material.dart';

class ParticleExplosion extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final VoidCallback? onComplete;

  const ParticleExplosion({
    super.key,
    required this.child,
    this.trigger = false,
    this.onComplete,
  });

  @override
  State<ParticleExplosion> createState() => _ParticleExplosionState();
}

class _ParticleExplosionState extends State<ParticleExplosion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _exploding = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 700),
        )..addListener(() {
          if (_controller.isCompleted && _exploding) {
            setState(() => _exploding = false);
            widget.onComplete?.call();
          }
        });
  }

  @override
  void didUpdateWidget(ParticleExplosion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger && !_exploding) {
      _explode();
    }
  }

  void _explode() {
    _exploding = true;
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_exploding) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = _controller.value;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Opacity(opacity: 1.0 - progress, child: widget.child),
            Positioned.fill(
              child: CustomPaint(painter: _CRTPainter(progress: progress)),
            ),
          ],
        );
      },
    );
  }
}

class _CRTPainter extends CustomPainter {
  final double progress;

  _CRTPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    const scanlines = 24;
    final slotHeight = size.height / scanlines;
    final barHeight = slotHeight * progress;
    final paint = Paint()..color = Colors.black;

    for (int i = 0; i < scanlines; i++) {
      final y = slotHeight * i;
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, barHeight), paint);
    }
  }

  @override
  bool shouldRepaint(_CRTPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
