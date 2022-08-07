// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class Other extends StatefulWidget {
  const Other({Key? key}) : super(key: key);

  @override
  State<Other> createState() => _HomePageState();
}

class _HomePageState extends State<Other> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('Welcome back spacial user'),
        ),
      ),
    );
  }
}
