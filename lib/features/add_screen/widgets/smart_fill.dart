
import 'package:flutter/material.dart';
import 'package:ownproject/constants/responsivness.dart';

import '../../../constants/colors.dart';
import '../../../constants/text.dart';
class WordSmartFillField extends StatelessWidget {
  final TextEditingController controller;

  const WordSmartFillField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ASOSIY CONTAINER (O'ZGARMADI)
        Container(
          height: r.text(48),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: AppColors.barGray,
            ),
          ),
          child: Row(
            children: [
              /// LEFT SIDE (TEXT → TEXTFIELD BO‘LDI)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.text(14),
                  ),
                  child: TextField(
                    controller: controller,
                    cursorColor: AppColors.primary,
                    style: AppText.appBarBadgeBold.copyWith(
                      fontSize: r.text(14),
                      color: AppColors.gray,
                    ),
                    decoration: InputDecoration(
                      hintText: "Simultaneous",
                      hintStyle: AppText.appBarBadgeBold.copyWith(
                        fontSize: r.text(14),
                        color: AppColors.gray,
                      ),
                      border: InputBorder.none, // 🔥 border olib tashlandi
                      isDense: true,
                    ),
                  ),
                ),
              ),

              /// RIGHT SMART FILL (O'ZGARMADI)
              Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: r.text(14),
                ),
                decoration: BoxDecoration(
                  color: AppColors.collection,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Smart Fill",
                      style: AppText.appBarBadgeBold.copyWith(
                        fontSize: r.text(14),
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(width: r.text(6)),
                    const Icon(
                      Icons.auto_fix_high,
                      size: 16,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// PASTGI TEXT
        SizedBox(height: r.text(4)),
        Padding(
          padding: EdgeInsets.only(left: r.text(2)),
          child: Text(
            "Enter a word....",
            style: AppText.Medium.copyWith(
              fontSize: r.text(14),
              color: AppColors.barRed,
            ),
          ),
        ),
      ],
    );
  }
}