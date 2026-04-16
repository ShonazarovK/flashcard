import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';
import '../../constants/colors.dart';
import '../../constants/text.dart';

enum KeepMode { image, sound }

class KeepAnalyzeScreen extends StatefulWidget {
  final KeepMode mode;

  /// image mode uchun preview (kamera rasm / gallery rasm)
  /// sound mode uchun null bo‘lsa ham bo‘ladi
  final ImageProvider? previewImage;

  const KeepAnalyzeScreen({
    super.key,
    required this.mode,
    this.previewImage,
  });

  @override
  State<KeepAnalyzeScreen> createState() => _KeepAnalyzeScreenState();
}

class _KeepAnalyzeScreenState extends State<KeepAnalyzeScreen> {
  Timer? _timer;
  double progress = 0.12;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 220), (t) {
      if (!mounted) return;

      setState(() {
        progress = (progress + 0.06).clamp(0.0, 1.0);
      });

      if (progress >= 1.0) {
        t.cancel();

        // Demo results
        final results = <KeepWordItem>[
          const KeepWordItem(
            id: "w1",
            word: "Simultaneously",
            type: "Noun",
            level: "B2",
            ipa: "səˌmʌlˈteɪ.ni.əs.li",
            description: "happening or done at the same time as something else",
          ),
          const KeepWordItem(
            id: "w2",
            word: "Simultaneously",
            type: "Noun",
            level: "C1",
            ipa: "səˌmʌlˈteɪ.ni.əs.li",
            description: "happening or done at the same time as something else",
          ),
        ];

        // ✅ 100% bo‘lsa avtomatik results pagega o‘tadi (keyin yoqasiz)
        Future.microtask(() {
          if (!mounted) return;
          context.goNamed('keepResults', extra: results);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        leading: BackButton(
          color: AppColors.black,
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Keep",
          style: AppText.cardTitleSemiBold.copyWith(
            fontSize: r.text(20),
            color: AppColors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.wp(0.06)),
        child: Column(
          children: [
            SizedBox(height: r.text(10)),
            _AnalyzingCard(
              mode: widget.mode,
              progress: progress,
              previewImage: widget.previewImage,
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// ===================== ANALYZING CARD ===================
// =======================================================
class _AnalyzingCard extends StatelessWidget {
  final KeepMode mode;
  final double progress;
  final ImageProvider? previewImage;

  const _AnalyzingCard({
    required this.mode,
    required this.progress,
    this.previewImage,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    // rasmdagi card ~332x86
    final double cardH = r.text(86);

    // chap blok: rasmlarda chap tomondagi area taxm. 90-100px
    final double leftW = r.text(92);

    // ring o‘lchami rasmlarda ~52-56 ga yaqin ko‘rinadi
    final double ringSize = r.text(52);

    return Container(
      width: double.infinity,
      height: cardH,
      padding: EdgeInsets.symmetric(horizontal: r.text(14), vertical: r.text(10)),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.gray.withOpacity(0.4), width: 1),
      ),
      child: Row(
        children: [
          // ================= LEFT SIDE (finite size!) =================
          SizedBox(
            width: leftW,
            height: cardH - r.text(20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (mode == KeepMode.image)
                // ✅ preview image (rasmdagidek chapda)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: leftW,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: AppColors.barGray,
                        image: previewImage != null
                            ? DecorationImage(
                          image: previewImage!,
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                    ),
                  ),

                // ✅ mode icon (chap tepada)
                Positioned(
                  left: 0,
                  top: 0,
                  child: Icon(
                    mode == KeepMode.sound ? Icons.graphic_eq : Icons.image,
                    size: r.text(18),
                    color: AppColors.collection,
                  ),
                ),

                // ✅ ring overlay (sound bo‘lsa chap blok markazida,
                // image bo‘lsa preview ustida)
                Positioned(
                  left: mode == KeepMode.sound ? (leftW - ringSize) / 2 : r.text(10),
                  top: mode == KeepMode.sound ? ((cardH - r.text(20) - ringSize) / 2) : r.text(6),
                  child: SizedBox(
                    width: ringSize,
                    height: ringSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: ringSize,
                          height: ringSize,
                          child: _ProgressRing(value: progress),
                        ),
                        Text(
                          "${(progress * 100).round()}%",
                          style: AppText.appBarBadgeBold.copyWith(
                            fontSize: r.text(12),
                            color: mode == KeepMode.image
                                ? AppColors.white
                                : AppColors.collection,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: r.text(12)),

          // ================= RIGHT SIDE =================
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: r.text(16),
                      color: AppColors.titleGray,
                    ),
                    SizedBox(width: r.text(6)),
                    Flexible(
                      child: Text(
                        mode == KeepMode.sound
                            ? "Analyzing sound..."
                            : "Analyzing text...",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.cardTitleSemiBold.copyWith(
                          fontSize: r.text(14),
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: r.text(6)),
                _SkeletonLine(w: r.wp(0.52), h: r.text(6)),

                SizedBox(height: r.text(6)),
                _SkeletonLine(w: r.wp(0.28), h: r.text(6)),

                SizedBox(height: r.text(6)),
                Text(
                  "We will notify you when done!",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.subtitleRegular.copyWith(
                    fontSize: r.text(12),
                    color: AppColors.textGray,
                    height: 1.05,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double w;
  final double h;
  const _SkeletonLine({required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: AppColors.barGray,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final double value;
  const _ProgressRing({required this.value});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value.clamp(0.0, 1.0),
      strokeWidth: 5,
      backgroundColor: AppColors.barGray,
      valueColor: const AlwaysStoppedAnimation(AppColors.collection),
    );
  }
}

// =======================================================
// ======================== MODEL =========================
// =======================================================
class KeepWordItem {
  final String id;
  final String word;
  final String type;
  final String level;
  final String ipa;
  final String description;

  const KeepWordItem({
    required this.id,
    required this.word,
    required this.type,
    required this.level,
    required this.ipa,
    required this.description,
  });
}
