import 'dart:ffi';

import 'package:firebase_signin/model/rom_list.dart';
import 'package:flutter/material.dart';
import '../pose_mask_painter.dart';
import '../screens/camera_rom.dart';

class MeasurementTest extends StatefulWidget {
  const MeasurementTest({Key? key, required this.name}) : super(key: key);
  final String name;
  @override
  State<MeasurementTest> createState() => _MeasurementTestState();
}

class _MeasurementTestState extends State<MeasurementTest> {
  final items = RomStack.getRomStack();
  late String sideIndicator;
  late String sideIndicator2;
  late int flexValue;
  late String rsideIndicator;
  late String rsideIndicator2;
  late int rflexValue;
  //var degree1 = Runes('\u00a9');
  String degree = String.fromCharCodes([0x00B0]);
  //final String degree = '\u00a9';

  @override
  Widget build(BuildContext context) {
    switch (widget.name) {
      case 'seated_shoulder_flexion.mp4':
        sideIndicator = items[0].sideIndicator;
        sideIndicator2 = items[0].sideIndicator2;
        flexValue = maxFlexion;
        rsideIndicator = items[1].sideIndicator;
        rsideIndicator2 = items[1].sideIndicator2;
        rflexValue = maxFlexion2;
        break;
      case 'elbow_flexion.mp4':
        sideIndicator = items[0].sideIndicator;
        sideIndicator2 = items[0].sideIndicator2;
        flexValue = leftElbowFlexion;
        rsideIndicator = items[1].sideIndicator;
        rsideIndicator2 = items[1].sideIndicator2;
        rflexValue = rightElbowFlexion;
        break;
    }
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        RotatedBox(
            quarterTurns: 1,
            child: Column(
              children: [
                Text(
                  sideIndicator,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0),
                ),
                Text(
                  sideIndicator2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0),
                ),
                Text(
                  '$flexValue$degree',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0),
                ),
              ],
            )),
        const SizedBox(
          height: 520,
        ),
        Positioned(
          bottom: 30,
          right: 15,
          child: Align(
            alignment: Alignment.bottomRight,
            child: RotatedBox(
                quarterTurns: 1,
                child: Column(
                  children: [
                    Text(
                      rsideIndicator,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0),
                    ),
                    Text(
                      rsideIndicator2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0),
                    ),
                    Text(
                      '$rflexValue$degree',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
