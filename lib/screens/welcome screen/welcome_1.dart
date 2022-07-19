// ignore_for_file: sized_box_for_whitespace
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:dbu_push/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/Theme/app_colors.dart';
import '../../utils/helpers/custom_functions.dart.dart';

class WelcomeScreenOne extends StatelessWidget {
  const WelcomeScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldColor,
      child: Column(
        children: [
          VerticalSpacer(70),
          //Picture
          SvgPicture.asset(
            'assets/images/undraw_personal_text.svg',
            height: 250,
          ),
          //Header text
          VerticalSpacer(200),
          Column(
            children: [
              //Header text
              OnboardingText(
                  coloredText: 'Never ',
                  normalText: 'Miss A Notification       ',
                  lightText: 'with the help of instant push notifications'
                      ' you won’t miss any information from your channel.'),
              VerticalSpacer(30),
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Skip >',
                      style: GoogleFonts.roboto(
                        color: AppColors.textColor1,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
