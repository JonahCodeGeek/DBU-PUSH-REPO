import 'package:dbu_push/services/route_handler.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/Theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DbuPush());
}

class DbuPush extends StatelessWidget {
  const DbuPush({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DBU PUSH ',
      theme: appLightTheme(),
      home: HandelAuthentication(),
    );
  }
}
