import 'package:flutter/material.dart';

import '../models/ocr_models.dart';
import '../utils/geometry.dart';

class OcrOverlayPainter extends CustomPainter {
  final List<OcrWord> words;
  final Set<int> selected;
  final Size? imageSize;

  OcrOverlayPainter({
    required this.words,
    required this.selected,
    required this.imageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (imageSize == null || words.isEmpty || selected.isEmpty) return;

    final img = imageSize!;
    final rect = fitContain(img, size);

    final sx = rect.width / img.width;
    final sy = rect.height / img.height;

    final fill = Paint()..color = Colors.yellow.withOpacity(0.28);
    final underline = Paint()
      ..color = Colors.purple.withOpacity(0.85)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (final i in selected) {
      if (i < 0 || i >= words.length) continue;

      final rImg = words[i].box;
      final r = Rect.fromLTWH(
        rect.left + rImg.left * sx,
        rect.top + rImg.top * sy,
        rImg.width * sx,
        rImg.height * sy,
      );

      canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(6)), fill);
      final y = r.bottom + 2;
      canvas.drawLine(Offset(r.left, y), Offset(r.right, y), underline);
    }
  }

  @override
  bool shouldRepaint(covariant OcrOverlayPainter oldDelegate) {
    return oldDelegate.selected != selected ||
        oldDelegate.words != words ||
        oldDelegate.imageSize != imageSize;
  }
}
