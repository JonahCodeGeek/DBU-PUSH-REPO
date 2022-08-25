// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbu_push/screens/auth/otp_login.dart';
import 'package:dbu_push/screens/auth/otp_registration.dart';
import 'package:dbu_push/screens/dashboards/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/dashboards/other_dashbord.dart';
import '../screens/dashboards/student_dashbord.dart';
import '../utils/helpers/custom_functions.dart.dart';

class AuthenticationService {
  final FirebaseAuth _auth;
  final BuildContext context;
  String _verificationId = '';
  //authentication and database AuthenticationService.
  final database = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance;
  AuthenticationService(this._auth, this.context);
  //condition one
  chkPass(String pass1, String pass2) {
    if (pass1 == pass2) {
      if (pass1.length >= 6 && pass2.length >= 6) {
        return true;
      }
      return showSnackBar(
          context, 'Password must be at least 6 characters long', Colors.red);
    } else {
      return false;
    }
  }

  Future<void> registerUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> updateInfoCase(String email) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final user = FirebaseAuth.instance.currentUser!;
    await database
        .collection('users')
        .where('isActive', isEqualTo: false)
        .where('email', isEqualTo: email)
        .get()
        .then(
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((document) async {
              user.sendEmailVerification();

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(document.id)
                  .update({'isActive': true, 'id':uid});
              //why you pop it here bro ??
              Navigator.of(context).pop();
              return showSnackBar(
                  context,
                  'successfully registered. Please check your email and verify your account !',
                  Colors.green);
            }),
          },
        );
  }

  Future<void> updateInfoCase2(String phoneNumber) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    //do the query
    await database
        .collection('users')
        .where('isActive', isEqualTo: false)
        .where('phone', isEqualTo: phoneNumber)
        .get()
        .then((snapshot) => {
              snapshot.docs.forEach((documents) async {
                await database
                    .collection('users')
                    .doc(documents.id)
                    .update({'isActive': true, 'id':uid});
                showSnackBar(context, 'successfully registered', Colors.green);
                Navigator.of(context).pop();
              })
            });
  }

  //condition two
  withEmailAndPassword({
    required String email,
    required String password1,
    required String confirmedPass,
    required BuildContext context,
  }) async {
    final query1 =
        database.collection('users').where('email', isEqualTo: email);
    final query2 = database
        .collection('users')
        .where('isActive', isEqualTo: false)
        .where('email', isEqualTo: email);
    final result1 = await query1.get();
    final result12 = await query2.get();

    // create a user and an active_account object
    final userEmail = result1.docs;
    final activeAccount = result12.docs;

    // print(activeAccount.single.exists);
    if (userEmail.isNotEmpty) {
      if (activeAccount.isEmpty) {
        return showSnackBar(context, 'account already active', Colors.red);
      }
      try {
        //validateAccount
        if (chkPass(password1, confirmedPass)) {
          await registerUserWithEmailAndPassword(
            email: email,
            password: password1,
          );
          return updateInfoCase(email);

          //Activate the user data

        }
        return showSnackBar(context, 'Password do not match', Colors.red);
      } on FirebaseAuthException catch (e) {
        return showSnackBar(context, e.message, Colors.red);
      }
    }
    return showSnackBar(context,
        'This  email is not registered in Debrebrihan University', Colors.red);
  }

  //send password reset link
  Future<void> sendPasswordResetLink(String email) async {
    //conditions must be checked before sending the actual link
    try {
      await firebaseUser.sendPasswordResetEmail(email: email);
      return showSnackBar(
        context,
        'We have sent a password reset link to $email',
        Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      return showSnackBar(context, e.message, Colors.red);
    }
  }

  Future<void> getOtp1(String phoneNumber) async {
    await firebaseUser.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ignore: unrelated_type_equality_checks
        return await _auth.signInWithCredential(credential).then((value) {});
      },
      verificationFailed: (e) {
        showAlertDialog(context, e.message.toString(), Colors.red, true);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return RegistrationOtpPrompt(
                  phoneNumber: phoneNumber, verificationId: _verificationId);
            },
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> getOtp2(String phoneNumber) async {
    await firebaseUser.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ignore: unrelated_type_equality_checks
        return await _auth.signInWithCredential(credential).then((value) {});
      },
      verificationFailed: (e) {
        showAlertDialog(context, e.message.toString(), Colors.red, true);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginOtpPrompt(
                  phoneNumber: phoneNumber, verificationId: _verificationId);
            },
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  withPhoneNumber({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    //does phone number exists?
    final query1 =
        database.collection('users').where('phone', isEqualTo: phoneNumber);
    final query2 = database
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .where('isActive', isEqualTo: false);
    //getting the document
    final result1 = await query1.get();
    final result2 = await query2.get();
    final userIsValid = result1.docs;
    final userIsActive = result2.docs;
    if (userIsValid.isNotEmpty) {
      if (userIsActive.isNotEmpty) {
        return getOtp1(phoneNumber);
      }
      return showAlertDialog(
          context, 'Account is already active', Colors.red, true);
    }
    return showAlertDialog(context, 'user does not exist', Colors.red, true);

    //is the account with the specified info active?
    //send the otp and update the info to the registration screen
  }

  withPhoneNumberLogin({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    //does phone number exists?
    final query1 =
        database.collection('users').where('phone', isEqualTo: phoneNumber);
    final query2 = database
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .where('isActive', isEqualTo: true);
    //getting the document
    final result1 = await query1.get();
    final result2 = await query2.get();
    final userIsValid = result1.docs;
    final userIsActive = result2.docs;
    if (userIsValid.isNotEmpty) {
      if (userIsActive.isNotEmpty) {
        return getOtp2(phoneNumber);
      }
      return showAlertDialog(
          context,
          'This account is not active yet. Please Register first in order to activate it.',
          Colors.red,
          true);
    }
    return showAlertDialog(
        context,
        'There is no user registered with phone number $phoneNumber',
        Colors.red,
        true);

    //is the account with the specified info active?
    //send the otp and update the info to the registration screen
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      showSnackBar(context, 'logged in Successfully', Colors.green);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      return showSnackBar(context, e.message, Colors.red);
    }
  }

  authorize(String userID) {
    final query1 = database
        .collection('users')
        .where('id', isEqualTo: userID)
        .where('isActive', isEqualTo: true)
        .where('role', isEqualTo: 'student');
    final query2 = database
        .collection('users')
        .where('id', isEqualTo: userID)
        .where('isActive', isEqualTo: true)
        .where('role', isEqualTo: 'teacher');
    final query3 = database
        .collection('users')
        .where('id', isEqualTo: userID)
        .where('isActive', isEqualTo: true)
        .where('role', isEqualTo: 'other');
    //getting the above query results
    query1.get().then((value) async {
      if (value.docs.isNotEmpty) {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Student();
            },
          ),
        );
      }
    });
    query2.get().then((value) async {
      if (value.docs.isNotEmpty) {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Teacher();
            },
          ),
        );
      }
    });
    query3.get().then((value) async {
      if (value.docs.isNotEmpty) {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Other();
            },
          ),
        );
      }
    });
    //do access control
  }

  Future<void> signOut() async {
    return await firebaseUser.signOut();
  }
}
