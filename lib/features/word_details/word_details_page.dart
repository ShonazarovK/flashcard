import 'package:flutter/material.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:ownproject/constants/text.dart';
import 'package:ownproject/features/word_details/widgets/bottombar_wg.dart';
import 'package:ownproject/features/word_details/widgets/premiumcard_wg.dart';
import '../../constants/colors.dart';

class WordDetails extends StatefulWidget {
  const WordDetails({super.key});

  @override
  State<WordDetails> createState() => _WordDetailsState();
}

class _WordDetailsState extends State<WordDetails> {
  int _currentStep = 1;

  void _setStep(int step) {
    if (step < 1 || step > 4) return;
    setState(() => _currentStep = step);
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final bottomBarHeight =
    r.adaptive(mobile: 96.0, tablet: 104.0, desktop: 110.0);

    final pageHPad = r.wp(0.06);
    final pageTPad = r.hp(0.01);

    return Scaffold(
      backgroundColor: AppColors.background, 
      floatingActionButton: null,
      floatingActionButtonLocation: null,

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: AppColors.white,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.barGray.withOpacity(0.9),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 18,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                pageHPad,
                r.hp(0.012),
                pageHPad,
                r.hp(0.012),
              ),
              child: SizedBox(
                height: bottomBarHeight,
                child: WordProgressBar(
                  currentStep: _currentStep,
                  onForget: () {
                    _setStep(1);
                  },
                  onSave: () {},
                  onStepTap: (step) => _setStep(step),
                ),
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              pageHPad,
              pageTPad,
              pageHPad,
              bottomBarHeight + r.hp(0.03),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================
                // HEADER
                // =========================
                Row(
                  children: [
                    _CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.maybePop(context),
                    ),
                    const Spacer(),
                    _CircleIconButton(
                      icon: Icons.share,
                      onTap: () {},
                    ),
                  ],
                ),

                SizedBox(height: r.hp(0.014)),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.wp(0.032),
                    vertical: r.hp(0.006),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    "C1 ADVANCED",
                    style: TextStyle(
                      fontSize: r.text(12),
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                SizedBox(height: r.hp(0.012)),

                Text(
                  "Simultaneously",
                  style: TextStyle(
                    fontSize: r.text(34),
                    fontWeight: AppText.appBarBadgeBold.fontWeight,
                    color: AppColors.black.withOpacity(0.88),
                    height: 1.05,
                  ),
                ),

                SizedBox(height: r.hp(0.012)),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "adverb",
                          style: TextStyle(
                            fontSize: r.text(14),
                            fontStyle: FontStyle.italic,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: r.wp(0.04)),
                        _PhoneticLine(
                          label: "UK",
                          phonetic: "/ˌsɪm.əlˈteɪ.ni.əs.li/",
                          onAudio: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: r.hp(0.006)),
                    _PhoneticLine(
                      label: "US",
                      phonetic: "/ˌsaɪ.məlˈteɪ.ni.əs.li/",
                      onAudio: () {},
                    ),
                  ],
                ),

                SizedBox(height: r.hp(0.014)),

