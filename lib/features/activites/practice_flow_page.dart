// practice_flow_page.dart

import 'package:flutter/material.dart';
import 'package:ownproject/constants/colors.dart';
import 'package:ownproject/constants/responsivness.dart';

import 'practice_steps.dart';
import 'practice_top_indicator.dart';

class PracticeFlowPage extends StatefulWidget {
  const PracticeFlowPage({super.key});

  @override
  State<PracticeFlowPage> createState() => _PracticeFlowPageState();
}

class _PracticeFlowPageState extends State<PracticeFlowPage> {

  static const int totalSteps = 4;

  late PageController _controller;

  int _stepIndex = 0;

  static const List<String> _titles = [
    "Choose the correct meaning",
    "Complete the sentence",
    "Tap the matching pairs",
    "Type the translation",
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _nextStep() async {

    if (!mounted) return;

    if (_stepIndex >= totalSteps - 1) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Practice finished ✅")),
      );

      Navigator.maybePop(context);
      return;
    }

    final nextIndex = _stepIndex + 1;

    setState(() {
      _stepIndex = nextIndex;
    });

    if (_controller.hasClients) {
      await _controller.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final r = context.r;

    final horizontalPadding = r.wp(0.06);
    final topPadding = r.hp(0.014);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFEEF2FF).withOpacity(0.9),
                AppColors.background,
              ],
            ),
          ),
          child: Column(
            children: [

              /// TOP HEADER
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  topPadding,
                  horizontalPadding,
                  0,
                ),
                child: PracticeTopIndicator(
                  currentIndex: _stepIndex,
                  total: totalSteps,
                  streakText: "3 IN A ROW",
                  title: _titles[_stepIndex],
                  onClose: () => Navigator.maybePop(context),
                ),
              ),

              SizedBox(height: r.hp(0.02)),

              /// PRACTICE STEPS
              Expanded(
                child: PageView(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),

                  onPageChanged: (index) {
                    if (!mounted) return;

                    setState(() {
                      _stepIndex = index;
                    });
                  },

                  children: [

                    /// STEP 1
                    IdentifyMeaningStep(
                      word: "Simultaneous",
                      title: "IDENTIFY MEANING",
                      badgeText: "CONFIDENCE PRIMER",
                      progressText: "1/4",
                      options: const [
                        "Happening at the same time",
                        "Happening very slowly",
                        "Extremely loud",
                        "Very small",
                      ],
                      correctIndex: 0,
                      onComplete: _nextStep,
                    ),

                    /// STEP 2
                    UsageMemoryStep(
                      badgeText: "USAGE MEMORY",
                      progressText: "2/4",
                      sentencePrefix: "We arrived",
                      sentenceSuffix: "at 9:00 AM.",
                      choices: const [
                        "simultaneous",
                        "simultaneously",
                        "jytfbytbgj",
                        "skudyfakufa",
                      ],
                      correct: "simultaneously",
                      onComplete: _nextStep,
                    ),

                    /// STEP 3
                    // MatchingPairsStep(
                    //   left: const [
                    //     "simultaneous",
                    //     "similar",
                    //   ],
                    //   right: const [
                    //     "similar",
                    //     "simultaneous",
                    //   ],
                    //   onComplete: _nextStep,
                    // ),
                    ListenChooseStep(
                      options: const [
                        "History",
                        "Istorya",
                        "History",
                        "Istorya",
                      ],
                      correctIndex: 0,
                      onComplete: _nextStep,
                    ),

                    SpeakSentenceStep(
                      romanized: "sensei",
                      sentence: "物語",
                      correct: "Istorya",
                      onComplete: _nextStep,
                    ),


                    /// STEP 4
                    TranslateStep(
                      titleTop: "Translate to Spanish",
                      word: "story, tale",
                      hint: "noun • feminine",
                      correctAnswer: "historia",
                      onComplete: () {

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Saved ✅")),
                        );

                        Navigator.maybePop(context);
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: r.hp(0.01)),
            ],
          ),
        ),
      ),
    );
  }
}