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
      margin: EdgeInsets.fromLTRB(0.0,12,0,0),
      decoration:
          BoxDecoration(color:Colors.transparent, shape: BoxShape.circle),
      child: IconButton(
        // color: Colors.white,
        color: Colors.black,
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
