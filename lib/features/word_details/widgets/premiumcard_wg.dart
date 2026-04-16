import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';

import '../../../constants/colors.dart';
import '../../../constants/text.dart';

class AiExerciseLabCard extends StatelessWidget {
  final VoidCallback? onGenerate;
  const AiExerciseLabCard({required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.wp(0.02)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          r.wp(0.045),
          r.hp(0.02),
          r.wp(0.045),
          r.hp(0.02),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.01),
              AppColors.white,
            ],
          ),
          border: Border.all(
            color: AppColors.barGray.withOpacity(1),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.barGray.withOpacity(0.90),
              blurRadius: 36,
              spreadRadius: 2,
              offset: const Offset(0, 14),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 26,
              spreadRadius: 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: r.adaptive(mobile: 30.0, tablet: 32.0, desktop: 34.0),
                  height: r.adaptive(mobile: 30.0, tablet: 32.0, desktop: 34.0),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.98),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.barGray.withOpacity(0.95),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.barGray.withOpacity(0.75),
                        blurRadius: 16,
                        spreadRadius: 0.5,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome_outlined,
                    size: r.text(18),
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: r.wp(0.02)),
                Text(
                  "AI EXERCISE LAB",
                  style: TextStyle(
                    fontSize: r.text(14),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: r.hp(0.012)),
            Text(
              "Deepen your understanding",
              style: TextStyle(
                fontSize: r.text(20),
                fontWeight: FontWeight.w800,
                color: AppColors.black.withOpacity(0.88),
                height: 1.15,
              ),
            ),
            SizedBox(height: r.hp(0.008)),
            Text(
              "Generate custom context sentences tailored\nto your profession or interests.",
              style: TextStyle(
                fontSize: r.text(14),
                fontWeight: AppText.subtitleRegular.fontWeight,
                color: AppColors.titleGray.withOpacity(0.65),
                height: 1.5,
              ),
            ),
            SizedBox(height: r.hp(0.02)),
            InkWell(
              onTap: () {
                context.goNamed('ai');
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: r.adaptive(mobile: 52.0, tablet: 56.0, desktop: 58.0),
                decoration: BoxDecoration(
                  gradient: AppColors.dailyPracticeGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.28),
                      blurRadius: 22,
                      spreadRadius: 1,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: r.wp(0.05)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Generate New Sentences",
                          style: TextStyle(
                            fontSize: r.text(15),
                            fontWeight: FontWeight.w800,
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
            )
          ],
        ),
      ),
    );
  }
}
