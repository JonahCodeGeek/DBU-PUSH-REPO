// ignore_for_file: sized_box_for_whitespace, unused_import

import 'package:dbu_push/screens/welcome%20screen/welcome_1.dart';
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:dbu_push/utils/helpers/custom_functions.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'welcome screen/welcome_2.dart';
import 'welcome screen/welcome_3.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List screens = [
    WelcomeScreenOne(),
    WelcomeScreenTwo(),
    WelcomeScreenThree(),
  ];
  //stream builder will be returned here.
  @override
  Widget build(BuildContext context) {
    //this is to set it to full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      itemCount: screens.length,
      itemBuilder: (_, sliderIndex) {
        return Stack(
          children: [
            //This is for display onboarding screens
            Container(
              width: double.maxFinite,
              height: double.maxFinite,
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
                      padding: EdgeInsets.only(right: 10, bottom: 3),
                      child: Container(
                        width: 8,
                        height: sliderIndex == indicatorIndex ? 24 : 8,
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
