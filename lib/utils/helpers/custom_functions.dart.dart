// ignore_for_file: non_constant_identifier_names, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

//horizontal spacer
Widget HorizontalSpacer(double width) {
  return SizedBox(width: width);
}

//vertical spacer
Widget VerticalSpacer(double height) {
  return SizedBox(height: height);
}

//method to show a snackbar for the entire application
showSnackBar(BuildContext context, String? message, Color? color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message!,
      style: GoogleFonts.roboto(
        fontSize: 14,
      ),
    ),
    backgroundColor: color ?? Colors.red,
    duration: Duration(seconds: 5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  ));
}

//custom alert dialog
showAlertDialog(
  BuildContext context,
  String message,
  Color? color,
  bool? dismissible,
) {
  return showDialog(
    barrierDismissible: dismissible ?? true,
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 0,
        // ignore: prefer_const_literals_to_create_immutables

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: Text(
          message,
          style: GoogleFonts.roboto(
            color: color,
            fontSize: 14,
          ),
        ),
      );
    },
  );
}
