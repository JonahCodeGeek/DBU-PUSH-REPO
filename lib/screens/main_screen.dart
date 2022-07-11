import 'package:dbu_push/widgets/app_text.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
//stream builder will be returned here.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              AppText.HeaderText('Title text'),
              AppText.ContentText(
                  'This is the paragraph text This is the paragraph textThis is the paragraph text'
                  'This is the paragraph text This is the paragraph text This is the paragraph text'
                  'This is the paragraph text'),
              AppText.ReferenceText(
                  'This will be a fade out text like @Jonah code'),
              ElevatedButton(
                  onPressed: () => {},
                  child: Text('This will be a fade out text like @Jonah code'))
            ],
          ),
        ),
      ),
    );
  }
}
