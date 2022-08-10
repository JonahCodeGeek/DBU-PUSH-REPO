// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/auth/registration_screen.dart';
import '../utils/Theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? width, height, elevation, fontSize;
  final Color? buttonColor, fontColor;
  final ShapeBorder? buttonShape;
  final FontWeight? fontWeight;
  final String text;

  const AppButton(
      {Key? key,
      required this.onPressed,
      this.fontSize,
      this.fontWeight,
      this.buttonColor,
      this.buttonShape,
      required this.text,
      this.width,
      this.fontColor,
      this.height,
      this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: width,
      height: height,
      color: buttonColor,
      elevation: elevation,
      shape: buttonShape,
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: fontSize,
          color: fontColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
