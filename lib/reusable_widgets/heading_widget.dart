import 'package:firebase_signin/constants.dart';

import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String text1;
  final String text2;
  const HeadingWidget({Key? key, required this.text2, required this.text1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: CustomColors.kBackgroundColor,
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Text(
              text1,
              style: const TextStyle(
                  color: CustomColors.kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Expanded(
                child: Container(
              color: CustomColors.kBackgroundColor,
            )),
            Text(
              text2,
              style: const TextStyle(
                  color: CustomColors.kLightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
