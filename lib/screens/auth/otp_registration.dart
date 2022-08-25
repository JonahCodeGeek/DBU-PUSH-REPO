// ignore_for_file: unnecessary_const

import 'package:dbu_push/utils/helpers/custom_functions.dart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth_methods.dart';
import '../../utils/Theme/app_colors.dart';
import '../../widgets/app_button.dart';

class RegistrationOtpPrompt extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const RegistrationOtpPrompt(
      {Key? key, required this.verificationId, required this.phoneNumber})
      : super(key: key);

  @override
  State<RegistrationOtpPrompt> createState() => _OtpPromptState();
}

class _OtpPromptState extends State<RegistrationOtpPrompt> {
  final otpController1 = TextEditingController();
  final otpController2 = TextEditingController();
  final otpController3 = TextEditingController();
  final otpController4 = TextEditingController();
  final otpController5 = TextEditingController();
  final otpController6 = TextEditingController();

  final _auth = FirebaseAuth.instance;
  //verifying code logic
  void verifyCode() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp[0].text.trim() +
            otp[1].text.trim() +
            otp[2].text.trim() +
            otp[3].text.trim() +
            otp[4].text.trim() +
            otp[5].text.trim(),
      );
      //this is where we will update the informations.

      await _auth.signInWithCredential(credential).then((value) async {
        return await AuthenticationService(FirebaseAuth.instance, context)
            .updateInfoCase2(widget.phoneNumber);
      });
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'invalid-verification-id':
          showSnackBar(
              context,
              'Please enter the code sent to ${widget.phoneNumber}',
              Colors.red);
          break;
        case 'invalid-verification-code':
          showSnackBar(context, 'Wrong verification code !!', Colors.red);
          break;
        default:
          showSnackBar(context, e.message, Colors.red);
      }
    }
  }

//List of controllers
  final List<TextEditingController> otp = [];
//this method adds all the otp controllers on startup.
  addNo() {
    otp.addAll({
      otpController1,
      otpController2,
      otpController3,
      otpController4,
      otpController5,
      otpController6,
    });
  }

  @override
  void initState() {
    super.initState();
    addNo();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: AppColors.scaffoldColor,
    //   statusBarIconBrightness: Brightness.dark,
    //   statusBarBrightness: Brightness.light,
    // ));
  }

  @override
  void dispose() {
    super.dispose();
    otpController1.dispose();
    otpController2.dispose();
    otpController3.dispose();
    otpController4.dispose();
    otpController5.dispose();
    otpController6.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              VerticalSpacer(150),
              Center(
                child: Text(
                  'Enter the code we sent to ${widget.phoneNumber}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(fontSize: 30),
                ),
              ),
              VerticalSpacer(20),
              //Otp verification section
              Column(
                children: [
                  VerticalSpacer(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: List.generate(
                          otp.length,
                          (inputIndex) {
                            return Container(
                              margin: EdgeInsets.all(4),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TextField(
                                controller: otp[inputIndex],
                                autofocus: true,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                keyboardType: TextInputType.number,
                                keyboardAppearance: Brightness.dark,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  VerticalSpacer(30),
                  AppButton(
                    onPressed: () {
                      verifyCode();
                    },
                    text: 'Verify code',
                    width: 340,
                    height: 60,
                    buttonColor: AppColors.primaryColor,
                    fontColor: AppColors.textColor4,
                    fontSize: 20,
                    buttonShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  VerticalSpacer(20),
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          "Didn't receive a code ?",
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            '  Resend code.',
                            style: GoogleFonts.roboto(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
