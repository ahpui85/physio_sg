import 'package:flutter/material.dart';
import 'package:firebase_signin/pose_mask_painter.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/body_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:body_detection/models/image_result.dart';
import 'package:firebase_signin/widget/asset_player_widget.dart';
import 'package:firebase_signin/screens/exercise_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final bool _isDetectingPose = true;

  Pose? _detectedPose;
  //ui.Image? _maskImage;
  Image? _cameraImage;
  Size _imageSize = Size.zero;

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
                    imageSize: _imageSize,
                  ),
                  child: Stack(children: <Widget>[
                    Container(child: _cameraImage),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            "Counts: $reps",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0),
                          )),
                    ),
                    Positioned(
                        right: 0,
                        bottom: 0,
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
                                      fontSize: 22.0),
                                )))),
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
          Center(
            child: RotatedBox(
                quarterTurns: 1,
                child: SizedBox(
                  //fit: BoxFit.cover,

                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Congratulations! You have completed $reps repetitions.",
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color.fromARGB(221, 70, 194, 13),
                    ),
                  ),
                )),
          ),
          Positioned(
              bottom: 25,
              right: 50,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: RotatedBox(
                      quarterTurns: 1,
                      child: GestureDetector(
                        onTap: () async {
                          _stopCameraStream();
                          await BodyDetection.disablePoseDetection();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ExerciseScreen()));
                          reps = 0;
                        },
                        child: const Text(
                          "NEXT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0),
                        ),
                      )))),
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
            width: MediaQuery.of(context).size.width / 4,
            child: AssetPlayerWidget()),
      ]);

  @override
  Widget build(BuildContext context) {
    //AssetPlayerWidget();
    if (reps < 3) {
      _startCameraStream();
      _toggleButton();
    } else if (reps >= 3) {
      _stopCameraStream();
    }

    return Center(
        child: reps >= 3
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.amber,
                child: results())
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.amber,
                child: showsCamera()));
  }
}
