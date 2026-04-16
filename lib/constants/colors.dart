import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF6C63FF);
  static const secondary = Color(0xFF8E99F3);

  static const secondPrimary= Color(0xFF8376EC);

  static const collection = Color(0xFF7F89F9);

  static const buttonColor = Color(0xFF7B7FEF);


  static const background = Color(0xFFF7F7FB);
  static const white = Colors.white;
  static const black = Colors.black;

  static const gray = Color(0xFF9E9E9E);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFA726);

  static const ringBlue   = Color(0xFF8FB2FF);
  static const ringOrange = Color(0xFFFFA24C);

  static const barBlue    = Color(0xFF7F89F9);
  static const barGray    = Color(0xFFE9EBF5);
  static const barRed     = Color(0xFFFF3B30);
  static const barOrange  = Color(0xFFFFA726);

  static const textGray   = Color(0xFF7A7A7A);
  static const titleGray  = Color(0xFF4A4A4A);
  static const LinearGradient dailyPracticeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5162EE), // 0%
      Color(0xFF5C67F0), // 22%
      Color(0xFF676CF1), // 40%
      Color(0xFF7371F2), // 55%
      Color(0xFF7E74ED), // 75%
      Color(0xFF8376EC), // 97%
    ],
  );



}