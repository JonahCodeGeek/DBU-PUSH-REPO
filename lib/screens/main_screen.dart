// ignore_for_file: sized_box_for_whitespace, unused_import

import 'package:dbu_push/screens/welcome%20screen/welcome_1.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:dbu_push/utils/helpers/custom_functions.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'welcome screen/welcome_2.dart';
import 'welcome screen/welcome_3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _MainPageState();
}

class _MainPageState extends State<OnboardingScreen> {
  final List screens = [
    WelcomeScreenOne(),
    WelcomeScreenTwo(),
    WelcomeScreenThree(),
  ];
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.scaffoldColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
  }

  //stream builder will be returned here.
  @override
  Widget build(BuildContext context) {
    //this is to set it to full screen

    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      itemCount: screens.length,
      itemBuilder: (_, sliderIndex) {
        return Stack(
          children: [
            //This is for display onboarding screens
            Container(
              child: screens[sliderIndex],
            ),

            //This is for the indicators
            Container(
              margin: EdgeInsets.only(top: 150),
              alignment: Alignment.topRight,
              child: Column(
                children: List.generate(
                  3,
                  (indicatorIndex) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10, bottom: 4),
                      child: Container(
                        width: 8,
                        height: sliderIndex == indicatorIndex ? 25 : 8,
                        decoration: BoxDecoration(
                          color: sliderIndex == indicatorIndex
                              ? AppColors.primaryColor
                              : AppColors.primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
