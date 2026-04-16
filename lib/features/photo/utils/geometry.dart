import 'dart:math';
import 'dart:ui';

Rect fitContain(Size input, Size output) {
  final s = min(output.width / input.width, output.height / input.height);
  final w = input.width * s;
  final h = input.height * s;
  final left = (output.width - w) / 2;
  final top = (output.height - h) / 2;
  return Rect.fromLTWH(left, top, w, h);
}