                Row(
                  children: [
                    _SmallPill(
                      bg: AppColors.warning.withOpacity(0.16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flash_on_rounded,
                            size: r.text(16),
                            color: AppColors.warning,
                          ),
                          SizedBox(width: r.wp(0.012)),
                          Text(
                            "Mastered",
                            style: TextStyle(
                              fontSize: r.text(13),
                              fontWeight: FontWeight.w700,
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: r.wp(0.03)),
                    _SmallPill(
                      bg: AppColors.black.withOpacity(0.05),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            size: r.text(16),
                            color: AppColors.black.withOpacity(0.8),
                          ),
                          SizedBox(width: r.wp(0.02)),
                          Text(
                            "Add to word list",
                            style: TextStyle(
                              fontSize: r.text(13),
                              fontWeight: FontWeight.w700,
                              color: AppColors.black.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // =========================
                // DEFINITION
                // =========================
                SizedBox(height: r.hp(0.04)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: r.wp(0.02)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DEFINITION",
                        style: TextStyle(
                          fontSize: r.text(12),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          color: AppColors.titleGray.withOpacity(0.55),
                        ),
                      ),
                      SizedBox(height: r.hp(0.016)),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: r.text(16),
                            color: AppColors.black.withOpacity(0.86),
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(text: "in a way that is "),
                            TextSpan(
                              text: "simultaneous",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                AppColors.primary.withOpacity(0.55),
                              ),
                            ),
                            const TextSpan(
                              text:
                              " (= happening or being done at exactly the same time):",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: r.hp(0.025)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 3,
                            height: r.hp(0.13),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: r.wp(0.04)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "“Two children answered the teacher’s question simultaneously.”",
                                  style: TextStyle(
                                    fontSize: r.text(14),
                                    height: 1.4,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.titleGray.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: r.hp(0.02)),
                                Text(
                                  "“The network was broadcasting four games\nsimultaneously across the country.”",
                                  style: TextStyle(
                                    fontSize: r.text(14),
                                    height: 1.4,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.titleGray.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // =========================
                // SYNONYMS
                // =========================
                SizedBox(height: r.hp(0.035)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: r.wp(0.02)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "SYNONYMS",
                            style: TextStyle(
                              fontSize: r.text(14),
                              fontWeight: AppText.titleBold.fontWeight,
                              letterSpacing: 0.8,
                              color: AppColors.black.withOpacity(0.9),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: r.wp(0.012),
                                vertical: r.hp(0.006),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "English",
                                    style: TextStyle(
                                      fontSize: r.text(13),
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(width: r.wp(0.012)),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: r.text(18),
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: r.hp(0.02)),
                      _SynRow(tag: "n.", text: "Concurrently", onAdd: () {}),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: r.hp(0.016)),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.gray,
                        ),
                      ),
                      _SynRow(tag: null, text: "At once", onAdd: () {}),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: r.hp(0.016)),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: r.hp(0.02)),
                const AiExerciseLabCard(onGenerate: null),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================
// Helper Widgets (o‘zgartirmadim)
// =====================

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    const size = 40.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.black.withOpacity(0.04),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: r.text(22),
          color: AppColors.black.withOpacity(0.80),
        ),
      ),
    );
  }
}

class _PhoneticLine extends StatelessWidget {
  final String label;
  final String phonetic;
  final VoidCallback onAudio;

  const _PhoneticLine({
    required this.label,
    required this.phonetic,
    required this.onAudio,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: r.text(13),
            fontWeight: FontWeight.w700,
            color: AppColors.titleGray.withOpacity(0.9),
          ),
        ),
        SizedBox(width: r.wp(0.02)),
        Flexible(
          child: Text(
            phonetic,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: r.text(13),
              fontWeight: FontWeight.w500,
              color: AppColors.titleGray.withOpacity(0.85),
            ),
          ),
        ),
        SizedBox(width: r.wp(0.015)),
        InkWell(
          onTap: onAudio,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.all(r.wp(0.01)),
            child: Icon(
              Icons.volume_up_rounded,
              size: r.text(18),
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  final Color bg;
  final Widget child;

  const _SmallPill({
    required this.bg,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(0.035),
        vertical: r.hp(0.008),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: child,
    );
  }
}

class _SynRow extends StatelessWidget {
  final String? tag;
  final String text;
  final VoidCallback onAdd;

  const _SynRow({
    required this.tag,
    required this.text,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return SizedBox(
      height: r.adaptive(mobile: 52.0, tablet: 56.0, desktop: 58.0),
      child: Row(
        children: [
          if (tag != null) ...[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: r.wp(0.02),
                vertical: r.hp(0.004),
              ),
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                tag!,
                style: TextStyle(
                  fontSize: r.text(11),
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(width: r.wp(0.025)),
          ],
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: r.text(16),
                  fontWeight: AppText.Medium.fontWeight,
                  color: AppColors.black.withOpacity(0.9),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: AppColors.white,
                size: r.text(22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}