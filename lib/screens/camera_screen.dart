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
//import 'package:firebase_signin/model/exercise_list.dart';

import '../model/rom_list.dart';
import '../widget/favourite_relief_widget.dart';
import '../widget/instruction_widget.dart';
import 'general_exercise.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.videoName}) : super(key: key);
  final String videoName;
  //final Exercise item;
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  //late final Exercise item;
  int exerciseTime = 0;
  bool resultCount = false;
  bool startCounting = false;
  bool counting = false;
  late String toVideoName1;
  final items = Rom.getRom();
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

  Widget results({required bool clockPosition}) => Stack(
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
                  child: resultCount
                      ? Text(
                          'Count:$reps',
                          style: const TextStyle(
                            fontSize: 50,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
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
                          clockPosition = false;
                          _stopCameraStream();
                          await BodyDetection.disablePoseDetection();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Results(
                                        videoName: toVideoName1,
                                        rating: 0.5,
                                      )));
                          neckreps = 0;
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
                        onPressed: () {
                          FlutterRingtonePlayer.stop();
                          _stopCameraStream();
                          clockPosition = false;
                          //await BodyDetection.disablePoseDetection();
                          //FlutterRingtonePlayer.stop();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => GeneralExercise()));
                          neckreps = 0;
                          reps = 0;
                          checkPosition = false;
                          exerciseTime = 0;
                          counting = false;
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
        Positioned(
          bottom: 35,
          right: 15,
          child: Align(
            alignment: Alignment.bottomRight,
            child: RotatedBox(
                quarterTurns: 1,
                child: counting
                    ? Text(
                        '$reps',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 60.0),
                      )
                    : Text(
                        "$neckreps/3",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0),
                      )),
          ),
        ),
        Positioned(
            left: 20,
            bottom: 30,
            child: RotatedBox(
                quarterTurns: 1,
                child: GestureDetector(
                    onTap: () async {
                      _stopCameraStream();
                      clockPosition = false;
                      await BodyDetection.disablePoseDetection();
                      FlutterRingtonePlayer.stop();
                      Navigator.pop(context);
                      neckreps = 0;
                      reps = 0;
                      checkPosition = false;
                      exerciseTime = 0;
                      counting = false;
                      clockPosition = false;
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
        clockPosition ? playClock() : Container(),
        checkPosition ? startClock() : Container(),
        startCounting ? startClockCount() : Container(),
      ]);

  Widget startClockCount() => Positioned(
        bottom: 15,
        right: 50,
        child: RotatedBox(
          quarterTurns: 1,
          child: CircularCountDownTimer(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 3,
            duration: 30,
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
              FlutterRingtonePlayer.play(
                  fromAsset: 'assets/ringtone/24 count.mp3',
                  looping: true,
                  asAlarm: true);
            },
            onComplete: () {
              FlutterRingtonePlayer.stop();
              tts.speak('Exercise completed');
              startCounting = false;
              checkPosition = false;
              exerciseTime = 30;
              neckreps = 3;
            },
          ),
        ),
      );

  Widget startClock() => Positioned(
        bottom: 15,
        right: 50,
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
              tts.speak("Start in 5 seconds");
              FlutterRingtonePlayer.play(
                  fromAsset: 'assets/ringtone/countdown.mp3',
                  looping: false,
                  asAlarm: true);
            },
            onComplete: () {
              FlutterRingtonePlayer.stop();
              tts.speak('Start now');
              startCounting = true;
              checkPosition = false;
            },
          ),
        ),
      );

  Widget playClock() => Positioned(
        bottom: 15,
        right: 50,
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
              tts.speak("Hold 5 seconds");
              FlutterRingtonePlayer.play(
                  fromAsset: 'assets/ringtone/countdown.mp3',
                  looping: false,
                  asAlarm: true);
            },
            onComplete: () {
              FlutterRingtonePlayer.stop();
              tts.speak('Released from pose');
              neckreps = neckreps + 1;
              if (neckreps >= 3) {
                tts.speak('Exercise completed');
                clockPosition = false;
                FlutterRingtonePlayer.stop();
              }
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
    switch (toVideoName1) {
      case 'sumo_squart.mp4':
        if (exerciseTime < 30) {
          _startCameraStream();
          _toggleButton();
          counting = true;
          clockPosition = false;
        } else if (exerciseTime >= 30) {
          _stopCameraStream();
          counting = false;
          resultCount = true;
        }

        break;
    }

    //AssetPlayerWidget();
    if (neckreps < 3) {
      _startCameraStream();
      _toggleButton();
    } else if (neckreps >= 3) {
      _stopCameraStream();
      clockPosition = false;
      FlutterRingtonePlayer.stop();
    }

    return Material(
      child: Center(
          child: neckreps >= 3
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.amber,
                  child: results(clockPosition: clockPosition))
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.amber,
                  child: showsCamera())),
    );
  }
}
