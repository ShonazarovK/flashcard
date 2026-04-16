import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ownproject/constants/responsivness.dart';
import '../../../constants/colors.dart';
import '../../../constants/text.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return SizedBox(
      height: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // -----------------------------
          // LEFT: Language selector
          // -----------------------------
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "🇪🇸",
                  style: TextStyle(fontSize: r.text(20)),
                ),
                SizedBox(width: r.wp(0.02)),
                Flexible(
                  child: Text(
                    "Spanish",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.subtitleRegular.copyWith(
                      fontSize: r.text(18),
                      color: AppColors.black,
                    ),
                  ),
                ),
                SizedBox(width: r.wp(0.01)),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: r.text(22),
                  color: AppColors.black,
                ),
              ],
            ),
          ),

          SizedBox(width: r.wp(0.03)),

          // -----------------------------
          // RIGHT: Streak badge
          // -----------------------------
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: r.wp(0.035),
              vertical: r.text(6),
            ),
            decoration: BoxDecoration(
              color: AppColors.secondPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/icons/fire.svg",
                  width: r.text(18),
                  height: r.text(18),
                ),
                SizedBox(width: r.wp(0.01)),
                Text(
                  "7",
                  style: AppText.titleBold.copyWith(
                    fontSize: r.text(14),
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
