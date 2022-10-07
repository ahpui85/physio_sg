import 'package:flutter/material.dart';
import 'package:firebase_signin/screens/camera_screen.dart';

class InstructionWidget extends StatefulWidget {
  const InstructionWidget({Key? key, required bool pp}) : super(key: key);

  @override
  State<InstructionWidget> createState() => _InstructionWidgetState();
}

class _InstructionWidgetState extends State<InstructionWidget> {
  bool pp = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 25.0,
            child: null,
          ),
          const Text(
            "Exercise",
            style: TextStyle(fontSize: 35, color: Colors.black),
          ),
          Container(
            //color: Colors.amber,
            margin: const EdgeInsets.only(left: 50, right: 30, bottom: 10),
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Stand with  both arms straightened by the side. Stretch out affected arm, with fingers stretched towards the floor. Keep shoulder lowered towards floor. Slowyly tilt head to good. Hold position for 5 seconds. Repeat 5 times.',
              style: TextStyle(fontSize: 30, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(
            height: 1.0,
            child: null,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                //_instructionIsOn = !_instructionIsOn;
                pp = !pp;
              });
            },
            child: Container(
              height: 60,
              width: 200,
              //color: Colors.amber,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: const Text(
                'START!',
                style: TextStyle(fontSize: 35, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      )),
    );
  }
}
