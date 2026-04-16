import 'package:flutter/material.dart';
import 'package:ownproject/constants/responsivness.dart';

import '../../../constants/colors.dart';
import '../../../constants/text.dart';
class RecentlyUploadedSection extends StatelessWidget {
  const RecentlyUploadedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TITLE
        Text(
          "Recently uploaded",
          style: AppText.cardTitleSemiBold.copyWith(
            fontSize: r.text(16),
            color: AppColors.black,
          ),
        ),

        SizedBox(height: r.text(10)),

        const RecentlyUploadedCard(
          word: "Simultaneously",
          type: "Adverb",
          description:
          "happening or done at the same time as something else",
        ),
      ],
    );
  }
}


class RecentlyUploadedCard extends StatelessWidget {
  final String word;
  final String type;
  final String description;

  const RecentlyUploadedCard({
    super.key,
    required this.word,
    required this.type,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.text(14)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.barGray),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // WORD + TYPE
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$word ",
                        style: AppText.subtitleRegular.copyWith(
                          fontSize: r.text(16),
                          color: AppColors.black,
                        ),
                      ),
                      TextSpan(
                        text: type,
                        style: AppText.subtitleRegular.copyWith(
                          fontSize: r.text(12),
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: r.text(6)),

                // DESCRIPTION
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.subtitleRegular.copyWith(
                    fontSize: r.text(13),
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: r.text(12)),

          // AUDIO BUTTON
          Container(
            width: r.text(36),
            height: r.text(36),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.85),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.volume_up_rounded,
              color: AppColors.white,
              size: r.text(20),
            ),
          ),
        ],
      ),
    );
  }
}

