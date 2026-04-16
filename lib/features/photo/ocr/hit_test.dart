import 'dart:math';
import 'dart:ui';


import '../models/ocr_models.dart';
import '../utils/geometry.dart';

int? hitTestWordSceneSmart({
  required Offset tapScene,
  required Size childSize,
  required Size imageSize,
  required List<OcrWord> words,
  required double scale,
}) {
  if (words.isEmpty) return null;

  final rect = fitContain(imageSize, childSize);
  if (!rect.contains(tapScene)) return null;

  final sx = imageSize.width / rect.width;
  final sy = imageSize.height / rect.height;

  final dx = tapScene.dx - rect.left;
  final dy = tapScene.dy - rect.top;
  final imgPoint = Offset(dx * sx, dy * sy);

  final padScreen = 14.0;
  final padScene = padScreen / max(1.0, scale);
  final padImg = max(padScene * sx, padScene * sy).clamp(3.0, 60.0);

  int? bestInside;
  double bestArea = double.infinity;

  for (int i = 0; i < words.length; i++) {
    final r = words[i].box.inflate(padImg);
    if (r.contains(imgPoint)) {
      final area = r.width * r.height;
      if (area < bestArea) {
        bestArea = area;
        bestInside = i;
      }
    }
  }
  if (bestInside != null) return bestInside;

  final radiusScreen = 22.0;
  final radiusScene = radiusScreen / max(1.0, scale);
  final radiusImg = max(radiusScene * sx, radiusScene * sy).clamp(8.0, 120.0);
  final r2 = radiusImg * radiusImg;

  int? bestNear;
  double bestD2 = double.infinity;

  for (int i = 0; i < words.length; i++) {
    final c = words[i].box.center;
    final ddx = c.dx - imgPoint.dx;
    final ddy = c.dy - imgPoint.dy;
    final d2 = ddx * ddx + ddy * ddy;
    if (d2 <= r2 && d2 < bestD2) {
      bestD2 = d2;
      bestNear = i;
    }
  }
  return bestNear;
}
