import 'package:dbu_push/screens/welcome%20screen/welcome_1.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return PageView.builder(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      itemCount: screens.length,
      itemBuilder: (_, index) {
        return (screens[index]);
      },
    );
  }
}
