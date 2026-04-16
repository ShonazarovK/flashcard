import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;
import '../../../constants/colors.dart';

class CircularProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;

  const CircularProgressRing({
    super.key,
    required this.progress,
    this.size = 190,
    this.strokeWidth = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: progress,
              strokeWidth: strokeWidth,
            ),
          ),
          Text(
            "${(progress * 100).round()}%",
            style: TextStyle(
              fontSize: size * 0.22, // ✅ ring kattalashsa text ham proporsional
              fontWeight: FontWeight.w700,
              height: 1,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // ✅ FIX: ring radius (oldingi /1.5 ringni kichraytirardi)
    final radius = (size.width - strokeWidth) / 2;

    // BACKGROUND
    final bgPaint = Paint()
      ..color = AppColors.barGray
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // GRADIENT
    final rect = Rect.fromCircle(center: center, radius: radius);

    final sx = size.width / 190.0;
    final sy = size.height / 190.0;

    final p1 = Offset(95.4056 * sx, 0.255003 * sy);
    final p2 = Offset(7.58663 * sx, 107.352 * sy);

    final shader = ui.Gradient.linear(
      p1,
      p2,
      const [
        Color(0xFFFCB049),
        Color(0xFFFCB149),
        Color(0xFFFFC146),
        Color(0xFFC9C390),
        Color(0xFF8DB3FD),
      ],
      const [
        0.0961538,
        0.100962,
        0.274038,
        0.569761,
        0.985765,
      ],
      TileMode.clamp,
    );

    final progressPaint = Paint()
      ..shader = shader
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
