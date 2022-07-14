import 'package:flutter/material.dart';

class Notfications extends StatefulWidget {
  Notfications({Key? key}) : super(key: key);

  @override
  State<Notfications> createState() => _NotficationsState();
}

class _NotficationsState extends State<Notfications> {
  @override
  Widget build(BuildContext context) {
   return Container(
      child: Center(
        child: Text('Notfications page'),
      ),
    );
  }
}