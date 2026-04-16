import 'package:flutter/material.dart';
import 'package:ownproject/constants/responsivness.dart';
import '../../../constants/colors.dart';
import '../../../constants/text.dart';
import 'circular_progress.dart';

class WeeklyProgress extends StatelessWidget {
  const WeeklyProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final double ringSize = r.adaptive(
      mobile: r.wp(0.30),
      tablet: r.wp(0.22),
      desktop: r.wp(0.18),
    );

    final double stroke = r.adaptive(
      mobile: 10.0,
      tablet: 11.0,
      desktop: 12.0,
    );

    return Padding(

      padding: EdgeInsets.only(top: r.text(0.4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT: RING + label
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: ringSize,
                height: ringSize,
                child: CircularProgressRing(
                  progress: 0.68,
                  size: ringSize,
                  strokeWidth: stroke,
                ),
              ),
              SizedBox(height: r.text(10)),
              Text(
                "Memorized words",
                style: AppText.appBarBadgeBold.copyWith(
                  fontSize: r.text(14),
                  color: AppColors.titleGray,
                ),
              ),
            ],
          ),

          SizedBox(width: r.wp(0.06)),

          // RIGHT: title + bars
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: r.text(10)), // ✅ title ring bilan bir qatorda
                Text(
                  "Progress this week",
                  style: AppText.Medium.copyWith(
                    fontSize: r.text(15),
                    color: AppColors.titleGray,
                  ),
                ),
                SizedBox(height: r.text(14)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _DayBar("Mo", 0.22, AppColors.barRed),
                    _DayBar("Tu", 0.52),
                    _DayBar("We", 0.45),
                    _DayBar("Th", 0.62),
                    _DayBar("Fr", 0.48),
                    _DayBar("Sa", 0.35, AppColors.barOrange),
                    _DayBar("Su", 0.55),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== DAY BAR =========================
class _DayBar extends StatelessWidget {
  final String day;
  final double value;
  final Color color;

  const _DayBar(
      this.day,
      this.value, [
        this.color = AppColors.barBlue,
      ]);

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    final double barHeight = r.adaptive(
      mobile: r.hp(0.085), // ✅ 1-rasmga yaqin
      tablet: r.hp(0.09),
      desktop: r.hp(0.095),
    );

    final double barWidth = r.adaptive(
      mobile: r.wp(0.022),
      tablet: r.wp(0.018),
      desktop: r.wp(0.014),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: barWidth,
          height: barHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFEDEFF8), // ✅ 1-rasmdagidek ochroq
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            width: barWidth,
            height: (barHeight * value.clamp(0.0, 1.0)),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: r.text(8)),
        Text(
          day,
          style: AppText.subtitleRegular.copyWith(
            fontSize: r.text(12),
            color: AppColors.textGray,
          ),
        ),
      ],
    );
  }
}
