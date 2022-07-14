import 'package:flutter/material.dart';

class PrivateChannels extends StatefulWidget {
  PrivateChannels({Key? key}) : super(key: key);

  @override
  State<PrivateChannels> createState() => _PrivateChannelsState();
}

class _PrivateChannelsState extends State<PrivateChannels> {
  @override
  Widget build(BuildContext context) {
   return Container(
      child: Center(
        child: Text('private channel pages '),
      ),
    );
  }
}