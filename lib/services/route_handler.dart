import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/models/user.dart';
import 'package:dbu_push/providers/get_current_user.dart';
import 'package:dbu_push/screens/main_screen.dart';

import 'package:dbu_push/screens/pages/page_navigator.dart';
import 'package:dbu_push/utils/helpers/firestore_cloud_reference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HandelAuthentication extends StatefulWidget {
  const HandelAuthentication({super.key});
  @override
  State<HandelAuthentication> createState() => _HandelAuthenticationState();
}

class _HandelAuthenticationState extends State<HandelAuthentication> {
  UserModel? currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!.uid);
            // getCurrentUser(snapshot);
            final user = context.read<GetCurrentUser>();
            user.getCurrentUser(snapshot);
            return PageNavigator(
              // authUser: currentUser,
              authUser: context.watch<GetCurrentUser>().currentUser,
            );
          } else {
            //instead of the auth pages i am return the OnBoardingScreen.
            return OnboardingScreen();
          }
        },
      ),
    );
  }

  // void getCurrentUser(AsyncSnapshot<User?> snapshot) {
  //   final doc = usersDoc.where('email', isEqualTo: snapshot.data?.email).get();
  //   doc.then(
  //     (snapshot) => {
  //       snapshot.docs.forEach((element) async {
  //         setState(() {
  //           currentUser = UserModel.fromDocument(element);
  //         });
  //       })
  //     },
  //   );
  // }
}
