import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ these are the SAME files/algorithms you already use in OfflineOcrScreen
import '../animation/analyzing_overlay.dart';
import '../models/ocr_lang.dart';
import '../models/ocr_models.dart';
import '../ocr/hit_test.dart';
import '../ocr/ocr_service.dart';
import '../painters/ocr_overlay_painter.dart';
import '../utils/image_utils.dart';


class CropScreen extends StatefulWidget {
  final File imageFile;
  const CropScreen({super.key, required this.imageFile});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

enum _Stage { cropping, analyzed }

class _CropScreenState extends State<CropScreen> {
  // ========= CROP IMAGE LOAD =========
  ui.Image? _img;
  String? _err;

  // crop rect in "image space" (pixels)
  Rect? _crop;

  // gesture state (crop)
  Offset? _startPt;
  Rect? _startRect;
  _Handle _activeHandle = _Handle.none;

  // ========= OCR/SELECTION (SAME AS OfflineOcrScreen) =========
  final _ocrService = OcrService();
  final TransformationController _tx = TransformationController();

  File? _croppedFile; // current cropped image that we OCR on
  Size? _imageSize; // size of cropped image in pixels
  OcrData? _ocr;

  bool _busy = false; // busy for "analyze" (crop+ocr)
  bool _busyOcr = false;
  String? _ocrError;

  // Source (OCR) language (keep simple here)
  OcrLang _lang = OcrLang.english;

  final Set<int> _selected = {};
  Offset? _lastTapGlobal;
  OverlayEntry? _toolbar;

  bool _rangeSelecting = false;
  int? _rangeAnchorIdx;

  _Stage _stage = _Stage.cropping;

  @override
  void initState() {
    super.initState();
    _loadOriginal();
  }

