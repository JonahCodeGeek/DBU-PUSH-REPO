// ignore_for_file: sized_box_for_whitespace, duplicate_import
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:dbu_push/Animation/%20FadeAnimation.dart';
import 'package:dbu_push/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/Theme/app_colors.dart';
import '../../utils/helpers/custom_functions.dart.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_button.dart';
import '../Auth/registration_screen.dart';

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
              FadeAnimation(
                1.5,
                OnboardingText(
                    coloredText: 'What ',
                    normalText: 'Are you waiting for ?                      ',
                    lightText: 'join us now!!'),
              ),
              VerticalSpacer(30),
              //Picture
              FadeAnimation(
                3,
                SvgPicture.asset(
                  'assets/images/dbuPush.svg',
                  height: 250,
                  color: AppColors.primaryColor,
                ),
              ),
              FadeAnimation(3,
                  OnboardingText(sloganText: 'Get informed and push forward ')),
              VerticalSpacer(90),

              FadeAnimation(
                4,
                AppButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegistrationScreen();
                    }));
                  },
                  text: 'Get Started Now',
                  height: 60,
                  width: 300,
                  buttonColor: AppColors.primaryColor,
                  fontColor: AppColors.textColor4,
                  fontSize: 20,
                  elevation: 10,
                  buttonShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
