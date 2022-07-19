// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/Theme/app_colors.dart';

class OnboardingText extends StatelessWidget {
  final String? coloredText, normalText, lightText, sloganText;
  const OnboardingText(
      {Key? key,
      this.sloganText,
      this.coloredText,
      this.normalText,
      this.lightText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          text: coloredText,
          style: GoogleFonts.roboto(
            color: AppColors.primaryColor,
            fontSize: 50,
            fontWeight: FontWeight.w800,
          ),
          children: <TextSpan>[
            TextSpan(
              text: normalText,
              style: GoogleFonts.roboto(
                color: AppColors.textColor1,
                fontSize: 50,
                fontWeight: FontWeight.w800,
              ),
            ),
            TextSpan(
              text: lightText,
              style: GoogleFonts.roboto(
                color: AppColors.textColor3,
                fontSize: 23,
                fontWeight: FontWeight.w300,
              ),
            ),
            TextSpan(
              text: sloganText,
              style: GoogleFonts.robotoCondensed(
                  color: AppColors.textColor3,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
