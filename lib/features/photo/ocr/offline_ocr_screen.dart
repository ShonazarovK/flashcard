// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ownproject/constants/responsivness.dart';
//
// import '../../../constants/colors.dart';
// import '../animation/analyzing_overlay.dart';
// import '../camera/capture_screen.dart';
// import '../crop/crop_screen.dart';
// import '../models/ocr_lang.dart';
// import '../models/ocr_models.dart';
// import '../painters/ocr_overlay_painter.dart';
// import '../utils/image_utils.dart';
// import '../utils/translation_api_key.dart';
// import 'hit_test.dart';
// import 'ocr_service.dart';
//
// class OfflineOcrScreen extends StatefulWidget {
//   final bool autoStart;
//
//   /// ✅ NEW: if passed, the screen shows this image and starts OCR automatically
//   final File? initialImageFile;
//
//   const OfflineOcrScreen({
//     super.key,
//     this.autoStart = false,
//     this.initialImageFile,
//   });
//
//   @override
//   State<OfflineOcrScreen> createState() => _OfflineOcrScreenState();
// }
//
// class _OfflineOcrScreenState extends State<OfflineOcrScreen> {
//   final _picker = ImagePicker();
//   final _ocrService = OcrService();
//
//   bool _didAutoStart = false;
//
//   File? _imageFile;
//   Size? _imageSize;
//   OcrData? _ocr;
//
//   bool _busyOcr = false;
//   String? _ocrError;
//
//   // Source (OCR) language
//   OcrLang _lang = OcrLang.english;
//
//   // Target translation language
//   OcrLang _targetLang = OcrLang.russian;
//
//   final Set<int> _selected = {};
//   Offset? _lastTapGlobal;
//
//   OverlayEntry? _toolbar;
//
//   bool _rangeSelecting = false;
//   int? _rangeAnchorIdx;
//
//   final TransformationController _tx = TransformationController();
//
//   // =========================
//   // TRANSLATION (OpenRouter)
//   // =========================
//   late final OpenRouterTranslateService _translator;
//   bool _busyTranslate = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _translator = OpenRouterTranslateService(
//       apiKey:
//       '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',
//       httpReferer: "https://snapiq.app",
//       xTitle: "Snapiq OCR",
//       model: "openai/gpt-4o-mini",
//     );
//
//     // ✅ NEW: if coming from CropScreen, auto-run OCR on that file
//     final incoming = widget.initialImageFile;
//     if (incoming != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         if (!mounted) return;
//         setState(() => _imageFile = incoming);
//         _tx.value = Matrix4.identity();
//         await _runOcr(incoming);
//       });
//     }
//
//     if (widget.autoStart) {
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         if (!mounted || _didAutoStart) return;
//         _didAutoStart = true;
//         await _openCameraThenCrop();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _hideToolbar();
//     _tx.dispose();
//     super.dispose();
//   }
//
//   double get _currentScale {
//     final s = _tx.value.getMaxScaleOnAxis();
//     if (s.isFinite && s > 0) return s;
//     return 1.0;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final file = _imageFile;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         centerTitle: true,
//         elevation: 0,
//         titleSpacing: 0,
//         leading: BackButton(
//           color: AppColors.black,
//           onPressed: () {
//             context.go('/');
//           },
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (v) async {
//               if (v == "camera") await _openCameraThenCrop();
//               if (v == "gallery") await _pickFromGallery();
//               if (v == "clear") _clearAll();
//             },
//             itemBuilder: (_) => const [
//               PopupMenuItem(value: "camera", child: Text("📷 Camera (crop)")),
//               PopupMenuItem(value: "gallery", child: Text("🖼️ Gallery")),
//               PopupMenuDivider(),
//               PopupMenuItem(value: "clear", child: Text("Clear")),
//             ],
//           )
//         ],
//       ),
//
//       // ✅ NEW: Stack so analyzing overlay can sit above everything
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               _topControls(context),
//               const Divider(height: 1),
//               Expanded(
//                 child: file == null
//                     ? _emptyState(context)
//                     : _imageCanvas(context, file),
//               ),
//             ],
//           ),
//
//           // ✅ NEW: show analyzing animation while OCR is running
//           if (_busyOcr) const AnalyzingOverlay(title: "Analyzing"),
//         ],
//       ),
//     );
//   }
//
//   // =========================
//   // TOP CONTROLS
//   // =========================
//   Widget _topControls(BuildContext context) {
//     final r = context.r;
//
//     final double padH = r.adaptive(mobile: 12, tablet: 14, desktop: 16);
//     final double padV = r.adaptive(mobile: 10, tablet: 12, desktop: 14);
//     final double gap = r.adaptive(mobile: 10, tablet: 12, desktop: 14);
//
//     return Padding(
//       padding: EdgeInsets.fromLTRB(padH, padV, padH, padV),
//       child: Column(
//         children: [
//           _languageBar(context),
//           SizedBox(height: gap),
//           Wrap(
//             spacing: gap,
//             runSpacing: gap,
//             crossAxisAlignment: WrapCrossAlignment.center,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: _busyOcr ? null : _openCameraThenCrop,
//                 icon: const Icon(Icons.photo_camera_outlined),
//                 label: Text("Camera", style: TextStyle(fontSize: r.text(14))),
//               ),
//               OutlinedButton.icon(
//                 onPressed: _busyOcr ? null : _pickFromGallery,
//                 icon: const Icon(Icons.photo_library_outlined),
//                 label: Text("Gallery", style: TextStyle(fontSize: r.text(14))),
//               ),
//             ],
//           ),
//           if (_ocrError != null) ...[
//             const SizedBox(height: 10),
//             Text(
//               _ocrError!,
//               style: TextStyle(
//                 color: Colors.red,
//                 fontSize: r.text(13),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _languageBar(BuildContext context) {
//     final r = context.r;
//     final disabled = _busyOcr || _busyTranslate;
//
//     return ClipRRect(
//       borderRadius:
//       BorderRadius.circular(r.adaptive(mobile: 14, tablet: 16, desktop: 18)),
//       child: Material(
//         color: Colors.black.withOpacity(0.08),
//         child: SizedBox(
//           height: r.adaptive(mobile: 52, tablet: 56, desktop: 60),
//           child: Row(
//             children: [
//               Expanded(
//                 child: _langSideButton(
//                   context,
//                   label: _lang.label.toUpperCase(),
//                   onTap: disabled ? null : () => _pickLanguage(isSource: true),
//                   alignLeft: true,
//                 ),
//               ),
//               SizedBox(
//                 width: r.adaptive(mobile: 60, tablet: 64, desktop: 68),
//                 child: Center(
//                   child: IconButton(
//                     onPressed: disabled ? null : _swapLanguages,
//                     icon: const Icon(Icons.swap_horiz),
//                     tooltip: "Swap",
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: _langSideButton(
//                   context,
//                   label: _targetLang.label.toUpperCase(),
//                   onTap: disabled ? null : () => _pickLanguage(isSource: false),
//                   alignLeft: false,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _langSideButton(
//       BuildContext context, {
//         required String label,
//         required VoidCallback? onTap,
//         required bool alignLeft,
//       }) {
//     final r = context.r;
//
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding:
//         EdgeInsets.symmetric(horizontal: r.adaptive(mobile: 14, tablet: 16, desktop: 18)),
//         child: Align(
//           alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
//           child: Row(
//             mainAxisAlignment:
//             alignLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
//             children: [
//               if (!alignLeft) ...[
//                 Icon(Icons.keyboard_arrow_down,
//                     size: r.adaptive(mobile: 20, tablet: 22, desktop: 24)),
//                 const SizedBox(width: 6),
//               ],
//               Flexible(
//                 child: Text(
//                   label,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: r.text(14),
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 0.6,
//                   ),
//                 ),
//               ),
//               if (alignLeft) ...[
//                 const SizedBox(width: 6),
//                 Icon(Icons.keyboard_arrow_down,
//                     size: r.adaptive(mobile: 20, tablet: 22, desktop: 24)),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _pickLanguage({required bool isSource}) async {
//     final selected = await showModalBottomSheet<OcrLang>(
//       context: context,
//       showDragHandle: true,
//       builder: (_) {
//         return SafeArea(
//           child: ListView.separated(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             itemCount: OcrLang.values.length,
//             separatorBuilder: (_, __) => const Divider(height: 1),
//             itemBuilder: (_, i) {
//               final lang = OcrLang.values[i];
//               final current = isSource ? _lang : _targetLang;
//               final isActive = lang == current;
//
//               return ListTile(
//                 title: Text(lang.label),
//                 trailing: isActive ? const Icon(Icons.check) : null,
//                 onTap: () => Navigator.pop(context, lang),
//               );
//             },
//           ),
//         );
//       },
//     );
//
//     if (selected == null) return;
//
//     if (isSource) {
//       if (selected == _lang) return;
//       setState(() => _lang = selected);
//
//       // ✅ OCR re-run if source language changes
//       if (_imageFile != null) await _runOcr(_imageFile!);
//     } else {
//       if (selected == _targetLang) return;
//       setState(() => _targetLang = selected);
//     }
//   }
//
//   Future<void> _swapLanguages() async {
//     final a = _lang;
//     final b = _targetLang;
//
//     setState(() {
//       _lang = b;
//       _targetLang = a;
//     });
//
//     // OCR re-run on swap
//     if (_imageFile != null) {
//       await _runOcr(_imageFile!);
//     }
//   }
//
//   // =========================
//   // EMPTY STATE
//   // =========================
//   Widget _emptyState(BuildContext context) {
//     final r = context.r;
//
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(r.adaptive(mobile: 18, tablet: 22, desktop: 26)),
//         child: Text(
//           "Camera -> crop (❌/✅)\nOCR runs on cropped image\nTap/Long-press selection\nCopy CSV\nTranslate (OpenRouter)",
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//             fontSize: r.text(16),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // =========================
//   // IMAGE + OCR OVERLAY
//   // =========================
//   Widget _imageCanvas(BuildContext context, File file) {
//     final ocr = _ocr;
//     final r = context.r;
//
//     return Padding(
//       padding: EdgeInsets.all(r.adaptive(mobile: 12, tablet: 14, desktop: 16)),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(
//           r.adaptive(mobile: 14, tablet: 18, desktop: 20),
//         ),
//         child: LayoutBuilder(
//           builder: (context, c) {
//             final viewportSize = Size(c.maxWidth, c.maxHeight);
//
//             return Stack(
//               fit: StackFit.expand,
//               children: [
//                 InteractiveViewer(
//                   transformationController: _tx,
//                   minScale: 1.0,
//                   maxScale: 10.0,
//                   panEnabled: !_rangeSelecting,
//                   scaleEnabled: true,
//                   child: SizedBox(
//                     width: viewportSize.width,
//                     height: viewportSize.height,
//                     child: Stack(
//                       fit: StackFit.expand,
//                       children: [
//                         Image.file(file, fit: BoxFit.contain),
//                         CustomPaint(
//                           painter: OcrOverlayPainter(
//                             words: ocr?.words ?? const [],
//                             selected: _selected,
//                             imageSize: _imageSize,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: GestureDetector(
//                     behavior: HitTestBehavior.translucent,
//                     onTapDown: (d) {
//                       if (ocr == null || _imageSize == null) return;
//
//                       _lastTapGlobal = d.globalPosition;
//
//                       final scene = _tx.toScene(d.localPosition);
//                       final idx = hitTestWordSceneSmart(
//                         tapScene: scene,
//                         childSize: viewportSize,
//                         imageSize: _imageSize!,
//                         words: ocr.words,
//                         scale: _currentScale,
//                       );
//
//                       if (idx == null) {
//                         setState(() => _selected.clear());
//                         _hideToolbar();
//                         return;
//                       }
//
//                       setState(() {
//                         if (_selected.contains(idx)) {
//                           _selected.remove(idx);
//                         } else {
//                           _selected.add(idx);
//                         }
//                       });
//
//                       if (_selected.isEmpty) {
//                         _hideToolbar();
//                       } else {
//                         _showToolbar();
//                       }
//                     },
//                     onLongPressStart: (d) {
//                       if (ocr == null || _imageSize == null) return;
//
//                       _hideToolbar();
//
//                       final scene = _tx.toScene(d.localPosition);
//                       final idx = hitTestWordSceneSmart(
//                         tapScene: scene,
//                         childSize: viewportSize,
//                         imageSize: _imageSize!,
//                         words: ocr.words,
//                         scale: _currentScale,
//                       );
//
//                       if (idx == null) return;
//
//                       setState(() {
//                         _rangeSelecting = true;
//                         _rangeAnchorIdx = idx;
//                         _selected
//                           ..clear()
//                           ..addAll(_rangeSelectionIndices(ocr, idx, idx));
//                       });
//                     },
//                     onLongPressMoveUpdate: (d) {
//                       if (!_rangeSelecting || ocr == null || _imageSize == null) return;
//
//                       final scene = _tx.toScene(d.localPosition);
//                       final idx = hitTestWordSceneSmart(
//                         tapScene: scene,
//                         childSize: viewportSize,
//                         imageSize: _imageSize!,
//                         words: ocr.words,
//                         scale: _currentScale,
//                       );
//
//                       if (idx == null) return;
//                       final a = _rangeAnchorIdx;
//                       if (a == null) return;
//
//                       setState(() {
//                         _selected
//                           ..clear()
//                           ..addAll(_rangeSelectionIndices(ocr, a, idx));
//                       });
//                     },
//                     onLongPressEnd: (d) {
//                       if (!_rangeSelecting) return;
//
//                       _lastTapGlobal = d.globalPosition;
//
//                       setState(() {
//                         _rangeSelecting = false;
//                       });
//
//                       if (_selected.isEmpty) {
//                         _hideToolbar();
//                       } else {
//                         _showToolbar();
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // =========================
//   // CAMERA / GALLERY / OCR
//   // =========================
//   Future<void> _openCameraThenCrop() async {
//     if (_busyOcr) return;
//
//     _hideToolbar();
//
//     setState(() {
//       _ocrError = null;
//       _ocr = null;
//       _selected.clear();
//       _rangeSelecting = false;
//       _rangeAnchorIdx = null;
//     });
//
//     final XFile? raw = await Navigator.of(context).push<XFile?>(
//       MaterialPageRoute(builder: (_) => const CaptureScreen()),
//     );
//     if (raw == null) return;
//
//     final File? cropped = await Navigator.of(context).push<File?>(
//       MaterialPageRoute(builder: (_) => CropScreen(imageFile: File(raw.path))),
//     );
//     if (cropped == null) return;
//
//     setState(() => _imageFile = cropped);
//     _tx.value = Matrix4.identity();
//
//     await _runOcr(cropped);
//   }
//
//   Future<void> _pickFromGallery() async {
//     if (_busyOcr) return;
//
//     _hideToolbar();
//
//     setState(() {
//       _ocrError = null;
//       _ocr = null;
//       _selected.clear();
//       _rangeSelecting = false;
//       _rangeAnchorIdx = null;
//     });
//
//     final XFile? picked = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 95,
//     );
//     if (picked == null) return;
//
//     final file = File(picked.path);
//     setState(() => _imageFile = file);
//     _tx.value = Matrix4.identity();
//
//     await _runOcr(file);
//   }
//
//   Future<void> _runOcr(File file) async {
//     _hideToolbar();
//
//     setState(() {
//       _busyOcr = true;
//       _ocrError = null;
//       _ocr = null;
//       _selected.clear();
//       _rangeSelecting = false;
//       _rangeAnchorIdx = null;
//     });
//
//     try {
//       final bytes = await file.readAsBytes();
//       final ui.Image img = await decodeUiImage(Uint8List.fromList(bytes));
//       _imageSize = Size(img.width.toDouble(), img.height.toDouble());
//
//       final data = await _ocrService.run(file, _lang);
//       if (!mounted) return;
//
//       setState(() => _ocr = data);
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _ocrError = "OCR failed: $e");
//     } finally {
//       if (mounted) setState(() => _busyOcr = false);
//     }
//   }
//
//   // =========================
//   // SELECTION HELPERS
//   // =========================
//   Set<int> _rangeSelectionIndices(OcrData ocr, int aIdx, int bIdx) {
//     final order = ocr.readingOrder;
//     if (order.isEmpty) return {aIdx, bIdx};
//
//     final pos = <int, int>{};
//     for (int p = 0; p < order.length; p++) {
//       pos[order[p]] = p;
//     }
//
//     final pa = pos[aIdx];
//     final pb = pos[bIdx];
//     if (pa == null || pb == null) return {aIdx, bIdx};
//
//     final lo = min(pa, pb);
//     final hi = max(pa, pb);
//
//     final out = <int>{};
//     for (int p = lo; p <= hi; p++) {
//       out.add(order[p]);
//     }
//     return out;
//   }
//
//   List<String> _getSelectedTokens() {
//     final ocr = _ocr;
//     if (ocr == null || _selected.isEmpty) return const [];
//
//     final pos = <int, int>{};
//     for (int i = 0; i < ocr.readingOrder.length; i++) {
//       pos[ocr.readingOrder[i]] = i;
//     }
//
//     final idxs = _selected.toList()
//       ..sort((a, b) => (pos[a] ?? 1 << 30).compareTo(pos[b] ?? 1 << 30));
//
//     final out = <String>[];
//     for (final i in idxs) {
//       if (i < 0 || i >= ocr.words.length) continue;
//       final t = ocr.words[i].text.trim();
//       if (t.isNotEmpty) out.add(t);
//     }
//
//     return out;
//   }
//
//   String _getSelectedCsv() {
//     final tokens = _getSelectedTokens();
//     if (tokens.isEmpty) return "";
//     return tokens.join(", ");
//   }
//
//   // =========================
//   // TRANSLATE (SOURCE -> TARGET)
//   // =========================
//   Future<void> _translateSelected() async {
//     if (_busyOcr || _busyTranslate) return;
//
//     final tokens = _getSelectedTokens();
//     if (tokens.isEmpty) return;
//
//     if ('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'
//         .trim()
//         .isEmpty) {
//       _hideToolbar();
//       if (!mounted) return;
//
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text("OpenRouter token missing"),
//           content: const Text("Put your token into utils/translation_api_key.dart"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("OK"),
//             ),
//           ],
//         ),
//       );
//       return;
//     }
//
//     final text = tokens.join(" ");
//     setState(() => _busyTranslate = true);
//     _hideToolbar();
//
//     try {
//       final out = await _translator.translate(
//         text: text,
//         sourceLang: _lang,
//         targetLang: _targetLang,
//       );
//       if (!mounted) return;
//
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text("Translation (${_targetLang.label})"),
//           content: SelectableText(out),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 await Clipboard.setData(ClipboardData(text: out));
//                 if (!mounted) return;
//                 Navigator.pop(context);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Copied translation")),
//                 );
//               },
//               child: const Text("Copy"),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Close"),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Translate failed: $e")),
//       );
//     } finally {
//       if (mounted) setState(() => _busyTranslate = false);
//     }
//   }
//
//   // =========================
//   // TOOLBAR
//   // =========================
//   void _showToolbar() {
//     _hideToolbar();
//     if (_lastTapGlobal == null) return;
//
//     final csv = _getSelectedCsv();
//     if (csv.isEmpty) return;
//
//     final overlay = Overlay.of(context);
//     if (overlay == null) return;
//
//     final pos = _lastTapGlobal!;
//     _toolbar = OverlayEntry(
//       builder: (_) {
//         return Positioned(
//           left: max(8, pos.dx - 170),
//           top: max(8, pos.dy - 70),
//           child: Material(
//             color: Colors.transparent,
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.88),
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: const [
//                   BoxShadow(
//                     blurRadius: 18,
//                     offset: Offset(0, 8),
//                     color: Color(0x33000000),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     _toolbarBtn("Translate", onTap: _translateSelected),
//                     _divider(),
//                     _toolbarBtn("Copy CSV", onTap: _copySelectedCsv),
//                     _divider(),
//                     _toolbarBtn("Clear", onTap: _clearSelection),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//
//     overlay.insert(_toolbar!);
//   }
//
//   Widget _divider() =>
//       Container(width: 1, height: 18, color: Colors.white.withOpacity(0.25));
//
//   Widget _toolbarBtn(String text, {required VoidCallback onTap}) {
//     final disabled = _busyOcr || _busyTranslate;
//
//     return InkWell(
//       onTap: disabled ? null : onTap,
//       borderRadius: BorderRadius.circular(10),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: Colors.white.withOpacity(disabled ? 0.55 : 1.0),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _hideToolbar() {
//     _toolbar?.remove();
//     _toolbar = null;
//   }
//
//   void _clearSelection() {
//     setState(() {
//       _selected.clear();
//       _rangeSelecting = false;
//       _rangeAnchorIdx = null;
//     });
//     _hideToolbar();
//   }
//
//   Future<void> _copySelectedCsv() async {
//     final csv = _getSelectedCsv();
//     if (csv.isEmpty) return;
//
//     await Clipboard.setData(ClipboardData(text: csv));
//     _hideToolbar();
//     if (!mounted) return;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Copied CSV: ${csv.length > 60 ? '${csv.substring(0, 60)}...' : csv}',
//         ),
//       ),
//     );
//   }
//
//   void _clearAll() {
//     _hideToolbar();
//     setState(() {
//       _imageFile = null;
//       _imageSize = null;
//       _ocr = null;
//       _ocrError = null;
//       _busyOcr = false;
//       _selected.clear();
//       _rangeSelecting = false;
//       _rangeAnchorIdx = null;
//     });
//   }
// }