import 'package:flutter/material.dart';

import '../model/exercise_list.dart';
import '../widget/asset_player_widget.dart';

class VideoInfo extends StatefulWidget {
  const VideoInfo({Key? key, required this.item}) : super(key: key);
  final Exercise item;
  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  late String videoName1;
  late String title1;
  late String detailExercise1;
  late String bodyArea1;
  late String movementType1;

  //final items = Exercise.getExercises();
  //final Exercise item;
  @override
  void initState() {
    super.initState();
    videoName1 = widget.item.videoPath;
    title1 = widget.item.title;
    detailExercise1 = widget.item.detailExercise;
    bodyArea1 = widget.item.bodyArea;
    movementType1 = widget.item.movementType;
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Column(
        children: [
          RotatedBox(
            quarterTurns: 3,
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: AssetPlayerWidget(name: videoName1)),
          ),
          Details(),
        ],
      )),
    );
  }

  Widget Details() => Expanded(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            //color: Colors.amber,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: const EdgeInsets.all(10),
            child: Text(
              title1,
              style: const TextStyle(fontSize: 25, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            //color: Colors.amber,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: const EdgeInsets.all(10),
            child: Text(
              detailExercise1,
              style: const TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ),
          Container(
            //color: Colors.amber,
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            padding: const EdgeInsets.all(10),
            child: const Text(
              'BODY AREA',
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ),
          Container(
            //color: Colors.amber,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: const EdgeInsets.all(10),
            child: Text(
              bodyArea1,
              style: const TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ),
          Container(
            //color: Colors.amber,
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            padding: const EdgeInsets.all(10),
            child: const Text(
              'MOVEMENT TYPE',
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ),
          Container(
            //color: Colors.amber,
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              movementType1,
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ));
}
