import 'package:flutter/material.dart';
import 'package:firebase_signin/model/days.dart';
import 'package:firebase_signin/constants.dart';
import 'package:firebase_signin/reusable_widgets/reusable_widget.dart';
import 'package:firebase_signin/reusable_widgets/heading_widget.dart';
//import 'package:firebase_signin/preview.dart';
import 'package:firebase_signin/screens/instruc_to_preview.dart';
import 'package:firebase_signin/pose_mask_painter.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../model/exercise_list.dart';
import '../widget/exercise_box_widget.dart';
import 'home_screen.dart';

class GeneralExercise extends StatelessWidget {
  GeneralExercise({Key? key}) : super(key: key);
  final items = Exercise.getExercises();
  //final clockPosition = false;

  @override
  Widget build(BuildContext context) {
    clockPosition = false;
    FlutterRingtonePlayer.stop();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.blueAccent,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Icon(
              Icons.notifications,
              size: 30,
              color: Colors.blueAccent,
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.redAccent,
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: [buildActivitySection(context)],
        ),
      ),
    );
  }

  Widget buildActivitySection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: CustomColors.kBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      // Ideally these cards should be the data fetched from API or they have a specific model but for simplicity let's just go like this :)

      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        const HeadingWidget(
          text1: 'ACTIVITY',
          text2: 'Show All',
        ),
        Expanded(
          child: ListView.builder(
            //shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ExerciseBox(item: items[index]);
            },
          ),
        ),
      ]),
    );
  }
}
