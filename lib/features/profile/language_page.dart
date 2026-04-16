import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // 🔥 qo‘shildi
import 'package:ownproject/constants/responsivness.dart';
import '../../constants/colors.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selected = "English (US)";

  final List<String> suggested = ["English (US)"];

  final List<String> languages = [
    "Mandarin",
    "Hindi",
    "Spanish",
    "French",
    "Arabic",
    "Bengali",
    "Russian",
    "Indonesia",
  ];

  // 🔥 faqat locale mapping qo‘shildi
  Locale getLocale(String lang) {
    switch (lang) {
      case "Spanish":
        return const Locale('es');
      case "English (US)":
        return const Locale('en');
      default:
        return context.locale; // boshqalari o‘zgarmaydi
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 🔝 HEADER
            Padding(
              padding: EdgeInsets.fromLTRB(
                r.wp(0.05),
                r.hp(0.02),
                r.wp(0.05),
                r.hp(0.025),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: r.text(18),
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(width: r.wp(0.03)),
                  Text(
                    "language".tr(), // 🔥 faqat shu o‘zgardi
                    style: TextStyle(
                      fontSize: r.text(18),
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),

            // 🔽 LIST
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  r.wp(0.06),
                  0,
                  r.wp(0.06),
                  r.hp(0.03),
                ),
                children: [
                  /// Suggested
                  _SectionTitle(title: "suggested".tr()), // 🔥
                  SizedBox(height: r.hp(0.02)),

                  ...suggested.map((e) => _LanguageItem(
                    text: e,
                    selected: selected == e,
                    onTap: () {
                      setState(() => selected = e);

                      // 🔥 ASOSIY QISM
                      context.setLocale(getLocale(e));
                    },
                  )),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.barGray,
                  ),

                  SizedBox(height: r.hp(0.03)),

                  /// All languages
                  _SectionTitle(title: "language".tr()), // 🔥
                  SizedBox(height: r.hp(0.018)),

                  ...languages.map((e) => _LanguageItem(
                    text: e,
                    selected: selected == e,
                    onTap: () {
                      setState(() => selected = e);

                      // 🔥 faqat 2 til ishlaydi (qolgani ignore)
                      context.setLocale(getLocale(e));
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Text(
      title,
      style: TextStyle(
        fontSize: r.text(16),
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),
    );
  }
}

class _LanguageItem extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageItem({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: r.hp(0.022),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: r.text(16),
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),

                Container(
                  width: r.adaptive(
                      mobile: 22.0, tablet: 24.0, desktop: 26.0),
                  height: r.adaptive(
                      mobile: 22.0, tablet: 24.0, desktop: 26.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.gray.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? Center(
                    child: Container(
                      width: r.wp(0.025),
                      height: r.wp(0.025),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}