import 'package:flutter/material.dart';

import 'colors.dart';

// class R {
//   static late double w;
//   static late double h;
//
//   static init(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     w = size.width;
//     h = size.height;
//   }
//
//   static double wp(double percent) => w * percent;
//   static double hp(double percent) => h * percent;
// }



class AppTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    fontFamily: 'Poppins',
    useMaterial3: true,
  );
}
