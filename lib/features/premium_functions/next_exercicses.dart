import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/colors.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:ownproject/constants/text.dart';
import 'package:ownproject/features/premium_functions/widgets/exercise_header.dart';

class AiExerciseLabPage extends StatefulWidget {
  const AiExerciseLabPage({super.key});

  @override
  State<AiExerciseLabPage> createState() => _AiExerciseLabPageState();
}

class _AiExerciseLabPageState extends State<AiExerciseLabPage> {
  int _tab = 1;

  final PageController _pageController = PageController(initialPage: 1);

  void _changeTab(int v) {
    setState(() => _tab = v);

    _pageController.animateToPage(
      v,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final pageHPad = r.wp(0.06);
    final topPad = r.hp(0.014);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(height: r.hp(0.03)),

            /// HEADER
            Padding(
              padding: EdgeInsets.symmetric(horizontal: pageHPad),
              child: ExerciseHeader(
                title: "Simultaneously",
                subtitle: "Practice using this word in a sentence",
                tab: _tab,
                onTabChanged: _changeTab,
                onBack: () => context.pop(),
                onInfo: () {},
              ),
            ),

            SizedBox(height: r.hp(0.02)),

            /// SWIPE AREA
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _tab = index);
                },
                children: [

                  /// PAGE 1 (Write Yourself placeholder)
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        pageHPad,
                        topPad,
                        pageHPad,
                        r.hp(0.03),
                      ),
                      child:const SizedBox(),
                    ),
                  ),

                  /// PAGE 2 (AI GENERATE — your existing UI)
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        pageHPad,
                        topPad,
                        pageHPad,
                        r.hp(0.03),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          /// CHALLENGE GENERATION
                          _ChallengeCard(
                            quote:
                            "“The two heavy guns were fired\nsimultaneously.”",
                            onGenerate: () {},
                          ),

                          SizedBox(height: r.hp(0.016)),

                          /// FEEDBACK
                          _FeedbackCard(
                            draft:
                            "“e eat breakfast and watched TV\nsimultaneously.”",
                            mistakeText:
                            "Grammatical tense mismatch.\n"
                                "“eat” should be “ate” to match the past\n"
                                "tense context of the sentence.",
                          ),

                          SizedBox(height: r.hp(0.020)),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "OTHER CONTEXTS TO TRY",
                              style: TextStyle(
                                fontSize: r.text(14),
                                fontWeight:
                                AppText.appBarBadgeBold.fontWeight,
                                letterSpacing: 0.8,
                                color:
                                AppColors.titleGray.withOpacity(0.55),
                              ),
                            ),
                          ),

                          SizedBox(height: r.hp(0.010)),

                          _MiniContextCard(
                            label: "BUSINESS CONTEXT",
                            labelColor: AppColors.primary,
                            text:
                            "The software updates all global databases\nsimultaneously.",
                          ),

                          SizedBox(height: r.hp(0.010)),

                          _MiniContextCard(
                            label: "JOURNALISM CONTEXT",
                            labelColor: const Color(0xFF16A34A),
                            text:
                            "The news was released simultaneously in five languages.",
                          ),

                          SizedBox(height: r.hp(0.03)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// =========================
// TOP BAR WIDGETS
// =========================

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
    final size = r.adaptive(mobile: 40.0, tablet: 44.0, desktop: 46.0);

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

class _PillMiniLabel extends StatelessWidget {
  final String text;
  const _PillMiniLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(0.03),
        vertical: r.hp(0.007),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.barGray.withOpacity(0.9),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            size: r.text(14),
            color: AppColors.primary,
          ),
          SizedBox(width: r.wp(0.012)),
          Text(
            text,
            style: TextStyle(
              fontSize: r.text(11.5),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================
// SEGMENTED
// =========================

class _SegmentedSwitch extends StatelessWidget {
  final String left;
  final String right;
  final int value;
  final ValueChanged<int> onChanged;

  const _SegmentedSwitch({
    required this.left,
    required this.right,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final h = r.adaptive(mobile: 44.0, tablet: 48.0, desktop: 50.0);

    return Container(
      height: h,
      width: double.infinity,
      padding: EdgeInsets.all(r.wp(0.01)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.barGray.withOpacity(0.9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegBtn(
              text: left,
              active: value == 0,
              onTap: () => onChanged(0),
            ),
          ),
          SizedBox(width: r.wp(0.015)),
          Expanded(
            child: _SegBtn(
              text: right,
              active: value == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegBtn extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _SegBtn({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.black.withOpacity(0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: active
              ? Border.all(
            color: AppColors.barGray.withOpacity(0.9),
            width: 1,
          )
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: r.text(12),
            fontWeight: FontWeight.w800,
            color: AppColors.black.withOpacity(active ? 0.88 : 0.55),
          ),
        ),
      ),
    );
  }
}

// =========================
// CARDS (unchanged)
// =========================

class _ChallengeCard extends StatelessWidget {
  final String quote;
  final VoidCallback onGenerate;

  const _ChallengeCard({
    required this.quote,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        r.wp(0.045),
        r.hp(0.018),
        r.wp(0.045),
        r.hp(0.018),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.barGray.withOpacity(0.85),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CHALLENGE GENERATION",
            style: TextStyle(
              fontSize: r.text(14),
              fontWeight: AppText.titleBold.fontWeight,
              letterSpacing: 0.9,
              color: AppColors.primary.withOpacity(0.85),
            ),
          ),
          SizedBox(height: r.hp(0.012)),
          _QuoteWithHighlight(text: quote, highlight: "simultaneously"),
          SizedBox(height: r.hp(0.016)),
          _GradientButton(
            text: "Generate New Challenge",
            onTap: onGenerate,
          ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final String draft;
  final String mistakeText;

  const _FeedbackCard({
    required this.draft,
    required this.mistakeText,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        r.wp(0.045),
        r.hp(0.018),
        r.wp(0.045),
        r.hp(0.018),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFFFD6D6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cancel_rounded,
                  color: AppColors.barRed, size: r.text(18)),
              SizedBox(width: r.wp(0.02)),
              Text(
                "AI FEEDBACK",
                style: TextStyle(
                  fontSize: r.text(14),
                  fontWeight: AppText.titleBold.fontWeight,
                  letterSpacing: 0.9,
                  color: AppColors.barRed.withOpacity(0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: r.hp(0.012)),
          Text(
            draft,
            style: TextStyle(
              fontSize: r.text(16),
              fontWeight: AppText.cardTitleSemiBold.fontWeight,
              color: AppColors.barRed.withOpacity(0.85),
              height: 1.3,
            ),
          ),
          SizedBox(height: r.hp(0.012)),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: r.text(16),
                fontWeight: AppText.subtitleRegular.fontWeight,
                color: AppColors.barRed.withOpacity(0.85),
                height: 1.2,
              ),
              children: [
                const TextSpan(
                  text: "Mistake: ",
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                TextSpan(text: mistakeText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =========================
// ✅ MINI CONTEXT CARD (FIXED to match 1st image)
// =========================

class _MiniContextCard extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String text;

  const _MiniContextCard({
    required this.label,
    required this.labelColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        r.wp(0.045),
        r.hp(0.018),
        r.wp(0.045),
        r.hp(0.018),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.barGray.withOpacity(0.55),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: r.text(12),
              fontWeight: AppText.appBarBadgeBold.fontWeight,
              letterSpacing: 1.1,
              color: labelColor,
            ),
          ),
          SizedBox(height: r.hp(0.012)),
          _QuoteWithHighlight(
            text: text,
            highlight: "simultaneously",
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _GradientButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: r.adaptive(mobile: 52.0, tablet: 56.0, desktop: 58.0),
        decoration: BoxDecoration(
          gradient: AppColors.dailyPracticeGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.20),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.wp(0.05)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: r.text(16),
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.white,
                size: r.text(22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuoteWithHighlight extends StatelessWidget {
  final String text;
  final String highlight;

  const _QuoteWithHighlight({
    required this.text,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final parts = text.split(highlight);
    final baseStyle = TextStyle(
      fontSize: r.text(16),
      fontWeight: FontWeight.w600,
      color: AppColors.black.withOpacity(0.85),
      height: 1.3,
    );

    if (parts.length < 2) {
      return Text(text, style: baseStyle);
    }

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: highlight,
            style: baseStyle.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary.withOpacity(0.45),
            ),
          ),
          TextSpan(text: parts.sublist(1).join(highlight)),
        ],
      ),
    );
  }
}