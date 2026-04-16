import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ownproject/constants/colors.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:ownproject/constants/text.dart';

// =======================================================
// Shared helpers
// =======================================================

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: r.wp(0.06)),
      padding: EdgeInsets.fromLTRB(
        r.wp(0.05),
        r.hp(0.02),
        r.wp(0.05),
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
            color: AppColors.barGray.withOpacity(0.55),
            blurRadius: 26,
            spreadRadius: 1,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BadgePill extends StatelessWidget {
  final String text;
  const _BadgePill(this.text);

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(0.03),
        vertical: r.hp(0.006),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: r.text(14),
            color: AppColors.primary,
          ),
          SizedBox(width: r.wp(0.012)),
          Text(
            text,
            style: TextStyle(
              fontSize: r.text(11),
              fontWeight: FontWeight.w900,
              color: AppColors.primary.withOpacity(0.9),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Text(
      text,
      style: TextStyle(
        fontSize: r.text(10.5),
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
        color: AppColors.titleGray.withOpacity(0.55),
      ),
    );
  }
}

Future<void> _showPracticeResultSheet({
  required BuildContext context,
  required bool isCorrect,
  String? correctSolution,
  Future<void> Function()? onSuccessAuto,
  VoidCallback? onWrongContinue,
}) async {
  final r = context.r;

  const successColor = Color(0xFF7BEFB3);
  const errorColor = Color(0xFFE72B2E);

  return showModalBottomSheet<void>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      if (isCorrect) {
        Future.delayed(const Duration(milliseconds: 900), () async {
          if (Navigator.of(sheetContext).canPop()) {
            Navigator.of(sheetContext).pop();
          }
          if (onSuccessAuto != null) {
            await onSuccessAuto();
          }
        });
      }

      return SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            border: Border(
              top: BorderSide(
                color: isCorrect ? successColor : errorColor,
                width: 1.2,
              ),
              left: BorderSide(
                color: isCorrect ? successColor : errorColor,
                width: 1.2,
              ),
              right: BorderSide(
                color: isCorrect ? successColor : errorColor,
                width: 1.2,
              ),
            ),
          ),
          child: isCorrect
              ? Padding(
            padding: EdgeInsets.fromLTRB(
              r.wp(0.055),
              r.hp(0.018),
              r.wp(0.055),
              r.hp(0.026),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Excellent!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: r.text(18),
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                    height: 1.0,
                  ),
                ),
                SizedBox(height: r.hp(0.032)),
                Container(
                  width: double.infinity,
                  height: r.adaptive(
                    mobile: 56,
                    tablet: 58,
                    desktop: 60,
                  ),
                  decoration: BoxDecoration(
                    color: successColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: r.text(16),
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          )
              : Padding(
            padding: EdgeInsets.fromLTRB(
              r.wp(0.055),
              r.hp(0.020),
              r.wp(0.055),
              r.hp(0.026),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Not Quit Right",
                  style: TextStyle(
                    fontSize: r.text(18),
                    fontWeight: FontWeight.w700,
                    color: errorColor,
                    height: 1.05,
                  ),
                ),
                SizedBox(height: r.hp(0.006)),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: r.text(18),
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                      height: 1.15,
                    ),
                    children: [
                      const TextSpan(text: "Correct Solution: "),
                      TextSpan(
                        text: correctSolution ?? "",
                        style: const TextStyle(
                          color: errorColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: r.hp(0.028)),
                InkWell(
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onWrongContinue?.call();
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    height: r.adaptive(
                      mobile: 56,
                      tablet: 58,
                      desktop: 60,
                    ),
                    decoration: BoxDecoration(
                      color: errorColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: r.text(16),
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
// =======================================================
// 1) Identify Meaning (MCQ)
// =======================================================

class IdentifyMeaningStep extends StatefulWidget {
  final String badgeText;
  final String progressText;
  final String title;
  final String word;
  final List<String> options;
  final int correctIndex;
  final VoidCallback onComplete;

  const IdentifyMeaningStep({
    super.key,
    required this.badgeText,
    required this.progressText,
    required this.title,
    required this.word,
    required this.options,
    required this.correctIndex,
    required this.onComplete,
  });

  @override
  State<IdentifyMeaningStep> createState() => _IdentifyMeaningStepState();
}

class _IdentifyMeaningStepState extends State<IdentifyMeaningStep> {
  int? selected;
  bool locked = false;

  Future<void> _handleSelect(int index) async {
    if (locked) return;

    setState(() {
      selected = index;
      locked = true;
    });

    final correct = index == widget.correctIndex;

    await _showPracticeResultSheet(
      context: context,
      isCorrect: correct,
      correctSolution:
      "${String.fromCharCode(65 + widget.correctIndex)}) ${widget.options[widget.correctIndex]}",
      onSuccessAuto: () async {
        widget.onComplete();
      },
      onWrongContinue: () {
        if (!mounted) return;
        setState(() {
          selected = null;
          locked = false;
        });
      },
    );

    if (correct && mounted) {
      setState(() => locked = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: r.hp(0.04)),
        child: _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _BadgePill(widget.badgeText),
                  const Spacer(),
                  Text(
                    widget.progressText,
                    style: TextStyle(
                      fontSize: r.text(12),
                      fontWeight: FontWeight.w800,
                      color: AppColors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: r.hp(0.02)),
              Center(child: _SectionTitle(widget.title)),
              SizedBox(height: r.hp(0.01)),
              Center(
                child: Text(
                  widget.word,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: r.text(28),
                    fontWeight: FontWeight.w800,
                    color: AppColors.black.withOpacity(0.9),
                  ),
                ),
              ),
              SizedBox(height: r.hp(0.02)),
              ...List.generate(widget.options.length, (i) {
                final isSelected = selected == i;

                return Padding(
                  padding: EdgeInsets.only(bottom: r.hp(0.020)),
                  child: InkWell(
                    onTap: locked ? null : () => _handleSelect(i),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.wp(0.04),
                        vertical: r.hp(0.020),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.75)
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.barGray.withOpacity(0.95),
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.18),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${String.fromCharCode(65 + i)}) ${widget.options[i]}",
                              style: TextStyle(
                                fontSize: r.text(14),
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.titleGray,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================================================
// 2) Usage Memory (fill blank)
// =======================================================

class UsageMemoryStep extends StatefulWidget {
  final String badgeText;
  final String progressText;
  final String sentencePrefix;
  final String sentenceSuffix;
  final List<String> choices;
  final String correct;
  final VoidCallback onComplete;

  const UsageMemoryStep({
    super.key,
    required this.badgeText,
    required this.progressText,
    required this.sentencePrefix,
    required this.sentenceSuffix,
    required this.choices,
    required this.correct,
    required this.onComplete,
  });

  @override
  State<UsageMemoryStep> createState() => _UsageMemoryStepState();
}

class _UsageMemoryStepState extends State<UsageMemoryStep> {
  String? picked;
  bool locked = false;

  Future<void> _handlePick(String value) async {
    if (locked) return;

    setState(() {
      picked = value;
      locked = true;
    });

    final correct = value == widget.correct;

    await _showPracticeResultSheet(
      context: context,
      isCorrect: correct,
      correctSolution: widget.correct,
      onSuccessAuto: () async {
        widget.onComplete();
      },
      onWrongContinue: () {
        if (!mounted) return;
        setState(() {
          picked = null;
          locked = false;
        });
      },
    );

    if (correct && mounted) {
      setState(() => locked = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: r.hp(0.03)),
        child: _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _BadgePill(widget.badgeText),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: r.text(16),
                        color: AppColors.titleGray.withOpacity(0.6),
                      ),
                      SizedBox(width: r.wp(0.012)),
                      Text(
                        widget.progressText,
                        style: TextStyle(
                          fontSize: r.text(12),
                          fontWeight: FontWeight.w800,
                          color: AppColors.titleGray.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: r.hp(0.02)),

              Text(
                "${widget.sentencePrefix}  ________  ${widget.sentenceSuffix}",
                style: TextStyle(
                  fontSize: r.text(19),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  height: 1.4,
                ),
              ),

              SizedBox(height: r.hp(0.02)),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.choices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: r.wp(0.04),
                  mainAxisSpacing: r.hp(0.020),
                  childAspectRatio: r.adaptive(
                    mobile: 2.25,
                    tablet: 2.6,
                    desktop: 2.9,
                  ),
                ),
                itemBuilder: (context, index) {
                  final c = widget.choices[index];
                  final active = picked == c;

                  return InkWell(
                    onTap: locked ? null : () => _handlePick(c),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: r.wp(0.02),
                        vertical: r.hp(0.008),
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary.withOpacity(0.75)
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: active
                              ? Colors.transparent
                              : AppColors.barGray.withOpacity(0.95),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        c,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: r.text(14),
                          fontWeight: FontWeight.w700,
                          color: active
                              ? AppColors.white
                              : AppColors.black.withOpacity(0.7),
                          height: 1.2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================================================
// 3) Matching pairs
// =======================================================

class MatchingPairsStep extends StatefulWidget {
  final List<String> left;
  final List<String> right;
  final VoidCallback onComplete;

  const MatchingPairsStep({
    super.key,
    required this.left,
    required this.right,
    required this.onComplete,
  });

  @override
  State<MatchingPairsStep> createState() => _MatchingPairsStepState();
}
class _MatchingPairsStepState extends State<MatchingPairsStep> {
  String? pickedLeft;
  final Set<int> matchedLeft = {};
  final Set<int> matchedRight = {};
  bool locked = false;

  List<String> get _left => widget.left;
  List<String> get _right => widget.right;

  int? _pickedLeftIndex;

  bool _isMatchedPair(int lIndex, int rIndex) {
    return widget.left[lIndex] == widget.right[rIndex];
  }

  Future<void> _handleRightTap(int rIndex) async {
    if (locked || _pickedLeftIndex == null || matchedRight.contains(rIndex)) return;

    final lIndex = _pickedLeftIndex!;
    final correct = _isMatchedPair(lIndex, rIndex);

    if (correct) {
      setState(() {
        matchedLeft.add(lIndex);
        matchedRight.add(rIndex);
        _pickedLeftIndex = null;
      });

      final totalPairs = min(_left.length, _right.length);

      final allDone = matchedLeft.length == totalPairs;

      if (allDone) {
        locked = true;

        await _showPracticeResultSheet(
          context: context,
          isCorrect: true,
          onSuccessAuto: () async {
            widget.onComplete();
          },
        );

        if (mounted) locked = false;
      }
    } else {
      setState(() => locked = true);

      await _showPracticeResultSheet(
        context: context,
        isCorrect: false,
        correctSolution: widget.left[lIndex],
        onWrongContinue: () {
          if (!mounted) return;
          setState(() {
            _pickedLeftIndex = null;
            locked = false;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: r.hp(0.03),right:r.hp(0.03),left:r.hp(0.03), ),
          child: Row(
            children: [

              /// LEFT
              Expanded(
                child: Column(
                  children: List.generate(_left.length, (i) {
                    final isMatched = matchedLeft.contains(i);
                    final active = _pickedLeftIndex == i;

                    return Padding(
                      padding: EdgeInsets.only(bottom: r.hp(0.012)),
                      child: _PairPill(
                        text: _left[i],
                        active: active,
                        matched: isMatched,
                        onTap: isMatched || locked
                            ? null
                            : () => setState(() => _pickedLeftIndex = i),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(width: r.wp(0.04)),

              /// RIGHT
              Expanded(
                child: Column(
                  children: List.generate(_right.length, (i) {
                    final isMatched = matchedRight.contains(i);

                    return Padding(
                      padding: EdgeInsets.only(bottom: r.hp(0.012)),
                      child: _PairPill(
                        text: _right[i],
                        active: false,
                        matched: isMatched,
                        onTap: isMatched || locked
                            ? null
                            : () => _handleRightTap(i),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
      ),
    );
  }
}

class _PairPill extends StatelessWidget {
  final String text;
  final bool active;
  final bool matched;
  final VoidCallback? onTap;

  const _PairPill({
    required this.text,
    required this.active,
    required this.matched,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final bg = matched
        ? AppColors.primary.withOpacity(0.75)
        : (active ? AppColors.primary.withOpacity(0.25) : AppColors.white);

    final fg = matched ? AppColors.white : AppColors.black.withOpacity(0.8);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: r.wp(0.04),
          vertical: r.hp(0.020),
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: matched
                ? Colors.transparent
                : AppColors.barGray.withOpacity(0.95),
            width: 1,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: r.text(14),
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }
}

// =======================================================
// 4) Translate
// =======================================================

class TranslateStep extends StatefulWidget {
  final String titleTop;
  final String word;
  final String hint;
  final String correctAnswer;
  final VoidCallback onComplete;

  const TranslateStep({
    super.key,
    required this.titleTop,
    required this.word,
    required this.hint,
    required this.correctAnswer,
    required this.onComplete,
  });

  @override
  State<TranslateStep> createState() => _TranslateStepState();
}

class _TranslateStepState extends State<TranslateStep> {
  final _c = TextEditingController();
  bool locked = false;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    if (locked) return;

    final input = _c.text.trim();
    if (input.isEmpty) return;

    setState(() => locked = true);

    final ok = input.toLowerCase() == widget.correctAnswer.toLowerCase();

    await _showPracticeResultSheet(
      context: context,
      isCorrect: ok,
      correctSolution: widget.correctAnswer,
      onSuccessAuto: () async {
        widget.onComplete();
      },
      onWrongContinue: () {
        if (!mounted) return;
        setState(() {
          locked = false;
          _c.clear();
        });
      },
    );

    if (ok && mounted) {
      setState(() => locked = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.wp(0.06)),
      child: Column(
        children: [

          SizedBox(height: r.hp(0.07)),

          /// TITLE
          Text(
            widget.titleTop.toUpperCase(),
            style: TextStyle(
              fontSize: r.text(10),
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: AppColors.titleGray.withOpacity(0.6),
            ),
          ),

          SizedBox(height: r.hp(0.02)),

          /// WORD
          Text(
            widget.word,
            style: TextStyle(
              fontSize: r.text(36),
              fontWeight: FontWeight.w700,
              color: AppColors.black.withOpacity(0.9),
            ),
          ),

          SizedBox(height: r.hp(0.012)),

          Container(
            width: r.wp(0.12),
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.barGray.withOpacity(0.8),
              borderRadius: BorderRadius.circular(999),
            ),
          ),

          SizedBox(height: r.hp(0.04)),

          /// INPUT
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: r.wp(0.04),
              vertical: r.hp(0.009),
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.55),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _c,
              enabled: !locked,
              textAlign: TextAlign.center,
              onSubmitted: (_) => _check(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.correctAnswer,
              ),
              style: TextStyle(
                fontSize: r.text(20),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(height: r.hp(0.01)),

          /// HINT
          Text(
            widget.hint,
            style: TextStyle(
              fontSize: r.text(14),
              fontWeight: FontWeight.w700,
              color: AppColors.primary.withOpacity(0.75),
            ),
          ),

          const Spacer(),


          SizedBox(height: r.hp(0.02)),

          /// BUTTON
          InkWell(
            onTap: locked ? null : _check,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: r.hp(0.065),
              decoration: BoxDecoration(
                gradient: AppColors.dailyPracticeGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                "Check Answer",
                style: TextStyle(
                  fontSize: r.text(16),
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: r.hp(0.02)),
        ],
      ),
    );
  }
}
// =======================================================
// 3) Listen and choose
// =======================================================

class ListenChooseStep extends StatefulWidget {
  final List<String> options;
  final int correctIndex;
  final VoidCallback onComplete;

  const ListenChooseStep({
    super.key,
    required this.options,
    required this.correctIndex,
    required this.onComplete,
  });

  @override
  State<ListenChooseStep> createState() => _ListenChooseStepState();
}

class _ListenChooseStepState extends State<ListenChooseStep> {
  double speed = 1.0;

  int? selected;
  bool locked = false;
  bool isPlaying = false;

  Future<void> _pick(int index) async {

    if (locked) return;

    setState(() {
      selected = index;
      locked = true;
    });

    final correct = index == widget.correctIndex;

    await _showPracticeResultSheet(
      context: context,
      isCorrect: correct,
      correctSolution: widget.options[widget.correctIndex],
      onSuccessAuto: () async {
        widget.onComplete();
      },
      onWrongContinue: () {
        if (!mounted) return;

        setState(() {
          selected = null;
          locked = false;
        });
      },
    );

    if (correct && mounted) {
      setState(() => locked = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    final r = context.r;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: r.hp(0.3)),
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.symmetric(vertical: r.hp(0.09)),
              child: Column(
                children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        speed = 0.8;
                      });
                    },
                    child: _SpeedBubble(
                      text: "0.8x",
                      selected: speed == 0.8,
                    ),
                  ),

                  SizedBox(width: r.wp(0.05)),

    /// PLAY BUTTON
    GestureDetector(
    onTap: () {
    setState(() {
    isPlaying = !isPlaying;
    });
    },
    child: Container(
    width: r.wp(0.18),
    height: r.wp(0.18),
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: AppColors.dailyPracticeGradient,
    boxShadow: [
    BoxShadow(
    color: AppColors.primary.withOpacity(.35),
    blurRadius: 20,
    offset: const Offset(0, 8),
    )
    ],
    ),
    child: Stack(
    alignment: Alignment.center,
    children: [

    /// OQ BORDER ICON
    Icon(
    isPlaying
    ? Icons.stop_rounded
        : Icons.play_arrow_rounded,
    color: AppColors.white,
    size: 50,
    ),

    /// ICHKI ICON
    Icon(
    isPlaying
    ? Icons.stop_rounded
        : Icons.play_arrow_rounded,
    color: AppColors.primary,
    size: 36,
    ),
    ],
    ),
    ),
    ),


                  SizedBox(width: r.wp(0.05)),

                  /// 1.0 SPEED
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        speed = 1.0;
                      });
                    },
                    child: _SpeedBubble(
                      text: "1.0x",
                      selected: speed == 1.0,
                    ),
                  ),
                ],
              ),

                  SizedBox(height: r.hp(0.030)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      _wave(8, Colors.grey.shade300),
                      _wave(12, Colors.grey.shade300),
                      _wave(16, Colors.grey.shade300),
                      _wave(20, Colors.grey.shade400),

                      _wave(26, Colors.grey.shade400),

                      /// center active bars
                      _wave(34, AppColors.primary),
                      _wave(26, AppColors.primary),

                      _wave(20, Colors.grey.shade400),
                      _wave(16, Colors.grey.shade300),
                      _wave(12, Colors.grey.shade300),
                      _wave(8, Colors.grey.shade300),

                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: r.hp(0.01)),

            /// OPTIONS (no card)

            Padding(
              padding: EdgeInsets.symmetric(horizontal: r.wp(0.06)),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.options.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: r.wp(0.04),
                  mainAxisSpacing: r.hp(0.020),
                  childAspectRatio: r.adaptive(
                    mobile: 2.2,
                    tablet: 2.6,
                    desktop: 3,
                  ),
                ),
                itemBuilder: (_, i) {

                  final active = selected == i;

                  return InkWell(
                    onTap: locked ? null : () => _pick(i),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary.withOpacity(0.8)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: active
                              ? Colors.transparent
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        widget.options[i],
                        style: TextStyle(
                          fontSize: r.text(16),
                          fontWeight: FontWeight.w700,
                          color: active
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wave(double h, Color c) {
    return Container(
      width: 4,
      height: h,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _SpeedBubble extends StatelessWidget {

  final String text;
  final bool selected;

  const _SpeedBubble({
    required this.text,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {

    final r = context.r;

    return Container(
      width: r.wp(0.10),
      height: r.wp(0.10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected
            ? AppColors.primary.withOpacity(0.1)
            : Colors.white,
        border: Border.all(
          color: selected
              ? AppColors.primary.withOpacity(0.5)
              : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: r.text(12),
          fontWeight: FontWeight.w700,
          color:  selected
          ? AppColors.primary
              : Colors.grey.shade400,
        ),
      ),
    );
  }
}

// =======================================================
// 5) Speak sentence (record voice)
// =======================================================

class SpeakSentenceStep extends StatefulWidget {
  final String romanized;
  final String sentence;
  final String correct;
  final VoidCallback onComplete;

  const SpeakSentenceStep({
    super.key,
    required this.romanized,
    required this.sentence,
    required this.correct,
    required this.onComplete,
  });

  @override
  State<SpeakSentenceStep> createState() => _SpeakSentenceStepState();
}

class _SpeakSentenceStepState extends State<SpeakSentenceStep> {

  bool recording = false;
  bool locked = false;

  Future<void> _simulateSpeechResult() async {

    if (locked) return;

    setState(() {
      recording = false;
      locked = true;
    });

    /// Fake recognition result
    final bool correct = true;

    await _showPracticeResultSheet(
      context: context,
      isCorrect: correct,
      correctSolution: widget.correct,
      onSuccessAuto: () async {
        widget.onComplete();
      },
      onWrongContinue: () {
        if (!mounted) return;
        setState(() {
          locked = false;
        });
      },
    );

    if (mounted && correct) {
      setState(() => locked = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    final r = context.r;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: r.hp(0.1)),
          child: Column(
            children: [

              SizedBox(height: r.hp(0.02)),

              /// PLAY AUDIO BUTTON
              Container(
                width: r.wp(0.14),
                height: r.wp(0.14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/icons/speak.svg",
                  width: r.text(50),
                  height: r.text(50),

                ),
              ),

              SizedBox(height: r.hp(0.02)),

              /// ROMANIZED TEXT
              Text(
                widget.romanized.toUpperCase(),
                style: TextStyle(
                  fontSize: r.text(12),
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                  color: AppColors.titleGray.withOpacity(0.7),
                ),
              ),

              SizedBox(height: r.hp(0.01)),

              /// JAPANESE TEXT
              Text(
                widget.sentence,
                style: TextStyle(
                  fontSize: r.text(36),
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),

              SizedBox(height: r.hp(0.02)),

              Container(
                width: r.wp(0.12),
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.barGray.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),

              SizedBox(height: r.hp(0.2)),

              /// RECORD BUTTON
              GestureDetector(
                onTapDown: (_) {

                  if (locked) return;

                  setState(() {
                    recording = true;
                  });
                },
                onTapUp: (_) {
                  _simulateSpeechResult();
                },
                child: Container(
                  width: r.wp(0.18),
                  height: r.wp(0.18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: recording
                        ? AppColors.primary
                        : AppColors.background,
                    border: Border.all(
                      color: AppColors.gray.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.mic_rounded,
                    size: r.text(28),
                    color: recording
                        ? Colors.white
                        : AppColors.titleGray,
                  ),
                ),
              ),

              SizedBox(height: r.hp(0.015)),

              Text(
                "PRESS & HOLD TO RECORD\nYOUR ANSWER",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: r.text(10),
                  letterSpacing: 1,
                  color: AppColors.titleGray.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: r.hp(0.02)),
            ],
          ),
      ),
    );
  }
}