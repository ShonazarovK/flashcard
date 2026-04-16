import 'package:flutter/material.dart';
import 'package:ownproject/constants/responsivness.dart';

import '../../../constants/colors.dart';
import '../../../constants/text.dart';

class SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return SizedBox(
      width: double.infinity,
      height: r.adaptive(
        mobile: 50,
        tablet: 58,
        desktop: 62,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.collection,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        onPressed: () {},
        child: Text(
          "Save",
          style: AppText.appBarBadgeBold.copyWith(
            fontSize: r.text(16),
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
