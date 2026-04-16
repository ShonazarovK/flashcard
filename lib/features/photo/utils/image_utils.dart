import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

Future<ui.Image> decodeUiImage(Uint8List bytes) {
  final c = Completer<ui.Image>();
  try {
    ui.decodeImageFromList(bytes, (ui.Image img) {
      if (!c.isCompleted) c.complete(img);
    });
  } catch (e, st) {
    if (!c.isCompleted) c.completeError(e, st);
  }
  return c.future;
}
