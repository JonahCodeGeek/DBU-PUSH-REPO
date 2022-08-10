// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:dbu_push/services/auth_methods.dart';
import 'package:dbu_push/widgets/app_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/Theme/app_colors.dart';
import '../../utils/helpers/custom_functions.dart.dart';
import '../../widgets/app_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.scaffoldColor,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  }

  //SendPasswordResetLink logic
  void sendPasswordResetLink() {
    AuthenticationService(FirebaseAuth.instance, context)
        .sendPasswordResetLink(emailController.text.trim());
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              VerticalSpacer(10),
              SvgPicture.asset(
                'assets/images/dbuPush.svg',
                height: 270,
                color: AppColors.primaryColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  textAlign: TextAlign.start,
                  'Enter your email address which you used when you first registered on the App',
                  style: GoogleFonts.roboto(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              VerticalSpacer(30),
              Column(
                children: [
                  AppTextField(
                    controller: emailController,
                    hint: 'Enter Your Email Address',
                    leftIcon: Icon(Icons.email_outlined),
                    action: TextInputAction.send,
                  ),
                  VerticalSpacer(30),
                  AppButton(
                    onPressed: () {
                      setState(() {});
                      sendPasswordResetLink();
                    },
                    text: 'Send',
                    width: 340,
                    height: 55,
                    buttonColor: AppColors.primaryColor,
                    fontColor: AppColors.textColor4,
                    fontSize: 20,
                    buttonShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
