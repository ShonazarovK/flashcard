import 'package:flutter/material.dart';
import 'package:ownproject/constants/colors.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:ownproject/features/statistics/widgets/calendar_wg.dart';
import 'package:ownproject/features/statistics/widgets/statssections_wg.dart';
import 'package:ownproject/features/statistics/widgets/time_wg.dart';
import 'package:ownproject/features/statistics/widgets/vocab_liner_wg.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: r.wp(0.06)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: r.hp(0.03)),

                /// MONTHLY ACTIVITY LABEL
                Text(
                  "MONTHLY ACTIVITY",
                  style: TextStyle(
                    fontSize: r.text(11),
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleGray.withOpacity(.6),
                  ),
                ),

                SizedBox(height: r.hp(0.012)),

                /// TITLE + XP BADGE
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Your statistics",
                        style: TextStyle(
                          fontSize: r.text(28),
                          fontWeight: FontWeight.w800,
                          color: AppColors.black.withOpacity(.85),
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.wp(0.035),
                        vertical: r.hp(0.009),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.flash_on_rounded,
                            color: AppColors.primary,
                            size: r.text(18),
                          ),

                          SizedBox(width: r.wp(0.01)),

                          Text(
                            "2,840 XP",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: r.text(14),
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: r.hp(0.025)),

                /// STATS CARDS
                Row(
                  children: [

                    Expanded(
                      child: _StatCard(
                        title: "Mastered",
                        value: "215",
                        color: const Color(0xFF10B981),
                      ),
                    ),

                    SizedBox(width: r.wp(0.03)),

                    Expanded(
                      child: _StatCard(
                        title: "Learning",
                        value: "98",
                        color: AppColors.primary,
                      ),
                    ),

                    SizedBox(width: r.wp(0.03)),

                    Expanded(
                      child: _StatCard(
                        title: "Weak",
                        value: "23",
                        color: const Color(0xFFF5B942),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: r.hp(0.035)),

                /// PROGRESS CARD
                 ProgressCard(),

                SizedBox(height: r.hp(0.012)),

                const StatisticsPerformanceSection(),

                SizedBox(height: r.hp(0.01)),

                Column(
                  children: [

                    VocabularyGrowthCard(),

                    SizedBox(height: 16),

                    StudyStatsRow(),

                  ],
                ),
                SizedBox(height: r.hp(0.05)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}






class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      height: r.hp(0.08),
      padding: EdgeInsets.symmetric(
        horizontal: r.wp(0.04),
        vertical: r.hp(0.012),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: TextStyle(
              fontSize: r.text(14),
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(.9),
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              fontSize: r.text(18),
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

        ],
      ),
    );
  }
}