import 'package:firebase_signin/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_signin/widget/video_player_widget.dart';

class AssetPlayerWidget extends StatefulWidget {
  const AssetPlayerWidget({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  State<AssetPlayerWidget> createState() => _AssetPlayerWidgetState();
}

class _AssetPlayerWidgetState extends State<AssetPlayerWidget> {
  // ignore: prefer_typing_uninitialized_variables
  late final asset;
  //final asset = 'assets/videos';
  late VideoPlayerController controller;

  // static String get videoName => _AssetPlayerWidgetState.videoName;

  @override
  void initState() {
    super.initState();
    asset = 'assets/videos/' + widget.name;
    controller = VideoPlayerController.asset(asset)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller.play());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayerWidget(controller: controller);
  }
}
