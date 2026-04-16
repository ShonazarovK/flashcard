import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// Overlay that draws a "document scan" frame + animated scan line.
/// Put this ABOVE CameraPreview in a Stack.
class ScanOverlay extends StatefulWidget {
  const ScanOverlay({
    super.key,
    this.frameAspectRatio = 3 / 4, // portrait-ish frame
    this.frameWidthFactor = 0.82,  // % of screen width
    this.cornerLength = 26,
    this.cornerStroke = 4,
    this.dimOpacity = 0.55,
    this.borderRadius = 18,
    this.lineThickness = 2,
    this.linePadding = 14,
  });

  final double frameAspectRatio;
  final double frameWidthFactor;
  final double cornerLength;
  final double cornerStroke;
  final double dimOpacity;
  final double borderRadius;
  final double lineThickness;
  final double linePadding;

  @override
  State<ScanOverlay> createState() => _ScanOverlayState();
}

class _ScanOverlayState extends State<ScanOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final size = Size(c.maxWidth, c.maxHeight);

      final frameW = size.width * widget.frameWidthFactor;
      final frameH = frameW / widget.frameAspectRatio;

      // keep frame inside screen
      final maxH = size.height * 0.72;
      final finalH = math.min(frameH, maxH);
      final finalW = finalH * widget.frameAspectRatio;

      final frameRect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.42),
        width: finalW,
        height: finalH,
      );

      return AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return CustomPaint(
            size: size,
            painter: _ScanOverlayPainter(
              frameRect: frameRect,
              t: _ctrl.value,
              cornerLength: widget.cornerLength,
              cornerStroke: widget.cornerStroke,
              dimOpacity: widget.dimOpacity,
              radius: widget.borderRadius,
              lineThickness: widget.lineThickness,
              linePadding: widget.linePadding,
            ),
          );
        },
      );
    });
  }
}

class _ScanOverlayPainter extends CustomPainter {
  _ScanOverlayPainter({
    required this.frameRect,
    required this.t,
    required this.cornerLength,
    required this.cornerStroke,
    required this.dimOpacity,
    required this.radius,
    required this.lineThickness,
    required this.linePadding,
  });

  final Rect frameRect;
  final double t; // 0..1
  final double cornerLength;
  final double cornerStroke;
  final double dimOpacity;
  final double radius;
  final double lineThickness;
  final double linePadding;

  @override
  void paint(Canvas canvas, Size size) {
    // dim outside
    final dimPaint = Paint()..color = Colors.black.withOpacity(dimOpacity);
    canvas.drawRect(Offset.zero & size, dimPaint);

    final rrect = RRect.fromRectAndRadius(frameRect, Radius.circular(radius));

    // punch the hole
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, dimPaint);
    final clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawRRect(rrect, clearPaint);
    canvas.restore();

    // corners
    final cornerPaint = Paint()
      ..color = Colors.white.withOpacity(0.92)
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerStroke
      ..strokeCap = StrokeCap.round;

    void drawCorner(Offset p, Offset dx, Offset dy) {
      canvas.drawLine(p, p + dx * cornerLength, cornerPaint);
      canvas.drawLine(p, p + dy * cornerLength, cornerPaint);
    }

    drawCorner(frameRect.topLeft, const Offset(1, 0), const Offset(0, 1));
    drawCorner(frameRect.topRight, const Offset(-1, 0), const Offset(0, 1));
    drawCorner(frameRect.bottomLeft, const Offset(1, 0), const Offset(0, -1));
    drawCorner(frameRect.bottomRight, const Offset(-1, 0), const Offset(0, -1));

    // animated scan line
    final y = lerpDouble(
      frameRect.top + linePadding,
      frameRect.bottom - linePadding,
      t,
    )!;

    final glow = Paint()
      ..color = Colors.white.withOpacity(0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final line = Paint()
      ..color = Colors.white.withOpacity(0.65)
      ..strokeWidth = lineThickness
      ..strokeCap = StrokeCap.round;

    final left = frameRect.left + linePadding;
    final right = frameRect.right - linePadding;

    canvas.drawLine(Offset(left, y), Offset(right, y), glow);
    canvas.drawLine(Offset(left, y), Offset(right, y), line);
  }

  @override
  bool shouldRepaint(covariant _ScanOverlayPainter oldDelegate) {
    return oldDelegate.frameRect != frameRect || oldDelegate.t != t;
  }
}