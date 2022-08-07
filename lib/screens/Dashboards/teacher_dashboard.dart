// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _HomePageState();
}

class _HomePageState extends State<Teacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('WelcomeBack teacher'),
        ),
      ),
    );
  }
}
