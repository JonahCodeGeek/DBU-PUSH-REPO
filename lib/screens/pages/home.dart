import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:dbu_push/widgets/circle_button.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
        
          SliverAppBar(
             backgroundColor:AppColors.primaryColor,
            floating: true,
            leading: CircleButton(
                icon: Icons.search, iconSize: 30, onPressed: () {}),
            actions: [
              CircleButton(
                  icon: Icons.account_circle, iconSize: 30, onPressed: () {})
            ],
          ),
        ],
      ),
    );
  }
}
