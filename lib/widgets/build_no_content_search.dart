import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuildNoContent extends StatelessWidget {
  const BuildNoContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          SvgPicture.asset(
            'assets/images/undraw_search.svg',
            height: orientation == Orientation.portrait ? 300 : 200,
          ),
        ],
      ),
    );
  }
}
