
import '../models/ocr_models.dart';

class SelectionController {
  final Set<int> selected = {};

  void toggle(int index) {
    if (selected.contains(index)) {
      selected.remove(index);
    } else {
      selected.add(index);
    }
  }

  void clear() {
    selected.clear();
  }

  List<String> getSelectedTokens(OcrData? ocr) {
    if (ocr == null || selected.isEmpty) return [];

    final pos = <int, int>{};
    for (int i = 0; i < ocr.readingOrder.length; i++) {
      pos[ocr.readingOrder[i]] = i;
    }

    final idxs = selected.toList()
      ..sort((a, b) => (pos[a] ?? 1 << 30).compareTo(pos[b] ?? 1 << 30));

    return idxs
        .where((i) => i >= 0 && i < ocr.words.length)
        .map((i) => ocr.words[i].text.trim())
        .where((t) => t.isNotEmpty)
        .toList();
  }

  String getCsv(OcrData? ocr) {
    final tokens = getSelectedTokens(ocr);
    return tokens.join(", ");
  }
}
