import 'package:firebase_signin/pose_mask_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Results extends StatefulWidget {
  const Results({Key? key, required this.videoName, required this.rating})
      : super(key: key);
  final String videoName;
  final double rating;

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  late String toVideoName1;
  late double percentage;
  late int percentage1;
  late double rating1;

  @override
  void initState() {
    super.initState();
    toVideoName1 = widget.videoName;
    rating1 = widget.rating;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    percentage = _percentage(toVideoName1);
    percentage1 = (percentage * 100).toInt();
    clockPosition = false;
    FlutterRingtonePlayer.stop();
    return Scaffold(
      //backgroundColor: Colors.deepPurple[100],
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 2),
              padding: const EdgeInsets.all(2),
              child: const Text(
                'Hello, Jane',
                style: TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              padding: const EdgeInsets.all(10),
              child: const Text(
                'It is a great day for a workout!',
                style: TextStyle(fontSize: 20, color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
            CircularPercentIndicator(
              animation: true,
              animationDuration: 1000,
              radius: 100,
              lineWidth: 20,
              header: const Text(
                'Exercise',
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
              percent: percentage,
              progressColor: Colors.deepPurple,
              backgroundColor: Colors.deepPurple.shade200,
              circularStrokeCap: CircularStrokeCap.round,
              center: Text(percentage1.toString() + '%',
                  style: const TextStyle(fontSize: 30)),
            ),
            const SizedBox(
              height: 50,
            ),
            CircularPercentIndicator(
              animation: true,
              animationDuration: 1000,
              radius: 100,
              lineWidth: 20,
              percent: rating1,
              header: const Text(
                'Pain Relief',
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
              progressColor: Colors.deepPurple,
              backgroundColor: Colors.deepPurple.shade200,
              circularStrokeCap: CircularStrokeCap.round,
              center: const Text('50%', style: TextStyle(fontSize: 30)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Back',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
        ],
      ),
    );
  }

  _percentage(String toVideoName1) {
    if (toVideoName1 == 'seated_thoracic.mp4') {
      double percent = 0.25;

      return percent;
    } else if (toVideoName1 == 'middle_scalene.mp4') {
      double percent = 0.5;

      return percent;
    } else if (toVideoName1 == 'neck_extension.mp4') {
      double percent = 0.75;

      return percent;
    } else if (toVideoName1 == 'neck_right.mp4') {
      double percent = 0.75;

      return percent;
    } else if (toVideoName1 == 'seatedTrunk.mp4') {
      double percent = 1;

      return percent;
    }
  }
}
