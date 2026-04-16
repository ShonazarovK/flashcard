import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';

import '../../constants/colors.dart';
import '../../constants/text.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String level = "A2";
  String type = "Noun";
  String memorization = "Learned";

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: AppColors.black,
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Filters",
          style: AppText.appBarBadgeBold.copyWith(fontSize: r.text(18)),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.fromLTRB(
          r.wp(0.06),
          r.text(10),
          r.wp(0.06),
          r.wp(0.06),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _sectionTitle("Sort By"),
            SizedBox(height: r.text(12)),
            _sortByRow(),

            SizedBox(height: r.text(26)),

            _sectionTitle("Type"),
            SizedBox(height: r.text(14)),
            _typeRow1(),
            SizedBox(height: r.text(16)),
            _typeRow2(),

            SizedBox(height: r.text(28)),

            _sectionTitle("Memorization"),
            SizedBox(height: r.text(14)),
            _memorizationRow(),

            SizedBox(height: r.text(46)),

            Center(
              child: SizedBox(
                width: r.wp(0.70),
                height: r.text(50),
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.collection,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "APPLY",
                    style: AppText.cardTitleSemiBold.copyWith(
                      color: AppColors.white,
                      fontSize: r.text(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI =================

  Widget _sectionTitle(String text) {
    final r = context.r;
    return Text(
      text,
      style: AppText.cardTitleSemiBold.copyWith(
        fontSize: r.text(16),
        color: AppColors.black,
      ),
    );
  }

  Widget _sortByRow() {
    final r = context.r;

    return Row(
      children: [
        _pill("A2", level == "A2", () => setState(() => level = "A2")),
        SizedBox(width: r.text(12)),
        _pill("B1", level == "B1", () => setState(() => level = "B1")),
        SizedBox(width: r.text(12)),
        _pill("B2", level == "B2", () => setState(() => level = "B2")),
        SizedBox(width: r.text(12)),
        _pill("C1", level == "C1", () => setState(() => level = "C1")),
      ],
    );
  }

  Widget _typeRow1() {
    final r = context.r;

    return Row(
      children: [
        _pill("Noun", type == "Noun", () => setState(() => type = "Noun")),
        SizedBox(width: r.text(12)),
        _pill("Adjective", type == "Adjective", () => setState(() => type = "Adjective")),
        SizedBox(width: r.text(12)),
        _pill("Adverb", type == "Adverb", () => setState(() => type = "Adverb")),
      ],
    );
  }

  Widget _typeRow2() {
    final r = context.r;

    return Row(
      children: [
        _pill("Preposition", type == "Preposition", () => setState(() => type = "Preposition")),
        SizedBox(width: r.text(12)),
        _pill("Conjunction", type == "Conjunction", () => setState(() => type = "Conjunction")),
      ],
    );
  }

  Widget _memorizationRow() {
    final r = context.r;

    return Row(
      children: [
        _pill("Learned", memorization == "Learned", () => setState(() => memorization = "Learned")),
        SizedBox(width: r.text(12)),
        _pill("in Progress", memorization == "in Progress", () => setState(() => memorization = "in Progress")),
        SizedBox(width: r.text(12)),
        _pill("Not reviewed", memorization == "Not reviewed", () => setState(() => memorization = "Not reviewed")),
      ],
    );
  }

  // ================= PILL =================

  Widget _pill(String text, bool isActive, VoidCallback onTap) {
    final r = context.r;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: r.text(18),
          vertical: r.text(8),
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.collection
              : const Color(0xFFEDEDF5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: r.text(13.5),
            fontWeight: FontWeight.w600,
            color: isActive
                ? AppColors.white
                : AppColors.textGray,
          ),
        ),
      ),
    );
  }


  Widget _smallText(
      String v, {
        required bool isActive,
        required VoidCallback onTap,
        double? fontSize,
      }) {
    final r = context.r;

    return GestureDetector(
      onTap: onTap,
      child: Text(
        v,
        style: TextStyle(
          fontSize: fontSize ?? r.text(13.5),
          fontWeight: FontWeight.w500,
          color: isActive ? AppColors.black : AppColors.textGray,
        ),
      ),
    );
  }
}
