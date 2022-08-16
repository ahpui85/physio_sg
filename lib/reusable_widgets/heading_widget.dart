import 'package:firebase_signin/constants.dart';

import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String text1;
  final String text2;
  HeadingWidget({required this.text2, required this.text1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02),
      child: Row(
        children: [
          Text(
            text1,
            style: TextStyle(
                color: CustomColors.kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          Expanded(child: Container()),
          Text(
            text2,
            style: TextStyle(
                color: CustomColors.kLightColor,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          )
        ],
      ),
    );
  }
}
