import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/features/onboard/wg/indicator.dart';
import '../../constants/colors.dart';
import '../../constants/responsivness.dart';

class ChooseLanguagePage extends StatefulWidget {
  const ChooseLanguagePage({super.key});

  @override
  State<ChooseLanguagePage> createState() => _ChooseLanguagePageState();
}

class _ChooseLanguagePageState extends State<ChooseLanguagePage> {
  int step = 0;
  String selected = "English";
  final languages = [
    {"name": "English", "flag": "🇬🇧"},
    {"name": "Spain", "flag": "🇪🇸"},
    {"name": "French", "flag": "🇫🇷"},
    {"name": "German", "flag": "🇩🇪"},
    {"name": "Japanies", "flag": "🇯🇵"},
  ];

  // ──────────────────────────────────────────────────────────────
  // SCREEN 4 — Why Are You Learning? (Multi-select)
  // ──────────────────────────────────────────────────────────────
  final List<String> learningReasons = [
    "Speaking better",
    "Texting/chatting",
    "Traveling",
    "School/exams",
    "Work/career",
    "Personal growth",
  ];
  Set<String> selectedReasons = {};

  // ──────────────────────────────────────────────────────────────
  // SCREEN 5 — Choose Daily Study Goal
  // ──────────────────────────────────────────────────────────────
  final List<String> dailyPresets = [
    "5 min/day (casual)",
    "10 min/day (regular)",
    "15 min/day (serious)",
    "20+ min/day (intensive)",
  ];
  String? selectedDailyPreset;
  bool isDailyCustomSelected = false;
  late TextEditingController dailyCustomController;
  final FocusNode dailyFocusNode = FocusNode();

  // ──────────────────────────────────────────────────────────────
  // SCREEN 7 — Set Your Vocabulary Goal
  // ──────────────────────────────────────────────────────────────
  final List<String> vocabPresets = ["100", "300", "500"];
  String? selectedVocabPreset;
  bool isVocabCustomSelected = false;
  late TextEditingController vocabCustomController;
  final FocusNode vocabFocusNode = FocusNode();

  // ──────────────────────────────────────────────────────────────
  // Progress (8 total steps — Screens 2-9)
  // ──────────────────────────────────────────────────────────────
  double get progress => (step + 1) / 8.0;

  @override
  void initState() {
    super.initState();
    dailyCustomController = TextEditingController();
    vocabCustomController = TextEditingController();
  }

  @override
  void dispose() {
    dailyCustomController.dispose();
    vocabCustomController.dispose();
    dailyFocusNode.dispose();
    vocabFocusNode.dispose();
    super.dispose();
  }

  void next() {
    if (step < 7) {
      setState(() => step++);
    } else {
      context.go('/'); // 🔥 HOME
    }
  }

  void back() {
    if (step > 0) {
      setState(() => step--);
    } else {
      context.pop();
    }
  }

  String get titleText {
    switch (step) {
      case 0:
        return "Choose your Language";
      case 1:
        return "What would you like\nto learn";
      case 2:
        return "Why Are You Learning?";
      case 3:
        return "Choose Daily Study Goal";
      case 4:
        return "Why Snapiq Works";
      case 5:
        return "Set Your Vocabulary Goal";
      case 6:
        return "Motivation Check";
      case 7:
        return "Why You Will Learn Faster";
      default:
        return "";
    }
  }

