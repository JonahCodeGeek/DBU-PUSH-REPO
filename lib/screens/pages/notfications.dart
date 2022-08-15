import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/Theme/app_colors.dart';

class Notfications extends StatefulWidget {
  const Notfications({Key? key}) : super(key: key);

  @override
  State<Notfications> createState() => _NotficationsState();
}

class _NotficationsState extends State<Notfications> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColors.scaffoldColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Center(
        child: Text('Notfications page'),
      ),
    );
  }
}
