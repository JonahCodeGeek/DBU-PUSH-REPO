// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:dbu_push/animation/%20fade_animation.dart';
import 'package:dbu_push/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/Theme/app_colors.dart';
import '../../utils/helpers/custom_functions.dart.dart';
import '../auth/registration_screen.dart';

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
          FadeAnimation(
            1.5,
            SvgPicture.asset(
              'assets/images/undraw_personal_text.svg',
              height: 250,
            ),
          ),
          //Header text
          VerticalSpacer(170),
          Column(
            children: [
              //Header text
              FadeAnimation(
                3,
                OnboardingText(
                    coloredText: 'Never ',
                    normalText: 'Miss A Notification       ',
                    lightText: 'with the help of instant push notifications'
                        ' you won’t miss any information from your channel.'),
              ),
              VerticalSpacer(54),
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return RegistrationScreen();
                        },
                      ));
                    },
                    child: FadeAnimation(
                      4,
                      Text(
                        'Skip >',
                        style: GoogleFonts.roboto(
                          color: AppColors.textColor1,
                          fontSize: 24,
                        ),
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
