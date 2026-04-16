import 'package:flutter/material.dart';
import 'package:ownproject/constants/colors.dart';
import 'package:ownproject/constants/responsivness.dart';
import 'package:ownproject/constants/text.dart';

class PracticeTopIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;
  final String streakText;
  final String title;
  final VoidCallback onClose;

  const PracticeTopIndicator({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.streakText,
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final progress = ((currentIndex + 1) / total).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            streakText,
            textAlign: TextAlign.center,
            style: AppText.cardTitleSemiBold.copyWith(
              fontSize: r.text(14),
              fontWeight: FontWeight.w700,
              color: AppColors.primary.withOpacity(0.9),
              letterSpacing: 0.15,
              height: 1.0,
            ),
          ),
        ),
        SizedBox(height: r.hp(0.016)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                width: r.adaptive(mobile: 24.0, tablet: 28.0, desktop: 30.0),
                height: r.adaptive(mobile: 24.0, tablet: 28.0, desktop: 30.0),
                child: Center(
                  child: Icon(
                    Icons.close_rounded,
                    size: r.text(24),
                    color: AppColors.gray.withOpacity(0.85),
                  ),
                ),
              ),
            ),
            SizedBox(width: r.wp(0.024)),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  height: r.adaptive(mobile: 12.5, tablet: 14.0, desktop: 15.0),
                  color: AppColors.primary.withOpacity(0.18),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutCubic,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.78),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: r.hp(0.016)),
        Text(
          title,
          style: AppText.cardTitleSemiBold.copyWith(
            fontSize: r.text(18),
            fontWeight: FontWeight.w700,
            color: AppColors.black.withOpacity(0.92),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
