import 'dart:ui';

class OcrWord {
  final String text;
  final Rect box;
  const OcrWord({required this.text, required this.box});
}

class OcrData {
  final List<OcrWord> words;
  final bool ruNormalized;
  final List<int> readingOrder;

  const OcrData({
    required this.words,
    required this.ruNormalized,
    required this.readingOrder,
  });
}
