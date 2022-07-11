// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/Theme/app_colors.dart';

class AppText {
  final String text = '';
  final Color? color = null;

  static Widget HeaderText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.textColor1,
        ),
      ),
    );
  }

  static Widget ContentText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.normal,
          fontSize: 15,
          color: AppColors.textColor2,
        ),
      ),
    );
  }

  static Widget ReferenceText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.normal,
          fontSize: 13,
          color: AppColors.textColor3,
        ),
      ),
    );
  }
}
