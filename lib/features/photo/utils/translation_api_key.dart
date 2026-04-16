import 'dart:convert';
import 'package:http/http.dart' as http;


import '../models/ocr_lang.dart';

class OpenRouterTranslateService {
  final String apiKey;
  final String model;
  final String? httpReferer;
  final String? xTitle;

  OpenRouterTranslateService({
    required this.apiKey,
    this.model = 'openai/gpt-4o-mini',
    this.httpReferer,
    this.xTitle,
  });

  Future<String> translate({
    required String text,
    required OcrLang sourceLang,
    required OcrLang targetLang,
  }) async {
    final cleaned = text.trim();
    if (cleaned.isEmpty) return "";

    final uri = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
      if (httpReferer != null) 'HTTP-Referer': httpReferer!,
      if (xTitle != null) 'X-Title': xTitle!,
    };

    final systemPrompt = """
You are a professional translation engine.
Translate the user text from ${sourceLang.label} to ${targetLang.label}.
Return ONLY translated text. No quotes. No explanations.
""";

    final body = {
      "model": model,
      "temperature": 0.0,
      "messages": [
        {"role": "system", "content": systemPrompt},
        {"role": "user", "content": cleaned},
      ],
    };

    final res =
    await http.post(uri, headers: headers, body: jsonEncode(body));

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("HTTP ${res.statusCode}: ${res.body}");
    }

    final data = jsonDecode(res.body);
    return data["choices"][0]["message"]["content"].toString().trim();
  }
}