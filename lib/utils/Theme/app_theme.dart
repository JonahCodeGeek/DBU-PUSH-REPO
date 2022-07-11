import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// App both dark and light theme will be shown here

ThemeData appLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primaryColor,
    ),
  );
}
