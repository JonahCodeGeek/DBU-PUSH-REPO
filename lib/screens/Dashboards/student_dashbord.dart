// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _HomePageState();
}

class _HomePageState extends State<Student> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('Welcome back student'),
        ),
      ),
    );
  }
}