  Future<void> _loadOriginal() async {
    try {
      final bytes = await widget.imageFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final img = frame.image;

      if (!mounted) return;
      setState(() {
        _img = img;

        // default crop: centered 82%
        final w = img.width.toDouble();
        final h = img.height.toDouble();
        final cw = w * 0.82;
        final ch = h * 0.82;
        _crop = Rect.fromLTWH((w - cw) / 2, (h - ch) / 2, cw, ch);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = "Image load failed: $e");
    }
  }

  @override
  void dispose() {
    _hideToolbar();
    _tx.dispose();
    _img?.dispose();
    super.dispose();
  }

  // =========================
  // UI HELPERS
  // =========================
  double get _currentScale {
    final s = _tx.value.getMaxScaleOnAxis();
    if (s.isFinite && s > 0) return s;
    return 1.0;
  }

  void _resetSelectionAndOcrUi() {
    _hideToolbar();
    _selected.clear();
    _rangeSelecting = false;
    _rangeAnchorIdx = null;
    _ocrError = null;
    _ocr = null;
  }

  // =========================
  // ✅ MAIN ACTION: crop -> analyze (MLKit) -> show words selectable
  // =========================
  Future<void> _done() async {
    final img = _img;
    final crop = _crop;
    if (img == null || crop == null || _busy) return;

    setState(() {
      _busy = true;
      _busyOcr = true;
      _ocrError = null;
    });

    _resetSelectionAndOcrUi();

    try {
      // 1) crop to file (same as your old CropScreen)
      final clamped =
      _clampRect(crop, img.width.toDouble(), img.height.toDouble());
      final outPngBytes = await _cropToPng(img, clamped);

      final dir = await Directory.systemTemp.createTemp('crop_');
      final croppedFile = File(
          '${dir.path}/crop_${DateTime.now().millisecondsSinceEpoch}.png');
      await croppedFile.writeAsBytes(outPngBytes, flush: true);

      if (!mounted) return;

      // 2) set cropped file as "current image" to display
      setState(() {
        _croppedFile = croppedFile;
        _stage = _Stage.analyzed; // UI switches to OCR view (same screen)
        _tx.value = Matrix4.identity();
      });

      // 3) run OCR on cropped file (SAME service + models)
      await _runOcrOnCropped(croppedFile);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _ocrError = "OCR failed: $e";
        _stage = _Stage.cropping; // fallback to cropping
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _busyOcr = false;
        });
      }
    }
  }

  Future<void> _runOcrOnCropped(File file) async {
    try {
      // same decode as OfflineOcrScreen
      final bytes = await file.readAsBytes();
      final ui.Image img = await decodeUiImage(Uint8List.fromList(bytes));
      _imageSize = Size(img.width.toDouble(), img.height.toDouble());

      final data = await _ocrService.run(file, _lang);
      if (!mounted) return;
      setState(() => _ocr = data);
    } catch (e) {
      if (!mounted) return;
      setState(() => _ocrError = "OCR failed: $e");
    }
  }

  void _backToCrop() {
    if (_busy) return;
    _resetSelectionAndOcrUi();
    setState(() {
      _stage = _Stage.cropping;
      _croppedFile = null;
      _imageSize = null;
      _tx.value = Matrix4.identity();
    });
  }

  // =========================
  // CROP MATH (SAME AS BEFORE)
  // =========================
  Rect _clampRect(Rect r, double w, double h) {
    final minSize = 40.0;
    final left = r.left.clamp(0.0, w - minSize);
    final top = r.top.clamp(0.0, h - minSize);
    final right = r.right.clamp(left + minSize, w);
    final bottom = r.bottom.clamp(top + minSize, h);
    return Rect.fromLTRB(left, top, right, bottom);
  }

  Future<Uint8List> _cropToPng(ui.Image img, Rect crop) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final dst = Rect.fromLTWH(0, 0, crop.width, crop.height);
    canvas.drawImageRect(img, crop, dst, Paint());

    final pic = recorder.endRecording();
    final outImg = await pic.toImage(crop.width.round(), crop.height.round());
    final bd = await outImg.toByteData(format: ui.ImageByteFormat.png);
    outImg.dispose();
    pic.dispose();

    if (bd == null) throw Exception("Encode failed");
    return bd.buffer.asUint8List();
  }

  // Convert view (screen) point -> image point (for crop handles)
  Offset _toImagePoint(Offset local, Size viewSize) {
    final img = _img!;
    final iw = img.width.toDouble();
    final ih = img.height.toDouble();

    // Fit by width (your “photo-like” crop preview)
    final scale = viewSize.width / iw;
    final drawnW = iw * scale;
    final drawnH = ih * scale;
    final dx = (viewSize.width - drawnW) / 2;
    final dy = (viewSize.height - drawnH) / 2;

    final x = ((local.dx - dx) / scale).clamp(0.0, iw);
    final y = ((local.dy - dy) / scale).clamp(0.0, ih);
    return Offset(x, y);
  }

  _Handle _hitHandle(Rect r, Offset p) {
    const pad = 26.0;
    final tl = (p - r.topLeft).distance;
    final tr = (p - r.topRight).distance;
    final bl = (p - r.bottomLeft).distance;
    final br = (p - r.bottomRight).distance;

    double best = tl;
    _Handle h = _Handle.tl;

    if (tr < best) {
      best = tr;
      h = _Handle.tr;
    }
    if (bl < best) {
      best = bl;
      h = _Handle.bl;
    }
    if (br < best) {
      best = br;
      h = _Handle.br;
    }

    if (best <= pad) return h;
    if (r.contains(p)) return _Handle.move;
    return _Handle.none;
  }

  Rect _applyHandle(Rect base, _Handle h, Offset delta) {
    const minSize = 60.0;
    Rect r = base;

    switch (h) {
      case _Handle.move:
        r = r.shift(delta);
        break;
      case _Handle.tl:
        r = Rect.fromLTRB(
            r.left + delta.dx, r.top + delta.dy, r.right, r.bottom);
        break;
      case _Handle.tr:
        r = Rect.fromLTRB(
            r.left, r.top + delta.dy, r.right + delta.dx, r.bottom);
        break;
      case _Handle.bl:
        r = Rect.fromLTRB(
            r.left + delta.dx, r.top, r.right, r.bottom + delta.dy);
        break;
      case _Handle.br:
        r = Rect.fromLTRB(
            r.left, r.top, r.right + delta.dx, r.bottom + delta.dy);
        break;
      case _Handle.none:
        break;
    }

    // normalize + min size
    final left = min(r.left, r.right - minSize);
    final top = min(r.top, r.bottom - minSize);
    final right = max(r.right, left + minSize);
    final bottom = max(r.bottom, top + minSize);

    return Rect.fromLTRB(left, top, right, bottom);
  }

  // =========================
  // SELECTION HELPERS (SAME AS OfflineOcrScreen)
  // =========================
  Set<int> _rangeSelectionIndices(OcrData ocr, int aIdx, int bIdx) {
    final order = ocr.readingOrder;
    if (order.isEmpty) return {aIdx, bIdx};

    final pos = <int, int>{};
    for (int p = 0; p < order.length; p++) {
      pos[order[p]] = p;
    }

    final pa = pos[aIdx];
    final pb = pos[bIdx];
    if (pa == null || pb == null) return {aIdx, bIdx};

    final lo = min(pa, pb);
    final hi = max(pa, pb);

    final out = <int>{};
    for (int p = lo; p <= hi; p++) {
      out.add(order[p]);
    }
    return out;
  }

  String _getSelectedCsv() {
    final ocr = _ocr;
    if (ocr == null || _selected.isEmpty) return "";

    final pos = <int, int>{};
    for (int i = 0; i < ocr.readingOrder.length; i++) {
      pos[ocr.readingOrder[i]] = i;
    }

    final idxs = _selected.toList()
      ..sort((a, b) => (pos[a] ?? 1 << 30).compareTo(pos[b] ?? 1 << 30));

    final out = <String>[];
    for (final i in idxs) {
      if (i < 0 || i >= ocr.words.length) continue;
      final t = ocr.words[i].text.trim();
      if (t.isNotEmpty) out.add(t);
    }

    return out.join(", ");
  }

  Future<void> _copySelectedCsv() async {
    final csv = _getSelectedCsv();
    if (csv.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: csv));
    _hideToolbar();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied: ${csv.length > 60 ? '${csv.substring(0, 60)}...' : csv}',
        ),
      ),
    );
  }

  // =========================
  // TOOLBAR (only Copy + Clear — nothing else moved)
  // =========================
  void _showToolbar() {
    _hideToolbar();
    if (_lastTapGlobal == null) return;

    final csv = _getSelectedCsv();
    if (csv.isEmpty) return;

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final pos = _lastTapGlobal!;
    _toolbar = OverlayEntry(
      builder: (_) {
        return Positioned(
          left: max(8, pos.dx - 140),
          top: max(8, pos.dy - 70),
          child: Material(
            color: Colors.transparent,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.88),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 18,
                    offset: Offset(0, 8),
                    color: Color(0x33000000),
                  ),
                ],
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _toolbarBtn("Copy", onTap: _copySelectedCsv),
                    _divider(),
                    _toolbarBtn("Clear", onTap: _clearSelection),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_toolbar!);
  }

  Widget _divider() =>
      Container(width: 1, height: 18, color: Colors.white.withOpacity(0.25));

  Widget _toolbarBtn(String text, {required VoidCallback onTap}) {
    final disabled = _busyOcr || _busy;
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(disabled ? 0.55 : 1.0),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _hideToolbar() {
    _toolbar?.remove();
    _toolbar = null;
  }

  void _clearSelection() {
    setState(() {
      _selected.clear();
      _rangeSelecting = false;
      _rangeAnchorIdx = null;
    });
    _hideToolbar();
  }

  // =========================
  // BUILD
  // =========================
  @override
  Widget build(BuildContext context) {
    final img = _img;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: img == null
            ? Center(
          child: _err == null
              ? const CircularProgressIndicator()
              : Text(_err!, style: const TextStyle(color: Colors.black)),
        )
            : Stack(
          children: [
            // main content depends on stage
            Positioned.fill(
              child: _stage == _Stage.cropping
                  ? _buildCroppingView(img)
                  : _buildOcrView(),
            ),

            // top controls (always)
            Positioned(
              left: 12,
              top: 12,
              child: _CircleBtn(
                icon: Icons.close,
                onTap: _busy ? null : () => Navigator.pop(context),
              ),
            ),

            // right button:
            // - cropping: ✅ analyze
            // - analyzed: ✏️ back to crop
            Positioned(
              right: 12,
              top: 12,
              child: _CircleBtn(
                icon: _busy
                    ? Icons.hourglass_top
                    : (_stage == _Stage.cropping
                    ? Icons.check
                    : Icons.crop),
                onTap: _busy
                    ? null
                    : (_stage == _Stage.cropping ? _done : _backToCrop),
                showSpinner: _busy,
              ),
            ),

            // error (OCR) if any (simple, no extra UI moved)
            if (_ocrError != null && _stage == _Stage.analyzed)
              Positioned(
                left: 12,
                right: 12,
                bottom: 18,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.withOpacity(0.35)),
                  ),
                  child: Text(
                    _ocrError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

            // ✅ analyzing animation overlay (runs until MLKit finishes)
            if (_busyOcr) const AnalyzingOverlay(title: "Analyzing"),
          ],
        ),
      ),
    );
  }

  // =========================
  // CROPPING VIEW (your “photo-like” preview)
  // =========================
  Widget _buildCroppingView(ui.Image img) {
    return LayoutBuilder(
      builder: (context, c) {
        final viewSize = Size(c.maxWidth, c.maxHeight);

        return GestureDetector(
          onPanStart: (d) {
            final crop = _crop;
            if (crop == null) return;
            final p = _toImagePoint(d.localPosition, viewSize);
            _activeHandle = _hitHandle(crop, p);
            _startPt = p;
            _startRect = crop;
          },
          onPanUpdate: (d) {
            final startPt = _startPt;
            final startRect = _startRect;
            if (startPt == null || startRect == null) return;
            if (_activeHandle == _Handle.none) return;

            final p = _toImagePoint(d.localPosition, viewSize);
            final delta = p - startPt;

            final imgW = img.width.toDouble();
            final imgH = img.height.toDouble();

            final next = _clampRect(
              _applyHandle(startRect, _activeHandle, delta),
              imgW,
              imgH,
            );
            setState(() => _crop = next);
          },
          onPanEnd: (_) {
            _activeHandle = _Handle.none;
            _startPt = null;
            _startRect = null;
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: SizedBox(
                  width: viewSize.width,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: img.width.toDouble(),
                      height: img.height.toDouble(),
                      child: RawImage(image: img),
                    ),
                  ),
                ),
              ),
              if (_crop != null)
                CustomPaint(
                  painter: _CropPainterFitWidth(
                    imageSize: Size(img.width.toDouble(), img.height.toDouble()),
                    viewSize: viewSize,
                    crop: _crop!,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // =========================
  // OCR VIEW (same selection logic as OfflineOcrScreen)
  // =========================
  Widget _buildOcrView() {
    final file = _croppedFile;
    if (file == null) {
      // fallback
      return const Center(child: Text("No cropped image", style: TextStyle(color: Colors.black)));
    }

    final ocr = _ocr;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, c) {
            final viewportSize = Size(c.maxWidth, c.maxHeight);

            return Stack(
              fit: StackFit.expand,
              children: [
                InteractiveViewer(
                  transformationController: _tx,
                  minScale: 1.0,
                  maxScale: 10.0,
                  panEnabled: !_rangeSelecting,
                  scaleEnabled: true,
                  child: SizedBox(
                    width: viewportSize.width,
                    height: viewportSize.height,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // IMPORTANT: keep same BoxFit.contain as OfflineOcrScreen
                        Image.file(file, fit: BoxFit.contain),
                        CustomPaint(
                          painter: OcrOverlayPainter(
                            words: ocr?.words ?? const [],
                            selected: _selected,
                            imageSize: _imageSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // selection gestures (SAME as OfflineOcrScreen)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapDown: (d) {
                      if (ocr == null || _imageSize == null) return;

                      _lastTapGlobal = d.globalPosition;

                      final scene = _tx.toScene(d.localPosition);
                      final idx = hitTestWordSceneSmart(
                        tapScene: scene,
                        childSize: viewportSize,
                        imageSize: _imageSize!,
                        words: ocr.words,
                        scale: _currentScale,
                      );

                      if (idx == null) {
                        setState(() => _selected.clear());
                        _hideToolbar();
                        return;
                      }

                      setState(() {
                        if (_selected.contains(idx)) {
                          _selected.remove(idx);
                        } else {
                          _selected.add(idx);
                        }
                      });

                      if (_selected.isEmpty) {
                        _hideToolbar();
                      } else {
                        _showToolbar();
                      }
                    },
                    onLongPressStart: (d) {
                      if (ocr == null || _imageSize == null) return;

                      _hideToolbar();

                      final scene = _tx.toScene(d.localPosition);
                      final idx = hitTestWordSceneSmart(
                        tapScene: scene,
                        childSize: viewportSize,
                        imageSize: _imageSize!,
                        words: ocr.words,
                        scale: _currentScale,
                      );

                      if (idx == null) return;

                      setState(() {
                        _rangeSelecting = true;
                        _rangeAnchorIdx = idx;
                        _selected
                          ..clear()
                          ..addAll(_rangeSelectionIndices(ocr, idx, idx));
                      });
                    },
                    onLongPressMoveUpdate: (d) {
                      if (!_rangeSelecting || ocr == null || _imageSize == null) return;

                      final scene = _tx.toScene(d.localPosition);
                      final idx = hitTestWordSceneSmart(
                        tapScene: scene,
                        childSize: viewportSize,
                        imageSize: _imageSize!,
                        words: ocr.words,
                        scale: _currentScale,
                      );

                      if (idx == null) return;
                      final a = _rangeAnchorIdx;
                      if (a == null) return;

                      setState(() {
                        _selected
                          ..clear()
                          ..addAll(_rangeSelectionIndices(ocr, a, idx));
                      });
                    },
                    onLongPressEnd: (_) {
                      if (!_rangeSelecting) return;

                      _lastTapGlobal = null; // optional
                      setState(() => _rangeSelecting = false);

                      if (_selected.isEmpty) {
                        _hideToolbar();
                      } else {
                        _showToolbar();
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

enum _Handle { none, move, tl, tr, bl, br }

// ✅ crop overlay painter (unchanged)
class _CropPainterFitWidth extends CustomPainter {
  final Size imageSize;
  final Size viewSize;
  final Rect crop;

  _CropPainterFitWidth({
    required this.imageSize,
    required this.viewSize,
    required this.crop,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = viewSize.width / imageSize.width;
    final drawnW = imageSize.width * scale;
    final drawnH = imageSize.height * scale;
    final dx = (viewSize.width - drawnW) / 2;
    final dy = (viewSize.height - drawnH) / 2;

    Rect toView(Rect r) => Rect.fromLTRB(
      dx + r.left * scale,
      dy + r.top * scale,
      dx + r.right * scale,
      dy + r.bottom * scale,
    );

    final cropView = toView(crop);

    final overlay = Path()..addRect(Offset.zero & viewSize);
    final hole = Path()..addRRect(RRect.fromRectXY(cropView, 10, 10));
    final diff = Path.combine(PathOperation.difference, overlay, hole);

    canvas.drawPath(diff, Paint()..color = Colors.black.withOpacity(0.50));

    canvas.drawRRect(
      RRect.fromRectXY(cropView, 10, 10),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    const hs = 10.0;
    final p = Paint()..color = Colors.white;
    canvas.drawCircle(cropView.topLeft, hs, p);
    canvas.drawCircle(cropView.topRight, hs, p);
    canvas.drawCircle(cropView.bottomLeft, hs, p);
    canvas.drawCircle(cropView.bottomRight, hs, p);
  }

  @override
  bool shouldRepaint(covariant _CropPainterFitWidth oldDelegate) {
    return oldDelegate.crop != crop ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.viewSize != viewSize;
  }
}

// ✅ same circle button you already had
class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool showSpinner;

  const _CircleBtn({
    required this.icon,
    required this.onTap,
    this.showSpinner = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(disabled ? 0.25 : 0.45),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: showSpinner
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}