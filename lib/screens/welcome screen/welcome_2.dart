// ignore_for_file: sized_box_for_whitespace
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:dbu_push/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/Theme/app_colors.dart';
import '../../utils/helpers/custom_functions.dart.dart';

class WelcomeScreenTwo extends StatelessWidget {
  const WelcomeScreenTwo({Key? key}) : super(key: key);

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
                  coloredText: 'No ',
                  normalText: 'More       Fake News                     ',
                  lightText: 'Get informed directly from'
                      ' the    people you trust in the university.'),
              VerticalSpacer(90),
              //Picture
              SvgPicture.asset(
                'assets/images/undraw_educator.svg',
                height: 250,
              ),
              VerticalSpacer(180),
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
