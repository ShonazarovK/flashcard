import 'package:flutter/material.dart';
import 'package:ownproject/constants/responsivness.dart';

import '../../../constants/colors.dart';


class TopProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final VoidCallback? onBack;

  const TopProgressIndicator({
    super.key,
    required this.progress,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Row(
      children: [

        /// BACK BUTTON
        GestureDetector(
          onTap: onBack,
          child: Padding(
            padding: EdgeInsets.only(right: r.wp(0.03)),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: r.text(18),
              color: AppColors.black,
            ),
          ),
        ),

        /// PROGRESS BAR
        Expanded(
          child: Container(
            height: r.hp(0.012),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E6EF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [

                    /// FILLED PART
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}