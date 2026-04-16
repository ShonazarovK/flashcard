import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/ocr_lang.dart';
import '../models/ocr_models.dart';
import '../utils/text_utils.dart';
import 'reading_order.dart';

class OcrService {
  Future<OcrData> run(File file, OcrLang lang) async {
    final recognizer = TextRecognizer(script: lang.mlkitScript);
    try {
      final inputImage = InputImage.fromFile(file);
      final recognized = await recognizer.processImage(inputImage);

      final rawFull = recognized.text.trim();
      final bool ruNormalizeFull =
          (lang == OcrLang.russian) && !looksLikeCyrillic(rawFull);

      final words = <OcrWord>[];

      for (final block in recognized.blocks) {
        for (final line in block.lines) {
          for (final e in line.elements) {
            final t = e.text.trim();
            final bb = e.boundingBox;
            if (t.isEmpty || bb == null) continue;

            final normalized =
                (lang == OcrLang.russian && ruNormalizeFull)
                    ? normalizeRuLookalikes(t)
                    : t;

            final cleaned = normalizePickedText(normalized);
            if (cleaned.isEmpty) continue;

            if (lang.isCjk) {
              final chars =
                  cleaned.runes.map((r) => String.fromCharCode(r)).toList();
              if (chars.isEmpty) continue;

              final perW = bb.width / max(1, chars.length);
              for (int i = 0; i < chars.length; i++) {
                final ch = chars[i].trim();
                if (ch.isEmpty) continue;

                final r = Rect.fromLTWH(
                  bb.left + perW * i,
                  bb.top,
                  max(1, perW),
                  bb.height,
                );
                words.add(OcrWord(text: ch, box: r));
              }
            } else {
              words.add(OcrWord(text: cleaned, box: bb));
            }
          }
        }
      }

      final order = buildReadingOrder(words);
      return OcrData(words: words, ruNormalized: ruNormalizeFull, readingOrder: order);
    } finally {
      recognizer.close();
    }
  }
}
