// ignore_for_file: sized_box_for_whitespace, duplicate_import
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:dbu_push/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/Theme/app_colors.dart';
import '../../utils/helpers/custom_functions.dart.dart';
import 'package:flutter/material.dart';

class WelcomeScreenThree extends StatelessWidget {
  const WelcomeScreenThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldColor,
      child: Column(
        children: [
          //Header text
          VerticalSpacer(50),
          Column(
            children: [
              //Header text
              OnboardingText(
                  coloredText: 'What ',
                  normalText: 'Are you waiting for ?                      ',
                  lightText: 'join us now!!'),
              VerticalSpacer(30),
              //Picture
              SvgPicture.asset(
                'assets/images/dbuPush.svg',
                height: 250,
                color: AppColors.primaryColor,
              ),
              OnboardingText(sloganText: 'Get informed and push forward '),
              VerticalSpacer(90),

              MaterialButton(
                onPressed: () {},
                minWidth: 330,
                height: 60,
                color: AppColors.primaryColor,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'Get Started Now',
                  style: GoogleFonts.roboto(
                      fontSize: 20, color: AppColors.scaffoldColor),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
