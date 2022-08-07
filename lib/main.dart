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
<<<<<<< HEAD
      home: HandelAuthentication(),
=======
      home:MainPage(),
>>>>>>> b748a7dd281c4f94f1b6c8385c9f86f49d15e018
    );
  }
}
