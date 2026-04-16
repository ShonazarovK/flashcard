import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

enum OcrLang {
  english,
  russian,
  french,
  german,
  italian,
  spanish,
  chinese,
  japanese,
  korean,
}

extension OcrLangX on OcrLang {
  String get label => switch (this) {
        OcrLang.english => "English",
        OcrLang.russian => "Russian (Cyrillic)",
        OcrLang.french => "French",
        OcrLang.german => "German",
        OcrLang.italian => "Italian",
        OcrLang.spanish => "Spanish",
        OcrLang.chinese => "Chinese (ZH)",
        OcrLang.japanese => "Japanese (JA)",
        OcrLang.korean => "Korean (KO)",
      };

  TextRecognitionScript get mlkitScript => switch (this) {
        OcrLang.chinese => TextRecognitionScript.chinese,
        OcrLang.japanese => TextRecognitionScript.japanese,
        OcrLang.korean => TextRecognitionScript.korean,
        _ => TextRecognitionScript.latin,
      };

  bool get isCjk =>
      this == OcrLang.chinese || this == OcrLang.japanese || this == OcrLang.korean;
}
