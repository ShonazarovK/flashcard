import 'dart:math';
import '../models/ocr_models.dart';

List<int> buildReadingOrder(List<OcrWord> words) {
  if (words.isEmpty) return const [];

  final heights = words.map((w) => w.box.height).toList()..sort();
  final medianH = heights[heights.length ~/ 2].clamp(6.0, 200.0);
  final lineThresh = medianH * 0.60;

  final items = List<int>.generate(words.length, (i) => i);

  items.sort((a, b) {
    final ra = words[a].box;
    final rb = words[b].box;
    final ya = ra.center.dy;
    final yb = rb.center.dy;
    final dy = ya.compareTo(yb);
    if (dy != 0) return dy;
    return ra.left.compareTo(rb.left);
  });

  final lines = <List<int>>[];
  final lineYs = <double>[];

  for (final idx in items) {
    final y = words[idx].box.center.dy;
    int bestLine = -1;
    double bestDist = double.infinity;

    for (int li = 0; li < lineYs.length; li++) {
      final dist = (lineYs[li] - y).abs();
      if (dist < bestDist) {
        bestDist = dist;
        bestLine = li;
      }
    }

    if (bestLine == -1 || bestDist > lineThresh) {
      lines.add([idx]);
      lineYs.add(y);
    } else {
      lines[bestLine].add(idx);
      final ys = lines[bestLine].map((i) => words[i].box.center.dy).toList();
      lineYs[bestLine] = ys.reduce((a, b) => a + b) / max(1, ys.length);
    }
  }

  final lineOrder = List<int>.generate(lines.length, (i) => i)
    ..sort((a, b) => lineYs[a].compareTo(lineYs[b]));

  final out = <int>[];
  for (final li in lineOrder) {
    final line = lines[li];
    line.sort((a, b) => words[a].box.left.compareTo(words[b].box.left));
    out.addAll(line);
  }
  return out;
}
