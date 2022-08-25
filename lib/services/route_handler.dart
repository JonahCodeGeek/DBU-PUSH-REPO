import 'package:dbu_push/providers/get_current_user.dart';
import 'package:dbu_push/screens/main_screen.dart';

import 'package:dbu_push/screens/pages/page_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HandelAuthentication extends StatefulWidget {
  const HandelAuthentication({super.key});
  @override
  State<HandelAuthentication> createState() => _HandelAuthenticationState();
}

class _HandelAuthenticationState extends State<HandelAuthentication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Builder(
        builder: (context) {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data!.uid);
                final user = context.read<GetCurrentUser>();
                user.getCurrentUser(snapshot);
                return PageNavigator(
                  authUser: context.watch<GetCurrentUser>().currentUser,
                );
              } else {
                //instead of the auth pages i am return the OnBoardingScreen.
                return OnboardingScreen();
              }
            },
          );
        }
      )
    );
  }
}
