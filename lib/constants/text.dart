import 'package:flutter/material.dart';
import 'colors.dart';

class AppText {
  /// Poppins Bold – Large titles
  static const titleBold = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  /// Poppins Regular – Small descriptions / secondary text
  static const subtitleRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  /// Poppins SemiBold – Card titles
  static const cardTitleSemiBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.titleGray,
  );

  /// Poppins SemiBold – AppBar language text (Spanish)
  static const appBarSemiBold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const Medium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  /// Poppins Bold – AppBar badge number (7)
  static const appBarBadgeBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.titleGray,
  );
}
