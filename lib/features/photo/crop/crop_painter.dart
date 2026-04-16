import 'dart:ui';
import 'package:flutter/material.dart';

class CropOverlayPainter extends CustomPainter {
  final Rect cropRect;
  final double dimAlpha;
  final double borderWidth;
  final double cornerRadius;
  final bool showGrid;

  /// Visual sizes (only drawing)
  final double handleRadius;

  CropOverlayPainter({
    required this.cropRect,
    this.dimAlpha = 0.35,
    this.borderWidth = 2.0,
    this.cornerRadius = 14,
    this.showGrid = true,
    this.handleRadius = 6.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // --- Dim background
    final dimPaint = Paint()..color = Colors.black.withOpacity(dimAlpha);
    canvas.drawRect(Offset.zero & size, dimPaint);

    // --- Cut-out hole (clear)
    final rrect = RRect.fromRectAndRadius(
      cropRect,
      Radius.circular(cornerRadius),
    );

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, dimPaint);

    final clearPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawRRect(rrect, clearPaint);
    canvas.restore();

    // --- Subtle shadow around crop rect (premium depth)
    final shadowPath = Path()..addRRect(rrect);
    canvas.drawShadow(shadowPath, Colors.black.withOpacity(0.55), 10, true);

    // --- Border (outer)
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = Colors.white.withOpacity(0.95);

    canvas.drawRRect(rrect, borderPaint);

    // --- Inner thin border (gives "glass" feel)
    final inner = cropRect.deflate(1.2);
    final innerR = RRect.fromRectAndRadius(
      inner,
      Radius.circular((cornerRadius - 2).clamp(6, 18).toDouble()),
    );
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withOpacity(0.25);
    canvas.drawRRect(innerR, innerPaint);

    // --- Grid 3x3
    if (showGrid) {
      final gridPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.white.withOpacity(0.18);

      final w = cropRect.width;
      final h = cropRect.height;

      final x1 = cropRect.left + w / 3;
      final x2 = cropRect.left + 2 * w / 3;
      final y1 = cropRect.top + h / 3;
      final y2 = cropRect.top + 2 * h / 3;

      canvas.drawLine(Offset(x1, cropRect.top), Offset(x1, cropRect.bottom), gridPaint);
      canvas.drawLine(Offset(x2, cropRect.top), Offset(x2, cropRect.bottom), gridPaint);
      canvas.drawLine(Offset(cropRect.left, y1), Offset(cropRect.right, y1), gridPaint);
      canvas.drawLine(Offset(cropRect.left, y2), Offset(cropRect.right, y2), gridPaint);
    }

    // --- Corner brackets (premium handles)
    final bracketPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withOpacity(0.95);

    const len = 22.0;

    void cornerBracket(Offset c, {required bool left, required bool top}) {
      final sx = left ? 1.0 : -1.0;
      final sy = top ? 1.0 : -1.0;

      // horizontal
      canvas.drawLine(c, c + Offset(len * sx, 0), bracketPaint);
      // vertical
      canvas.drawLine(c, c + Offset(0, len * sy), bracketPaint);
    }

    cornerBracket(cropRect.topLeft, left: true, top: true);
    cornerBracket(cropRect.topRight, left: false, top: true);
    cornerBracket(cropRect.bottomLeft, left: true, top: false);
    cornerBracket(cropRect.bottomRight, left: false, top: false);

    // --- Small circular handles (for clarity)
    final handleFill = Paint()..color = Colors.white.withOpacity(0.95);
    final handleStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black.withOpacity(0.25);

    void drawHandle(Offset c) {
      canvas.drawCircle(c, handleRadius + 2.0, Paint()..color = Colors.black.withOpacity(0.18));
      canvas.drawCircle(c, handleRadius, handleFill);
      canvas.drawCircle(c, handleRadius, handleStroke);
    }

    drawHandle(cropRect.topLeft);
    drawHandle(cropRect.topRight);
    drawHandle(cropRect.bottomLeft);
    drawHandle(cropRect.bottomRight);

    drawHandle(Offset(cropRect.center.dx, cropRect.top));
    drawHandle(Offset(cropRect.center.dx, cropRect.bottom));
    drawHandle(Offset(cropRect.left, cropRect.center.dy));
    drawHandle(Offset(cropRect.right, cropRect.center.dy));
  }

  @override
  bool shouldRepaint(covariant CropOverlayPainter oldDelegate) {
    return oldDelegate.cropRect != cropRect ||
        oldDelegate.dimAlpha != dimAlpha ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.handleRadius != handleRadius;
  }
}