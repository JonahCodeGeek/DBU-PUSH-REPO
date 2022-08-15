// ignore_for_file: prefer_const_constructors_in_immutables, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:dbu_push/Animation/%20FadeAnimation.dart';
import 'package:dbu_push/screens/Auth/login_screen.dart';
import 'package:dbu_push/utils/helpers/custom_functions.dart.dart';
import 'package:dbu_push/widgets/app_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth_methods.dart';
import '../../utils/Theme/app_colors.dart';
import '../../widgets/app_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  final String? phoneNumber = '';
  final String? vid = '';
  RegistrationScreen({Key? key, phoneNumber, vid}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController1 = TextEditingController();
  final otpController2 = TextEditingController();
  final otpController3 = TextEditingController();
  final otpController4 = TextEditingController();
  final otpController5 = TextEditingController();
  final otpController6 = TextEditingController();

  bool isPhoneVisible = true;
  bool isOtpVisible = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController1.dispose();
    otpController2.dispose();
    otpController3.dispose();
    otpController4.dispose();
    otpController5.dispose();
    otpController6.dispose();
    phoneController.dispose();
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
  }

  registerUserWithEmail() async {
    await AuthenticationService(FirebaseAuth.instance, context)
        .withEmailAndPassword(
      confirmedPass: confirmPasswordController.text.trim(),
      context: context,
      email: emailController.text.trim(),
      password1: passwordController.text.trim(),
    );
  }

  registerWithPhone() async {
    await AuthenticationService(FirebaseAuth.instance, context).withPhoneNumber(
      context: context,
      phoneNumber: phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SingleChildScrollView(
        physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
        child: FadeAnimation(
          1,
          Column(children: [
            VerticalSpacer(40),
            SvgPicture.asset(
              'assets/images/dbuPush.svg',
              height: 170,
              color: AppColors.primaryColor,
            ),
            AppTextField(
              controller: emailController,
              hint: 'Enter Your Email Address',
              keyboard: TextInputType.emailAddress,
              leftIcon: Icon(Icons.email_outlined),
            ),
            VerticalSpacer(20),
            AppTextField(
              controller: passwordController,
              hint: 'Enter your Password',
              keyboard: TextInputType.text,
              hideText: true,
              leftIcon: Icon(Icons.lock_outline),
            ),
            VerticalSpacer(20),
            AppTextField(
              controller: confirmPasswordController,
              hint: 'Confirm your password',
              keyboard: TextInputType.text,
              hideText: true,
              leftIcon: Icon(Icons.lock_outline),
              action: TextInputAction.done,
            ),
            VerticalSpacer(30),
            AppButton(
              onPressed: () {
                registerUserWithEmail();
              },
              text: 'Register',
              width: 340,
              height: 55,
              buttonColor: AppColors.primaryColor,
              fontColor: AppColors.textColor4,
              fontSize: 20,
              buttonShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            VerticalSpacer(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: Divider(
                    thickness: .5,
                    color: AppColors.textColor2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text('Or continue with',
                      style: GoogleFonts.roboto(
                        fontSize: 17,
                      )),
                ),
                SizedBox(
                  width: 100,
                  child: Divider(
                    thickness: .5,
                    color: AppColors.textColor2,
                  ),
                ),
              ],
            ),
            VerticalSpacer(20),
            CircleAvatar(
              backgroundColor: AppColors.primaryColor.withOpacity(0.05),
              radius: 33,
              child: IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    isDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return FadeAnimation(
                        0.2,
                        Container(
                          height: 500,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Visibility(
                                maintainState: true,
                                visible: isPhoneVisible,
                                //phone prompt section
                                child: Column(
                                  children: [
                                    VerticalSpacer(30),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'We will send you a verification code to ${phoneController.text.trim()}',
                                        style: GoogleFonts.roboto(
                                          color: AppColors.primaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    VerticalSpacer(30),
                                    AppTextField(
                                      // onChanged: () {
                                      //   setState(() {
                                      //     isPhoneVisible = false;
                                      //     isOtpVisible = true;
                                      //   });
                                      // },
                                      controller: phoneController,
                                      leftIcon: Icon(Icons.phone),
                                      hint: 'Enter your phone number (+251)',
                                      keyboard: TextInputType.phone,
                                      action: TextInputAction.send,
                                    ),
                                    VerticalSpacer(30),
                                    AppButton(
                                      onPressed: () {
                                        // setState(() async {
                                        //   isPhoneVisible = false;
                                        //   isOtpVisible = true;
                                        // });
                                        registerWithPhone();
                                      },
                                      text: 'Get code',
                                      width: 340,
                                      height: 60,
                                      buttonColor: AppColors.primaryColor,
                                      fontColor: AppColors.textColor4,
                                      fontSize: 20,
                                      buttonShape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(9)),
                                    ),
                                    VerticalSpacer(30),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.phone),
                iconSize: 30,
                color: AppColors.primaryColor,
              ),
            ),
            VerticalSpacer(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                'By continuing, you agree to DBU-PUSH Terms of use and Privacy Policy',
                style: GoogleFonts.roboto(
                    color: AppColors.textColor3.withOpacity(.9), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            VerticalSpacer(79.8),
            Align(
              alignment: Alignment.bottomCenter,
              child: AppButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ));
                },
                text: 'Already have an account ? Login',
                width: double.maxFinite,
                height: 65,
                buttonColor: AppColors.textColor4.withOpacity(.8),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
