import 'package:flutter/material.dart';
import 'package:firebase_signin/screens/signin_screen.dart';
import 'package:firebase_signin/screens/exercise_screen.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/body_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:body_detection/models/image_result.dart';
import 'package:firebase_signin/pose_mask_painter.dart';
import 'package:firebase_signin/screens/camera_screen.dart';

class PreView extends StatefulWidget {
  const PreView({Key? key}) : super(key: key);

  @override
  State<PreView> createState() => _PreViewState();
}

class _PreViewState extends State<PreView> {
  int _selectedTabIndex = 0;
  bool _isDetectingPose = true;
  Pose? _detectedPose;
  Image? _cameraImage;
  Size _imageSize = Size.zero;

  Future<void> _startCameraStream() async {
    final request = await Permission.camera.request();
    if (request.isGranted) {
      await BodyDetection.startCameraStream(
        onFrameAvailable: _handleCameraImage,
        onPoseAvailable: (pose) {
          if (!_isDetectingPose) return;
          _handlePose(pose);
        },
        // onMaskAvailable: (mask) {
        //if (!_isDetectingBodyMask) return;
        // _handleBodyMask(mask);
        // },
      );
    }
  }

  Future<void> _stopCameraStream() async {
    await BodyDetection.stopCameraStream();

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

  Future<void> _toggleDetectPose() async {
    if (_isDetectingPose) {
      await BodyDetection.disablePoseDetection();
    } else {
      await BodyDetection.enablePoseDetection();
    }

    setState(() {
      _isDetectingPose = !_isDetectingPose;
      _detectedPose = null;
    });
  }

  //Widget? get _selectedTab => _selectedTabIndex == 0
  //? null
  //: _selectedTabIndex == 1
  //  ? _cameraDetectionView
  //  : null;

  void _onTabEnter(int index) {
    // Camera tab
    if (index == 1) {
      // _startCameraStream();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      );
    }
  }

  void _onTabExit(int index) {
    // Camera tab
    if (index == 0) {
      _stopCameraStream();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExerciseScreen()),
      );
    }
  }
  //void _backScreen(int index) {
  // back tab
  //if (index == 0) {
  // Navigator.push(
  //  context,
  //  MaterialPageRoute(builder: (context) => const ExerciseScreen()),
  //);
  // }
//  }

  void _onTabSelectTapped(int index) {
    // _onTabExit(_selectedTabIndex);
    //print(_selectedTabIndex.toString());
    //_onTabEnter(index);

    setState(() {
      _selectedTabIndex = index;
    });
    _onTabExit(_selectedTabIndex);
    _onTabEnter(_selectedTabIndex);
    // print(_selectedTabIndex.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Body detection'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back),
              label: 'Back',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
          ],
          currentIndex: _selectedTabIndex,
          onTap: _onTabSelectTapped,
        ),
        body: const Center(
            child: Text(
          "Where to place your phone?",
          style: TextStyle(fontSize: 25),
        )),
      ),
    );
  }
}
