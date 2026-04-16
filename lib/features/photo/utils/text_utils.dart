import 'dart:math';

bool looksLikeCyrillic(String text) {
  final s = text.trim();
  if (s.isEmpty) return false;
  final cyr = RegExp(r'[\u0400-\u04FF]');
  final cyrCount = cyr.allMatches(s).length;
  return (cyrCount / max(1, s.length)) > 0.08;
}

String normalizeRuLookalikes(String input) {
  const map = <String, String>{
    'A': 'А',
    'B': 'В',
    'C': 'С',
    'E': 'Е',
    'H': 'Н',
    'K': 'К',
    'M': 'М',
    'O': 'О',
    'P': 'Р',
    'T': 'Т',
    'X': 'Х',
    'Y': 'У',
    'a': 'а',
    'c': 'с',
    'e': 'е',
    'o': 'о',
    'p': 'р',
    'x': 'х',
    'y': 'у',
    'k': 'к',
    'm': 'м',
    'h': 'н',
    't': 'т',
    'b': 'ь',
  };
  const digits = <String, String>{'3': 'з', '6': 'б', '0': 'о'};

  final buf = StringBuffer();
  for (final ch in input.split('')) {
    buf.write(map[ch] ?? digits[ch] ?? ch);
  }
  return buf.toString();
}

String normalizePickedText(String s) {
  var x = s.trim();
  x = x.replaceAll(RegExp(r'^[\s\.,;:!?\(\)\[\]\{\}"“”‘’]+'), '');
  x = x.replaceAll(RegExp(r'[\s\.,;:!?\(\)\[\]\{\}"“”‘’]+$'), '');
  x = x.replaceAll(RegExp(r'\s+'), ' ');
  return x.trim();
}
