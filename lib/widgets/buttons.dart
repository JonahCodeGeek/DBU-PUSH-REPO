
import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ElevatedButtons extends StatefulWidget {
  const ElevatedButtons(
      {required this.label, required this.function,});
  final String label;
  final Function() function;

  @override
  State<ElevatedButtons> createState() => _ElevatedButtonsState();
}

class _ElevatedButtonsState extends State<ElevatedButtons> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 45,
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
          onPressed: widget.function,
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0.0),
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColors.primaryColor),
          ),
          child: Text(
            widget.label,
            style: TextStyle(color: AppColors.textColor1),
          ),
        )
        );
  }
}

Widget buildProfileBody(Function() handleUpdate) {
  return Center(
    child: Column(
      children: [
        SizedBox(height: 32),
        ElevatedButtons(
          label: 'Update Profile',
          function: handleUpdate,
        ),
        SizedBox(
          height: 30,
          child: Text(
            'Or',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                color: Colors.grey,
                fontStyle: FontStyle.italic),
          ),
        ),
        ElevatedButtons(
          label: 'logout',
          function: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ],
    ),
  );
}
