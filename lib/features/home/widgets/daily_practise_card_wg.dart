import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ownproject/constants/responsivness.dart';
import '../../../constants/colors.dart';
import '../../../constants/text.dart';

class DailyPracticeCard extends StatelessWidget {
  const DailyPracticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          context.pushNamed('test');
        },
        child: Container( // 🔥 Ink o‘rniga Container
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: 90,
            maxHeight: 140,
          ),
          padding: EdgeInsets.all(r.text(16)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: AppColors.dailyPracticeGradient,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "⚡ Daily Practice",
                style: AppText.subtitleRegular.copyWith(
                  fontSize: r.text(14),
                  color: AppColors.white,
                ),
              ),

              SizedBox(height: r.text(6)),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Recall Session",
                          style: AppText.titleBold.copyWith(
                            fontSize: r.text(20),
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: r.text(6)),
                        Text(
                          "42 words ready to review",
                          style: AppText.subtitleRegular.copyWith(
                            fontSize: r.text(14),
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(r.text(6)),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.primary,
                      size: r.text(30),
                    ),
                  ),
                ],
              ),

              SizedBox(height: r.text(8)),

              Text(
                "🎯 72% success rate · Avg. 5 min",
                style: AppText.subtitleRegular.copyWith(
                  fontSize: r.text(13),
                  color: AppColors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}