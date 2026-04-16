import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:ownproject/features/premium_functions/widgets/exercise_header.dart';
import '../../constants/colors.dart';

class AiExercisePage extends StatefulWidget {
  const AiExercisePage({super.key});

  @override
  State<AiExercisePage> createState() => _AiExercisePageState();
}

class _AiExercisePageState extends State<AiExercisePage> {
  int _tab = 0;

  final _controller = TextEditingController();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _changeTab(int v) {
    setState(() => _tab = v);

    _pageController.animateToPage(
      v,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final pageHPad = r.wp(0.06);
    final topPad = r.hp(0.01);

    final bottomBarHeight =
    r.adaptive(mobile: 84.0, tablet: 92.0, desktop: 98.0);

    return Scaffold(
      backgroundColor: AppColors.background,

      /// BOTTOM BAR
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
                child: Row(
                  children: [
                    Expanded(
                      child: _SoftButton(
                        label: "Save Draft",
                        onTap: () {},
                      ),
                    ),
                    SizedBox(width: r.wp(0.04)),
                    Expanded(
                      flex: 2,
                      child: _GradientButton(
                        label: "Next Exercise",
                        onTap: () {},
                        iconRight: Icons.arrow_forward_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      /// BODY
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: r.hp(0.03)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: pageHPad),

              /// HEADER
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

            /// SWIPE PAGES
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _tab = index);
                },
                children: [

                  /// PAGE 1 — WRITE YOURSELF
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        pageHPad,
                        topPad,
                        pageHPad,
                        bottomBarHeight + r.hp(0.04),
                      ),
                      child: Column(
                        children: [
                          _DraftInputCard(
                            controller: _controller,
                            onCheck: () {},
                          ),

                          SizedBox(height: r.hp(0.02)),

                          _SuccessCard(
                            title: "Perfect usage!",
                            subtitle:
                            "The word matches the context and\ngrammar perfectly.",
                            badge: "+10 XP EARNED",
                          ),

                          SizedBox(height: r.hp(0.02)),

                          _CorrectionCard(
                            yourDraft:
                            "“She was singing and dancing\nsimultaneously with grace.”",
                            aiCorrection:
                            "“She sang and danced\nsimultaneously, moving with\ngrace.”",
                          ),

                          SizedBox(height: r.hp(0.02)),
                        ],
                      ),
                    ),
                  ),

                  /// PAGE 2 — AI GENERATE
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        pageHPad,
                        topPad,
                        pageHPad,
                        bottomBarHeight + r.hp(0.04),
                      ),
                      child: Column(
                        children: [
                          _SuccessCard(
                            title: "AI Generated Example",
                            subtitle:
                            "The assistant created a sentence\nusing the target word.",
                            badge: "AI MODE",
                          ),

                          SizedBox(height: r.hp(0.02)),

                          _CorrectionCard(
                            yourDraft:
                            "“The orchestra played multiple\nmelodies simultaneously.”",
                            aiCorrection:
                            "“Multiple melodies were played\nsimultaneously by the orchestra.”",
                          ),

                          SizedBox(height: r.hp(0.02)),
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
// WIDGETS
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
          border: Border.all(
            color: AppColors.barGray.withOpacity(0.7),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: r.text(22),
          color: AppColors.black.withOpacity(0.78),
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
        vertical: r.hp(0.006),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.barGray.withOpacity(0.85),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            size: r.text(16),
            color: AppColors.primary,
          ),
          SizedBox(width: r.wp(0.015)),
          Text(
            text,
            style: TextStyle(
              fontSize: r.text(12),
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  final String left;
  final String right;
  final int value; // 0 or 1
  final ValueChanged<int> onChanged;

  const _Segmented({
    required this.left,
    required this.right,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.wp(0.01)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.barGray.withOpacity(0.85),
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
      child: Row(
        children: [
          Expanded(
            child: _SegBtn(
              label: left,
              active: value == 0,
              onTap: () => onChanged(0),
            ),
          ),
          SizedBox(width: r.wp(0.01)),
          Expanded(
            child: _SegBtn(
              label: right,
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
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SegBtn({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: r.adaptive(mobile: 42.0, tablet: 46.0, desktop: 48.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.white : AppColors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(14),
          border: active
              ? Border.all(
            color: AppColors.barGray.withOpacity(0.9),
            width: 1,
          )
              : null,
          boxShadow: active
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 8),
            )
          ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: r.text(13),
            fontWeight: FontWeight.w700,
            color: AppColors.black.withOpacity(active ? 0.85 : 0.55),
          ),
        ),
      ),
    );
  }
}

class _DraftInputCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCheck;

  const _DraftInputCard({
    required this.controller,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        r.wp(0.045),
        r.hp(0.02),
        r.wp(0.045),
        r.hp(0.02),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.barGray.withOpacity(0.85),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // input
          Container(
            height: r.adaptive(mobile: 96.0, tablet: 108.0, desktop: 120.0),
            padding: EdgeInsets.symmetric(
              horizontal: r.wp(0.03),
              vertical: r.hp(0.012),
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.barGray.withOpacity(0.9),
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller,
              maxLines: null,
              style: TextStyle(
                fontSize: r.text(14),
                fontWeight: FontWeight.w600,
                color: AppColors.black.withOpacity(0.85),
                height: 1.35,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Draft a sentence using the word...",
                hintStyle: TextStyle(
                  fontSize: r.text(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.titleGray.withOpacity(0.45),
                ),
                isCollapsed: true,
              ),
            ),
          ),

          SizedBox(height: r.hp(0.015)),

          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onCheck,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: r.adaptive(mobile: 40.0, tablet: 44.0, desktop: 46.0),
                padding: EdgeInsets.symmetric(horizontal: r.wp(0.04)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_outlined,
                      size: r.text(18),
                      color: AppColors.primary,
                    ),
                    SizedBox(width: r.wp(0.02)),
                    Text(
                      "Check Usage",
                      style: TextStyle(
                        fontSize: r.text(13),
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;

  const _SuccessCard({
    required this.title,
    required this.subtitle,
    required this.badge,
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
        color: const Color(0xFFE9F9EF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFBDECCB).withOpacity(0.9),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: r.adaptive(mobile: 40.0, tablet: 44.0, desktop: 46.0),
            height: r.adaptive(mobile: 40.0, tablet: 44.0, desktop: 46.0),
            decoration: const BoxDecoration(
              color: Color(0xFF1DB954),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: AppColors.white,
              size: r.text(24),
            ),
          ),
          SizedBox(width: r.wp(0.035)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: r.text(15),
                    fontWeight: FontWeight.w900,
                    color: AppColors.black.withOpacity(0.85),
                  ),
                ),
                SizedBox(height: r.hp(0.004)),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: r.text(13),
                    fontWeight: FontWeight.w600,
                    color: AppColors.titleGray.withOpacity(0.7),
                    height: 1.35,
                  ),
                ),
                SizedBox(height: r.hp(0.01)),
                Text(
                  badge,
                  style: TextStyle(
                    fontSize: r.text(12),
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1DB954),
                    letterSpacing: 0.6,
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





class _CorrectionCard extends StatefulWidget {
  final String yourDraft;
  final String aiCorrection;

  const _CorrectionCard({
    required this.yourDraft,
    required this.aiCorrection,
  });

  @override
  State<_CorrectionCard> createState() => _CorrectionCardState();
}

class _CorrectionCardState extends State<_CorrectionCard>
    with TickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.barGray.withOpacity(0.85),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================
          // TOP PART (YOUR DRAFT)
          // ======================
          Padding(
            padding: EdgeInsets.fromLTRB(
              r.wp(0.045),
              r.hp(0.02),
              r.wp(0.045),
              r.hp(0.02),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MiniSectionTitle("YOUR DRAFT"),
                SizedBox(height: r.hp(0.01)),

                Text(
                  widget.yourDraft,
                  style: TextStyle(
                    fontSize: r.text(16),
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: AppColors.black.withOpacity(0.82),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // ======================
          // BOTTOM PART (AI CORRECTION)
          // ======================
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              r.wp(0.045),
              r.hp(0.02),
              r.wp(0.045),
              r.hp(0.02),
            ),
            decoration: BoxDecoration(
              color:  Color(0xFFEEF2FF),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MiniSectionTitle(
                  "AI CORRECTION",
                  accent: AppColors.primary,
                ),
                SizedBox(height: r.hp(0.01)),

                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: r.text(16),
                      fontWeight: FontWeight.w700,
                      color: AppColors.black.withOpacity(0.85),
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: "“She sang and danced\n"),
                      TextSpan(
                        text: "simultaneously",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(
                        text: ", moving with\ngrace.”",
                      ),
                    ],
                  ),
                ),

                SizedBox(height: r.hp(0.014)),

                // ======================
                // EXPAND BUTTON
                // ======================
                InkWell(
                  onTap: () {
                    setState(() => _expanded = !_expanded);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Why this is better?",
                        style: TextStyle(
                          fontSize: r.text(13.5),
                          fontWeight: FontWeight.w700,
                          color: AppColors.titleGray.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(width: r.wp(0.01)),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 250),
                        turns: _expanded ? 0.5 : 0.0,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: r.text(20),
                          color: AppColors.titleGray.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // ======================
                // EXPAND CONTENT
                // ======================
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _expanded
                      ? Padding(
                    padding: EdgeInsets.only(top: r.hp(0.012)),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(r.wp(0.035)),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                          AppColors.barGray.withOpacity(0.8),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "The correction uses past simple tense "
                            "('sang' and 'danced') which improves "
                            "clarity and structure. It also flows more "
                            "naturally in written English.",
                        style: TextStyle(
                          fontSize: r.text(13.5),
                          fontWeight: FontWeight.w600,
                          color: AppColors.titleGray
                              .withOpacity(0.75),
                          height: 1.4,
                        ),
                      ),
                    ),
                  )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




class _MiniSectionTitle extends StatelessWidget {
  final String text;
  final Color? accent;

  const _MiniSectionTitle(this.text, {this.accent});

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Text(
      text,
      style: TextStyle(
        fontSize: r.text(11.5),
        fontWeight: FontWeight.w900,
        letterSpacing: 0.9,
        color: (accent ?? AppColors.titleGray).withOpacity(0.55),
      ),
    );
  }
}

class _SoftButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SoftButton({
    required this.label,
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
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.barGray.withOpacity(0.9),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: r.text(14),
            fontWeight: FontWeight.w800,
            color: AppColors.black.withOpacity(0.78),
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? iconRight;

  const _GradientButton({
    required this.label,
    required this.onTap,
    this.iconRight,
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
              color: AppColors.primary.withOpacity(0.22),
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
                  label,
                  style: TextStyle(
                    fontSize: r.text(14.5),
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                  ),
                ),
              ),
              if (iconRight != null) ...[
                Icon(iconRight, color: AppColors.white, size: r.text(22)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}