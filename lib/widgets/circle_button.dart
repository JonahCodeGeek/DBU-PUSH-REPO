import 'package:dbu_push/utils/Theme/app_colors.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Function() onPressed;
  const CircleButton(
      {required this.icon, required this.iconSize, required this.onPressed});

 
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6),
      decoration:
          BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
      child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: iconSize,
          )),
    );
  }
}

 Widget buildIconButton(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 20,
          ),
        ),
      );
  Widget buildCircle(
          {required Widget child, required double all, required Color color}) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