  String? get subtitleText {
    switch (step) {
      case 0:
      case 1:
        return "Choose all that apply and we’ll help you\nfind your match.";
      case 2:
        return "Choose all that apply";
      case 3:
        return "4 presets + custom";
      case 4:
        return "Here’s how we make learning effortless";
      case 5:
        return "How many words do you want to master in the next 30 days?";
      case 6:
      case 7:
        return null;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false, // ← FIXED: prevents main Column overflow when keyboard appears on input screens
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.wp(0.06)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: r.hp(0.01)),
              /// 🔥 PROGRESS
              TopProgressIndicator(
                progress: progress,
                onBack: back,
              ),
              SizedBox(height: r.hp(0.04)),
              /// 🔥 TITLE
              Text(
                titleText,
                style: TextStyle(
                  fontSize: r.text(28),
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  height: 1.2,
                ),
              ),
              SizedBox(height: r.hp(0.015)),
              /// SUBTITLE
              if (subtitleText != null)
                Text(
                  subtitleText!,
                  style: TextStyle(
                    fontSize: r.text(14),
                    color: AppColors.textGray,
                    height: 1.4,
                  ),
                )
              else
                SizedBox(height: r.hp(0.015)),
              SizedBox(height: r.hp(0.03)),
              /// 🔥 CONTENT
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildContent(r),
                ),
              ),
              SizedBox(height: r.hp(0.02)),
              /// BUTTON
              Center(
                child: GestureDetector(
                  onTap: next,
                  child: Container(
                    width: r.wp(0.45),
                    height: r.hp(0.065),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7B7FEF),
                          Color(0xFF8376EC),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B7FEF).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: r.text(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: r.hp(0.03)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Responsive r) {
    if (step == 0 || step == 1) {
      return _buildList(r);
    }

    switch (step) {
      case 2:
        return _buildMultiSelectReasons(r);
      case 3:
        return _buildDailyGoal(r);
      case 4:
        return _buildWhySnapiqWorks(r);
      case 5:
        return _buildVocabGoal(r);
      case 6:
        return _buildMotivationCheck(r);
      case 7:
        return _buildLearnFaster(r);
      default:
        return const SizedBox();
    }
  }

  // ──────────────────────────────────────────────────────────────
  // FIRST 2 SCREENS — 100% UNCHANGED
  // ──────────────────────────────────────────────────────────────
  Widget _buildList(Responsive r) {
    return Column(
      key: ValueKey(step),
      children: languages.map((item) {
        final isSelected = selected == item["name"];
        return GestureDetector(
          onTap: () => setState(() => selected = item["name"]!),
          child: Container(
            margin: EdgeInsets.only(bottom: r.hp(0.015)),
            height: r.hp(0.075),
            padding: EdgeInsets.symmetric(horizontal: r.wp(0.04)),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFE8E9FF)
                  : const Color(0xFFEDEDF5),
              borderRadius: BorderRadius.circular(14),
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.18)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  item["flag"]!,
                  style: TextStyle(fontSize: r.text(22)),
                ),
                SizedBox(width: r.wp(0.03)),
                Expanded(
                  child: Text(
                    item["name"]!,
                    style: TextStyle(
                      fontSize: r.text(16),
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: AppColors.primary,
                    size: r.text(22),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // LUXURY MULTI-SELECT (Screen 4)
  // ──────────────────────────────────────────────────────────────
  Widget _buildMultiSelectReasons(Responsive r) {
    return Column(
      key: const ValueKey(2),
      children: learningReasons.map((reason) {
        final isSelected = selectedReasons.contains(reason);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedReasons.remove(reason);
              } else {
                selectedReasons.add(reason);
              }
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: r.hp(0.015)),
            height: r.hp(0.075),
            padding: EdgeInsets.symmetric(horizontal: r.wp(0.04)),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFE8E9FF)
                  : const Color(0xFFEDEDF5),
              borderRadius: BorderRadius.circular(14),
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.18)
                      : AppColors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    reason,
                    style: TextStyle(
                      fontSize: r.text(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: AppColors.primary,
                    size: r.text(26),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // FIXED DAILY GOAL (Screen 5) — NO OVERFLOW + KEYBOARD SAFE
  // ──────────────────────────────────────────────────────────────
  Widget _buildDailyGoal(Responsive r) {
    return Column(
      key: const ValueKey(3),
      children: [
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + r.hp(0.02),
            ),
            children: [
              /// ───────── PRESETS ─────────
              ...dailyPresets.map((preset) {
                final isSelected = selectedDailyPreset == preset;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDailyPreset = preset;
                      isDailyCustomSelected = false;
                      dailyCustomController.clear();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: r.hp(0.015)),
                    height: r.hp(0.075),
                    padding: EdgeInsets.symmetric(horizontal: r.wp(0.04)),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE8E9FF)
                          : const Color(0xFFEDEDF5),
                      borderRadius: BorderRadius.circular(14),
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.18)
                              : AppColors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            preset,
                            style: TextStyle(
                              fontSize: r.text(16),
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check,
                            color: AppColors.primary,
                            size: r.text(26),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              SizedBox(height: r.hp(0.02)),

              /// ───────── CUSTOM (INPUT ICHIDA) ─────────
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDailyPreset = null;
                    isDailyCustomSelected = true;
                  });

                  Future.delayed(const Duration(milliseconds: 200), () {
                    dailyFocusNode.requestFocus();
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: r.hp(0.015)),
                  padding: EdgeInsets.symmetric(
                    horizontal: r.wp(0.04),
                    vertical: r.hp(0.02),
                  ),
                  decoration: BoxDecoration(
                    color: isDailyCustomSelected
                        ? const Color(0xFFE8E9FF)
                        : const Color(0xFFEDEDF5),
                    borderRadius: BorderRadius.circular(14),
                    border: isDailyCustomSelected
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: isDailyCustomSelected
                            ? AppColors.primary.withOpacity(0.18)
                            : AppColors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// TITLE ROW
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Custom",
                              style: TextStyle(
                                fontSize: r.text(16),
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          if (isDailyCustomSelected)
                            Icon(
                              Icons.check,
                              color: AppColors.primary,
                              size: r.text(26),
                            ),
                        ],
                      ),

                      /// 🔥 INPUT (ENDI YO‘QOLMAYDI)
                      if (isDailyCustomSelected) ...[
                        SizedBox(height: r.hp(0.015)),

                        TextField(
                          controller: dailyCustomController,
                          focusNode: dailyFocusNode,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: r.text(18),
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter minutes per day",
                            hintStyle: TextStyle(
                              color: AppColors.textGray,
                              fontSize: r.text(16),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: r.hp(0.025),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // ──────────────────────────────────────────────────────────────
  // FIXED VOCABULARY GOAL (Screen 7) — NO OVERFLOW + KEYBOARD SAFE
  // ──────────────────────────────────────────────────────────────
  Widget _buildVocabGoal(Responsive r) {
    return Column(
      key: const ValueKey(5),
      children: [
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + r.hp(0.02),
            ),
            children: [
              /// ───────── PRESETS ─────────
              ...vocabPresets.map((preset) {
                final isSelected = selectedVocabPreset == preset;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedVocabPreset = preset;
                      isVocabCustomSelected = false;
                      vocabCustomController.clear();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: r.hp(0.015)),
                    height: r.hp(0.075),
                    padding: EdgeInsets.symmetric(horizontal: r.wp(0.04)),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE8E9FF)
                          : const Color(0xFFEDEDF5),
                      borderRadius: BorderRadius.circular(14),
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.18)
                              : AppColors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "$preset words",
                            style: TextStyle(
                              fontSize: r.text(16),
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check,
                            color: AppColors.primary,
                            size: r.text(26),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              SizedBox(height: r.hp(0.02)),

              /// ───────── CUSTOM (INPUT ICHIDA) ─────────
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedVocabPreset = null;
                    isVocabCustomSelected = true;
                  });

                  Future.delayed(const Duration(milliseconds: 200), () {
                    vocabFocusNode.requestFocus();
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: r.hp(0.015)),
                  padding: EdgeInsets.symmetric(
                    horizontal: r.wp(0.04),
                    vertical: r.hp(0.02),
                  ),
                  decoration: BoxDecoration(
                    color: isVocabCustomSelected
                        ? const Color(0xFFE8E9FF)
                        : const Color(0xFFEDEDF5),
                    borderRadius: BorderRadius.circular(14),
                    border: isVocabCustomSelected
                        ? Border.all(color: AppColors.primary, width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: isVocabCustomSelected
                            ? AppColors.primary.withOpacity(0.18)
                            : AppColors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// TITLE ROW
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Custom",
                              style: TextStyle(
                                fontSize: r.text(16),
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          if (isVocabCustomSelected)
                            Icon(
                              Icons.check,
                              color: AppColors.primary,
                              size: r.text(26),
                            ),
                        ],
                      ),

                      /// 🔥 INPUT (ENDI YO‘QOLMAYDI)
                      if (isVocabCustomSelected) ...[
                        SizedBox(height: r.hp(0.015)),

                        TextField(
                          controller: vocabCustomController,
                          focusNode: vocabFocusNode,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: r.text(18),
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter number of words",
                            hintStyle: TextStyle(
                              color: AppColors.textGray,
                              fontSize: r.text(16),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: r.hp(0.025),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // ──────────────────────────────────────────────────────────────
  // WHY SNAPIQ WORKS (Screen 6)
  // ──────────────────────────────────────────────────────────────
  Widget _buildWhySnapiqWorks(Responsive r) {
    final cards = [
      {"num": "1", "text": "AI identifies words from your real life"},
      {"num": "2", "text": "Smart recall helps you memorize for life"},
      {"num": "3", "text": "Context-based examples show how to use words correctly"},
    ];

    return Column(
      key: const ValueKey(4),
      children: cards.map((card) {
        return Container(
          margin: EdgeInsets.only(bottom: r.hp(0.025)),
          padding: EdgeInsets.all(r.wp(0.055)),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.07),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: r.wp(0.10),
                height: r.wp(0.10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7B7FEF),
                      Color(0xFF8376EC),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B7FEF).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  card["num"]!,
                  style: TextStyle(
                    fontSize: r.text(20),
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(width: r.wp(0.05)),
              Expanded(
                child: Text(
                  card["text"]!,
                  style: TextStyle(
                    fontSize: r.text(16.5),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // MOTIVATION CHECK (Screen 8)
  // ──────────────────────────────────────────────────────────────
  Widget _buildMotivationCheck(Responsive r) {
    return Center(
      key: const ValueKey(6),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: r.wp(0.07),
          vertical: r.hp(0.06),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Most Snapiq learners master 300+ words in the first month.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: r.text(19),
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                height: 1.4,
              ),
            ),
            SizedBox(height: r.hp(0.03)),
            Text(
              "We’ll build a plan to match your goal.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: r.text(16),
                color: AppColors.textGray,
                height: 1.45,
              ),
            ),
            SizedBox(height: r.hp(0.05)),
            Icon(
              Icons.celebration_rounded,
              size: r.text(82),
              color: const Color(0xFF7B7FEF),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // WHY YOU WILL LEARN FASTER (Screen 9)
  // ──────────────────────────────────────────────────────────────
  Widget _buildLearnFaster(Responsive r) {
    final points = [
      "Spaced repetition",
      "Smart difficulty adjustment",
      "Context immersion",
      "Personalized examples",
    ];

    return Column(
      key: const ValueKey(7),
      children: points.map((point) {
        return Container(
          margin: EdgeInsets.only(bottom: r.hp(0.018)),
          padding: EdgeInsets.symmetric(
            horizontal: r.wp(0.05),
            vertical: r.hp(0.02),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.06),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.check,
                color: AppColors.primary,
                size: r.text(28),
              ),
              SizedBox(width: r.wp(0.04)),
              Expanded(
                child: Text(
                  point,
                  style: TextStyle(
                    fontSize: r.text(16.5),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}