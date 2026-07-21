import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CrtOverlay extends StatefulWidget {
  final Widget child;

  const CrtOverlay({super.key, required this.child});

  @override
  State<CrtOverlay> createState() => _CrtOverlayState();
}

class _CrtOverlayState extends State<CrtOverlay> {
  final ValueNotifier<int> _frame = ValueNotifier<int>(0);
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _frame.value++;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _frame.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _CrtEffectPainter(frame: _frame),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ],
    );
  }
}

class _CrtEffectPainter extends CustomPainter {
  final ValueListenable<int> frame;
  final _random = Random(42);

  _CrtEffectPainter({required this.frame}) : super(repaint: frame);

  @override
  void paint(Canvas canvas, Size size) {
    // Scanlines
    final scanPaint = Paint()
      ..color = Colors.black.withAlpha(20)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanPaint);
    }

    // Subtle vignette - darkened edges
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.2,
        colors: [
          Colors.transparent,
          Colors.black.withAlpha(40),
          Colors.black.withAlpha(80),
        ],
        stops: const [0.5, 0.8, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, gradientPaint);

    // Random subtle flicker.
    if (frame.value % 4 == 0 && _random.nextDouble() > 0.7) {
      final flickerPaint = Paint()
        ..color = Colors.white.withAlpha(5);
      canvas.drawRect(rect, flickerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CrtEffectPainter oldDelegate) => false;
}
