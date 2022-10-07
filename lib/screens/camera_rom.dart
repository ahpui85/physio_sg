import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_signin/screens/results.dart';
import 'package:flutter/material.dart';
import 'package:firebase_signin/pose_mask_painter.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/body_detection.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:body_detection/models/image_result.dart';
import 'package:firebase_signin/widget/asset_player_widget.dart';
//import 'package:firebase_signin/screens/exercise_screen.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:firebase_signin/model/exercise_list.dart';

import '../widget/favourite_relief_widget.dart';
import '../widget/instruction_widget.dart';
import '../widget/measurement_text.dart';
import 'general_exercise.dart';

class CameraRom extends StatefulWidget {
  const CameraRom({Key? key, required this.videoName}) : super(key: key);
  final String videoName;
  //final Exercise item;
  @override
  State<CameraRom> createState() => _CameraRomState();
}

class _CameraRomState extends State<CameraRom> {
  //late final Exercise item;
  late String toVideoName1;
  final items = Exercise.getExercises();
  TextToSpeech tts = TextToSpeech();
  final bool _isDetectingPose = true;
  final bool _instructionIsOn = false;
  final CountDownController _controller = CountDownController();

  Pose? _detectedPose;
  //ui.Image? _maskImage;
  Image? _cameraImage;
  Size _imageSize = Size.zero;

  //get videoName => item.videoPath;

  @override
  void initState() {
    super.initState();
    toVideoName1 = widget.videoName;
  }

  Future<void> _startCameraStream() async {
    final request = await Permission.camera.request();
    if (request.isGranted) {
      //await BodyDetection.enablePoseDetection();

      await BodyDetection.startCameraStream(
        onFrameAvailable: _handleCameraImage,
        onPoseAvailable: (pose) {
          if (!_isDetectingPose) return;
          _handlePose(pose);
        },
      );
    }
  }

  Future<void> _toggleButton() async {
    if (_isDetectingPose) {
      await BodyDetection.enablePoseDetection();
      //print("togglebutton");

      //if (_detectedPose == null) {
      //print('no pose activated');
      //}
    }
  }

  Future<void> _stopCameraStream() async {
    await BodyDetection.stopCameraStream();
    await BodyDetection.disablePoseDetection();

    setState(() {
      _cameraImage = null;
      _imageSize = Size.zero;
    });
  }

  void _handleCameraImage(ImageResult result) {
    // Ignore callback if navigated out of the page.
    if (!mounted) return;

    // To avoid a memory leak issue.
    // https://github.com/flutter/flutter/issues/60160
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    final image = Image.memory(
      result.bytes,
      gaplessPlayback: true,
      fit: BoxFit.contain,
    );

    setState(() {
      _cameraImage = image;
      _imageSize = result.size;
    });
  }

  void _handlePose(Pose? pose) {
    // Ignore if navigated out of the page.
    if (!mounted) return;

    setState(() {
      _detectedPose = pose;
    });
  }

  Widget get _cameraDetectionView => SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ClipRect(
                child: CustomPaint(
                  foregroundPainter: PoseMaskPainter(
                    pose: _detectedPose,
                    //mask: _maskImage,
                    videoName: toVideoName1,
                    imageSize: _imageSize,
                  ),
                  child: Stack(children: <Widget>[
                    Container(child: _cameraImage),
                  ]),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();
  }

  Widget results() => Stack(
        fit: StackFit.loose,
        children: [
          Positioned(
            bottom: 130,
            right: 50,
            child: RotatedBox(
                quarterTurns: 1,
                child: SizedBox(
                  //fit: BoxFit.cover,

                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Completed!",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black,
                    ),
                  ),
                )),
          ),
          Positioned(
            bottom: 150,
            right: 130,
            child: RotatedBox(
              quarterTurns: 1,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  "Rated Your Pain Relief",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 440,
              right: 280,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: RotatedBox(
                      quarterTurns: 1,
                      child: FloatingActionButton.extended(
                        onPressed: () async {
                          _stopCameraStream();
                          await BodyDetection.disablePoseDetection();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Results(
                                        videoName: toVideoName1,
                                        rating: 0.5,
                                      )));
                          maxFlexion = 0;
                        },
                        label: const Text(
                          "See Result",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0),
                        ),
                        backgroundColor: Colors.white,
                      )))),
          Positioned(
              bottom: 140,
              right: 280,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: RotatedBox(
                      quarterTurns: 1,
                      child: FloatingActionButton.extended(
                        onPressed: () async {
                          _stopCameraStream();
                          await BodyDetection.disablePoseDetection();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => GeneralExercise()));
                          neckreps = 0;
                          maxFlexion = 0;
                        },
                        label: const Text(
                          "Back to Exercise",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0),
                        ),
                        backgroundColor: Colors.white,
                      )))),
          const Positioned(
              bottom: 250,
              right: 200,
              child: RotatedBox(quarterTurns: 1, child: FavoriteRelief())),
        ],
      );

  Widget showsCamera() => Stack(children: [
        Center(
            child: RotatedBox(
          quarterTurns: 4,
          child: SizedBox(
              //fit: BoxFit.cover,

              //  width: MediaQuery.of(context).size.width,
              child: _cameraDetectionView),
        )),
        //Expanded(child: _cameraDetectionView),
        SizedBox(
            width: MediaQuery.of(context).size.width / 3.5,
            child: AssetPlayerWidget(name: toVideoName1)),
        MeasurementTest(name: toVideoName1),
        Positioned(
            left: 20,
            bottom: 30,
            child: RotatedBox(
                quarterTurns: 1,
                child: GestureDetector(
                    onTap: () async {
                      _stopCameraStream();
                      await BodyDetection.disablePoseDetection();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0),
                    )))),
        _instructionIsOn ? front() : Container(),
        clockPosition ? playClock() : Container()
      ]);

  Widget playClock() => Positioned(
        bottom: 15,
        right: 80,
        child: RotatedBox(
          quarterTurns: 1,
          child: CircularCountDownTimer(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 3,
            duration: 5,
            controller: _controller,
            fillColor: Colors.red,
            ringColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 38.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            isReverse: false,
            onStart: () {
              tts.speak("Lift your arms in front of you. Hold 5 seconds");
            },
            onComplete: () {
              FlutterRingtonePlayer.playNotification(
                looping: false,
                asAlarm: true,
              );
              tts.speak('Measurement is completed. Put your arms down.');
              neckreps = neckreps + 1;
              maxFlexion = 0;
            },
          ),
        ),
      );

  Widget front() => Opacity(
      opacity: 0.6,
      child: RotatedBox(
          quarterTurns: 1, child: InstructionWidget(pp: _instructionIsOn)));

  @override
  Widget build(BuildContext context) {
    //AssetPlayerWidget();
    if (neckreps < 3) {
      _startCameraStream();
      _toggleButton();
    } else if (neckreps >= 3) {
      _stopCameraStream();
    }

    return Material(
      child: Center(
          child: neckreps >= 3
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.amber,
                  child: results())
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.amber,
                  child: showsCamera())),
    );
  }
}
