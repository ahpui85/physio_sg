//import 'dart:ui' as ui;

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:body_detection/models/pose.dart';
import 'package:body_detection/models/pose_landmark.dart';
import 'package:body_detection/models/pose_landmark_type.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:math' as math;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:vector_math/vector_math.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

//import 'package:firebase_signin/screens/result.dart';
// for neck exercise
bool tiltHead = false;
bool scount = false;
bool ntiltHead = false;
bool clockPosition = false;
bool checkPosition = false;
bool downPosition = false;
bool upPosition = true;
var reps = 0;
var neckreps = 0;
var maxRadius = 0;
int maxFlexion = 0;
int maxFlexion2 = 0;
int maxKneeFlexion = 0;
int leftElbowFlexion = 0;
int rightElbowFlexion = 0;
int maxNoseFlexion = 0;

//String maxFlexions = '0';

class PoseMaskPainter extends CustomPainter {
  final FlutterTts flutterTts = FlutterTts();
  TextToSpeech tts = TextToSpeech();

  PoseMaskPainter({
    required this.pose,
    // required this.mask,
    required this.imageSize,
    required this.videoName,
  }) {
    flutterTts.setLanguage('en');
    flutterTts.setSpeechRate(0.4);
  }
  final String videoName;
  final Pose? pose;
  //final ui.Image? mask;
  final Size imageSize;
  final pointPaint = Paint()..color = const Color.fromRGBO(255, 255, 255, 0.8);
  final targetPaint0 = Paint()..color = const Color.fromARGB(204, 218, 18, 18);
  final targetPaint1 = Paint()..color = Color.fromARGB(204, 214, 211, 10);
  final targetPaint2 = Paint()..color = const Color.fromARGB(204, 11, 110, 224);
  final leftPointPaint = Paint()..color = const Color.fromRGBO(223, 157, 80, 1);
  final rightPointPaint = Paint()
    ..color = const Color.fromRGBO(100, 208, 218, 1);
  final linePaint = Paint()
    ..color = const Color.fromRGBO(255, 255, 255, 0.9)
    ..strokeWidth = 3;
  final linePaintWrong = Paint()
    ..color = Color.fromARGB(228, 223, 6, 6)
    ..strokeWidth = 5;
  //final maskPaint = Paint()
  //..colorFilter = const ColorFilter.mode(
  //Color.fromRGBO(0, 0, 255, 0.5), BlendMode.srcOut);

  @override
  void paint(Canvas canvas, Size size) {
    //_paintMask(canvas, size);
    _paintPose(canvas, size);
  }

  void _paintPose(Canvas canvas, Size size) {
    if (pose == null) return;

    final double hRatio =
        imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
        imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);
    var myList = [];
    var myNoseList = [];
    var myLeftShoulderList = [];
    var myLeftHipList = [];
    var myNoseList1 = [];
    var myDistanceShourder = [];
    var myLeftKneeList = [];
    var myDistanceHipToKnee = [];
    var myDistanceAnkleToAnkle = [];
    var myDistanceKneeToKnee = [];
    var myDistanceKneeToAnkle = [];

    // Landmark connections
    final landmarksByType = {for (final it in pose!.landmarks) it.type: it};
    for (final connection in connections) {
      final point1 = offsetForPart(landmarksByType[connection[0]]!);
      //print(point1);
      final point2 = offsetForPart(landmarksByType[connection[1]]!);
      canvas.drawLine(point1, point2, linePaint);
    }

    // calculate angles from three points
    final angleLandmarksByType = {
      for (final it in pose!.landmarks) it.type: it
    };

//----------Exercise type based on user response----

    for (final angle in angles) {
      final leftShoulder = offsetForPart(angleLandmarksByType[angle[0]]!);
      final leftElbow = offsetForPart(angleLandmarksByType[angle[1]]!);
      final leftWrist = offsetForPart(angleLandmarksByType[angle[2]]!);
      var hipAngles =
          (atan2((leftWrist.dy - leftElbow.dy), (leftWrist.dx - leftElbow.dx)) -
                      atan2((leftShoulder.dy - leftElbow.dy),
                          (leftShoulder.dx - leftElbow.dx)))
                  .abs() *
              (180 / pi);
      if (hipAngles > 180) {
        hipAngles = 360 - hipAngles;
      }

      // TextSpan span = TextSpan(
      //  text: hipAngles.toStringAsFixed(2),
      //  style: const TextStyle(
      // color: Color.fromARGB(255, 255, 0, 43),
      // fontSize: 18,
      //shadows: [
      // ui.Shadow(
      //color: Color.fromRGBO(255, 255, 255, 1),
      // offset: Offset(1, 1),
      // blurRadius: 1,
      // ),
      // ],
      //  ),
      //);
      //  TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left);
      // tp.textDirection = TextDirection.ltr;
      // tp.layout();
      // tp.paint(canvas, leftElbow);
      myList.add(hipAngles);
      // print(hipAngles.toString());

    }

    for (final target in targets) {
      final leftElbow = offsetForPart(angleLandmarksByType[target[0]]!);
      final leftShoulder = offsetForPart(angleLandmarksByType[target[1]]!);
      final leftWrist = offsetForPart(angleLandmarksByType[target[2]]!);
      final nose = offsetForPart(angleLandmarksByType[target[3]]!);
      final rightShoulder = offsetForPart(angleLandmarksByType[target[4]]!);
      final rightElbow = offsetForPart(angleLandmarksByType[target[5]]!);
      final leftKnee = offsetForPart(angleLandmarksByType[target[6]]!);
      final leftHip = offsetForPart(angleLandmarksByType[target[7]]!);
      final leftAnkle = offsetForPart(angleLandmarksByType[target[8]]!);
      final rightWrist = offsetForPart(angleLandmarksByType[target[9]]!);
      final rightHip = offsetForPart(angleLandmarksByType[target[10]]!);
      final rightAnkle = offsetForPart(angleLandmarksByType[target[11]]!);
      final rightKnee = offsetForPart(angleLandmarksByType[target[12]]!);
      final newPoint = Offset(leftElbow.dx,
          leftShoulder.dy); //----left elbow of x and left shoulder of y
      final nosePoint = Offset(
          leftShoulder.dx, nose.dy); //-----left shoulder of x and nose of y
      final nosePoint2 = Offset(
          rightShoulder.dx, nose.dy); //-----left shoulder of x and nose of y
      final newPoint2 = Offset(rightElbow.dx,
          rightShoulder.dy); //-----right elbow of x and right shouder of y
      final newPoint3 =
          Offset(leftKnee.dx, leftHip.dy); //--- left knww of x and lefthip of y
      var xMidLRShoulder = (leftShoulder.dy - rightShoulder.dy) / 2;
      var midLRShoulder =
          Offset(leftShoulder.dx, leftShoulder.dy - xMidLRShoulder);

      //-- calculate distance between two parallel joint---

      double disAnkle = rightAnkle.dy - leftAnkle.dy;
      double disKnee = rightKnee.dy - leftKnee.dy;
      double disKneeToAnkle = leftAnkle.dy - leftKnee.dy;

      //-----------calculate angle of nose, midLRShoulder and rightshoulder--not correct angle

      double numeratorMidNose =
          nose.dy * (midLRShoulder.dx - rightShoulder.dx) +
              midLRShoulder.dy * (rightShoulder.dx - nose.dx) +
              rightShoulder.dy * (nose.dx - midLRShoulder.dx);

      double denominatorMidnose =
          (nose.dx - midLRShoulder.dx) * (leftKnee.dx - rightShoulder.dx) +
              (nose.dy - midLRShoulder.dy) * (leftKnee.dy - rightShoulder.dy);
      double ratioMidNose = numeratorMidNose / denominatorMidnose;
      double angleRadMidNose = atan(ratioMidNose);
      double angleDegreeMidNose = (angleRadMidNose * 180) / pi;
      angleDegreeMidNose = angleDegreeMidNose + 90;

      maxNoseFlexion = angleDegreeMidNose.toInt();
//-------------shoulderxx is angles between left shoulder-left elbow line and left shoulder-new point line
      var shoulderAngles =
          (atan2((newPoint.dy - leftElbow.dy), (newPoint.dx - leftElbow.dx)) -
                      atan2((leftShoulder.dy - leftElbow.dy),
                          (leftShoulder.dx - leftElbow.dx)))
                  .abs() *
              (180 / pi);
      if (shoulderAngles > 180) {
        shoulderAngles = 360 - shoulderAngles;
      }
      var shoulderxx = 90 - shoulderAngles;
      if (leftElbow.dx > leftShoulder.dx) {
        shoulderxx = 90 + shoulderAngles;
        maxFlexion = shoulderxx.toInt();
      }
      maxFlexion = shoulderxx.toInt();
//---------calculate angles between right shoulder and hips
      var shoulderAnglesR = (atan2((newPoint2.dy - rightElbow.dy),
                      (newPoint2.dx - rightElbow.dx)) -
                  atan2((rightShoulder.dy - rightElbow.dy),
                      (rightShoulder.dx - rightElbow.dx)))
              .abs() *
          (180 / pi);
      if (shoulderAnglesR > 180) {
        shoulderAnglesR = 360 - shoulderAnglesR;
      }
      var shoulderxR = 90 - shoulderAnglesR;
      if (rightElbow.dx > rightShoulder.dx) {
        shoulderxR = 90 + shoulderAnglesR;
        maxFlexion2 = shoulderxR.toInt();
      }
      maxFlexion2 = shoulderxR.toInt();

//-------noseAngle is a angle between nose-nosepoint line and left shoulder-nosepoint line

      var noseAngles = (atan2(
                      (nosePoint.dy - nose.dy), (nosePoint.dx - nose.dx)) -
                  atan2(
                      (leftShoulder.dy - nose.dy), (leftShoulder.dx - nose.dx)))
              .abs() *
          (180 / pi);
      if (noseAngles > 180) {
        noseAngles = 360 - noseAngles;
      }
//----------------calculate------ hip angles to knee---
      var hipAnglesL = (atan2((newPoint3.dy - leftKnee.dy),
                      (newPoint3.dx - leftKnee.dx)) -
                  atan2((leftHip.dy - leftKnee.dy), (leftHip.dx - leftKnee.dx)))
              .abs() *
          (180 / pi);
      if (hipAnglesL > 180) {
        hipAnglesL = 360 - hipAnglesL;
      }
      hipAnglesL = 90 - hipAnglesL;
      //maxKneeFlexion = hipAnglesL.toInt();

//----------calculate angle between knee and ankles

      double numerator = leftHip.dy * (leftKnee.dx - leftAnkle.dx) +
          leftKnee.dy * (leftAnkle.dx - leftHip.dx) +
          leftAnkle.dy * (leftHip.dx - leftKnee.dx);

      double denominator =
          (leftHip.dx - leftKnee.dx) * (leftKnee.dx - leftAnkle.dx) +
              (leftHip.dy - leftKnee.dy) * (leftKnee.dy - leftAnkle.dy);
      double ratio = numerator / denominator;
      double angleRad = atan(ratio);
      double angleDegree = (angleRad * 180) / pi;

      if (angleDegree < 0) {
        angleDegree = 180 + angleDegree;
      }

      var kneexx = angleDegree;
      maxKneeFlexion = kneexx.toInt();
//------------calculate distance=hip.dx-knee.dx-----
      double disHipToKnee = leftHip.dx - leftKnee.dx;

//---------calculate nose angle for neck_extension....

      double numerator1 = nose.dy * (rightShoulder.dx - nosePoint2.dx) +
          rightShoulder.dy * (nosePoint2.dx - nose.dx) +
          nosePoint2.dy * (nose.dx - rightShoulder.dx);

      double denominator1 =
          (nose.dx - rightShoulder.dx) * (rightShoulder.dx - nosePoint2.dx) +
              (nose.dy - rightShoulder.dy) * (rightShoulder.dy - nosePoint2.dy);
      double ratio1 = numerator1 / denominator1;
      double angleRad1 = atan(ratio1);
      double angleDegree1 = (angleRad1 * 180) / pi;
//-------calculate distance in y between rughtshouder to leftshoulder---
      double distanceshoulderRToL = rightShoulder.dy - leftShoulder.dy;

//-----calculate angle of leftelbow flexion

      double numeratorElbow = leftShoulder.dy * (leftElbow.dx - leftWrist.dx) +
          leftElbow.dy * (leftWrist.dx - leftShoulder.dx) +
          leftWrist.dy * (leftShoulder.dx - leftElbow.dx);
      double denominatorElbow =
          (leftShoulder.dx - leftElbow.dx) * (leftElbow.dx - leftWrist.dx) +
              (leftShoulder.dy - leftElbow.dy) * (leftElbow.dy - leftWrist.dy);

      double ratioElbow = numeratorElbow / denominatorElbow;
      double angleElbow = atan(ratioElbow);
      double angleElbow1 = (angleElbow * 180) / pi;

      if (angleElbow1 < 0) {
        angleElbow1 = 180 + angleElbow1;
      }

      leftElbowFlexion = 180 - angleElbow1.toInt();

//-----calculate angle of rightelbow flexion

      double numeratorRElbow =
          rightShoulder.dy * (rightElbow.dx - rightWrist.dx) +
              rightElbow.dy * (rightWrist.dx - rightShoulder.dx) +
              rightWrist.dy * (rightShoulder.dx - rightElbow.dx);
      double denominatorRElbow = (rightShoulder.dx - rightElbow.dx) *
              (rightElbow.dx - rightWrist.dx) +
          (rightShoulder.dy - rightElbow.dy) * (rightElbow.dy - rightWrist.dy);

      double ratioRElbow = numeratorRElbow / denominatorRElbow;
      double angleRElbow = atan(ratioRElbow);
      double angleRElbow1 = (angleRElbow * 180) / pi;

      if (angleRElbow1 < 0) {
        angleRElbow1 = 180 + angleRElbow1;
      }

      rightElbowFlexion = angleRElbow1.toInt();

      myNoseList.add(noseAngles);
      myNoseList1.add(angleDegree1);
      myDistanceShourder.add(distanceshoulderRToL);
      myLeftShoulderList.add(maxFlexion);
      myLeftHipList.add(hipAnglesL);
      myLeftKneeList.add(kneexx);
      myDistanceHipToKnee.add(disHipToKnee);
      myDistanceAnkleToAnkle.add(disAnkle);
      myDistanceKneeToKnee.add(disKnee);
      myDistanceKneeToAnkle.add(disKneeToAnkle);

      TextSpan span = TextSpan(
        text: disKnee.toStringAsFixed(2),
        style: const TextStyle(
          color: Color.fromRGBO(0, 128, 255, 1),
          fontSize: 30,
          //shadows: [
          // ui.Shadow(
          //color: Color.fromRGBO(255, 255, 255, 1),
          // offset: Offset(1, 1),
          // blurRadius: 1,
          // ),
          // ],
        ),
      );
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      //tp.paint(canvas, leftShoulder);

      TextSpan span2 = TextSpan(
        text: disKneeToAnkle.toStringAsFixed(2),
        style: const TextStyle(
          color: Color.fromRGBO(0, 128, 255, 1),
          fontSize: 30,
          //shadows: [
          // ui.Shadow(
          //color: Color.fromRGBO(255, 255, 255, 1),
          // offset: Offset(1, 1),
          // blurRadius: 1,
          // ),
          // ],
        ),
      );
      TextPainter tp2 = TextPainter(text: span2, textAlign: TextAlign.left);
      tp2.textDirection = TextDirection.ltr;
      tp2.layout();
      //tp2.paint(canvas, leftAnkle);

      TextSpan span1 = TextSpan(
        text: disAnkle.toStringAsFixed(2),
        style: const TextStyle(
          color: Color.fromRGBO(0, 128, 255, 1),
          fontSize: 30,
          //shadows: [
          // ui.Shadow(
          //color: Color.fromRGBO(255, 255, 255, 1),
          // offset: Offset(1, 1),
          // blurRadius: 1,
          // ),
          // ],
        ),
      );
      TextPainter tp1 = TextPainter(text: span1, textAlign: TextAlign.left);
      tp1.textDirection = TextDirection.ltr;
      tp1.layout();
      //tp1.paint(canvas, rightAnkle);

      // --------------angle guided shoulder based exercise----landscape---

      //var arcCenter = Offset(leftShoulder.dx, leftShoulder.dy);
      var arcRect = Rect.fromCircle(center: leftShoulder, radius: 90);
      // var arcCenter1 = Offset(rightShoulder.dx, rightShoulder.dy);
      var arcRect1 = Rect.fromCircle(center: rightShoulder, radius: 90);
      var arcRect2 = Rect.fromCircle(center: leftHip, radius: 90);
      var arcRect3 = Rect.fromCircle(center: nose, radius: 60);
      var arcRect4 = Rect.fromCircle(center: leftKnee, radius: 60);
      var arcRect5 = Rect.fromCircle(center: leftElbow, radius: 60);
      var arcRect6 = Rect.fromCircle(center: rightElbow, radius: 60);
      // var startAngle = radians(220);
      // var sweepAngle = radians(20);

      switch (videoName) {
        case 'sumo_squart.mp4':
          inDownPosition(myDistanceKneeToAnkle, myDistanceKneeToKnee);
          inUpPosition(myDistanceKneeToAnkle, myDistanceAnkleToAnkle,
              myDistanceKneeToKnee);
          if (disAnkle < 80) {
            canvas.drawLine(leftAnkle, rightAnkle, linePaintWrong);
            canvas.drawLine(leftKnee, rightKnee, linePaintWrong);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[8]]!),
                8, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[8]]!), 5, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[11]]!),
                8, targetPaint0);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[11]]!),
                5, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[6]]!),
                8, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[6]]!), 5, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[12]]!),
                8, targetPaint0);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[12]]!),
                5, pointPaint);
          }
          break;

        case 'neck_right.mp4':
          inRange(myLeftShoulderList);
          noseRange(myNoseList1);
          outRange(myLeftShoulderList);
          canvas.drawArc(
              arcRect, radians(220), radians(20), true, targetPaint2);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[0]]!), 8, targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[0]]!), 5, pointPaint);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[2]]!), 8, targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[2]]!), 5, pointPaint);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[1]]!), 8, targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[1]]!), 5, pointPaint);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[7]]!), 8, targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[7]]!), 5, pointPaint);

          break;
        case 'seated_thoracic.mp4':
          inLeftRangeCardio(myLeftShoulderList);
          inRightRangeCardio(myLeftShoulderList);
          outRange(myLeftShoulderList);
          canvas.drawArc(
              arcRect, radians(310), radians(30), true, targetPaint2);
          canvas.drawArc(
              arcRect1, radians(20), radians(30), true, targetPaint2);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[0]]!), 8, targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[0]]!), 5, pointPaint);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[1]]!), 8, targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[1]]!), 5, pointPaint);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[2]]!), 8, targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[2]]!), 5, pointPaint);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[7]]!), 8, targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[7]]!), 5, pointPaint);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[4]]!), 8, targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[4]]!), 5, pointPaint);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[5]]!), 8, targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[5]]!), 5, pointPaint);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[9]]!), 8, targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[9]]!), 5, pointPaint);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[7]]!), 8, targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[7]]!), 5, pointPaint);
          canvas.drawCircle(offsetForPart(angleLandmarksByType[target[10]]!), 8,
              targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[10]]!), 5, pointPaint);
          break;
        case 'hip.mp4':
          canvas.drawArc(
              arcRect2, radians(110), radians(30), true, targetPaint2);
          break;
        case 'middle_scalene.mp4':
          inLeftRangeScalene(myLeftShoulderList);
          outRangeScalene(myLeftShoulderList);
          noseRangeScalene(myNoseList);
          canvas.drawArc(
              arcRect, radians(300), radians(30), true, targetPaint2);
          canvas.drawArc(
              arcRect3, radians(290), radians(30), true, targetPaint2);
          break;
        case 'seated_shoulder_flexion.mp4':
          if (leftElbow.dx > rightElbow.dx && maxFlexion > 15) {
            canvas.drawArc(arcRect, radians(180),
                radians(maxFlexion.toDouble()), true, targetPaint2);

            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[0]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[0]]!), 8, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[1]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[1]]!), 8, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[2]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[2]]!), 8, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[7]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[7]]!), 8, pointPaint);
          } else if (rightElbow.dx > leftElbow.dx && maxFlexion2 > 15) {
            canvas.drawArc(arcRect1, radians(180),
                radians(-maxFlexion2.toDouble()), true, targetPaint2);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[4]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[4]]!), 8, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[5]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[5]]!), 8, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[9]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[9]]!), 8, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[10]]!),
                12, targetPaint0);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[10]]!),
                8, pointPaint);
          }

          break;

        case 'knee_extension.mp4':
          inLeftRangeKnee(myLeftKneeList);
          inDistanceToKnee(myDistanceHipToKnee);
          outRangeKnee(myLeftKneeList);
          canvas.drawArc(
              arcRect4, radians(90), radians(45), true, targetPaint2);
          canvas.drawCircle(offsetForPart(angleLandmarksByType[target[7]]!), 12,
              targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[7]]!), 8, pointPaint);
          canvas.drawCircle(offsetForPart(angleLandmarksByType[target[8]]!), 12,
              targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[8]]!), 8, pointPaint);
          canvas.drawCircle(offsetForPart(angleLandmarksByType[target[6]]!), 12,
              targetPaint0);
          canvas.drawCircle(
              offsetForPart(angleLandmarksByType[target[6]]!), 8, pointPaint);

          break;
        case 'elbow_flexion.mp4':
          //canvas.drawArc(arcRect5, radians(90),
          //radians(-leftElbowFlexion.toDouble()), true, targetPaint2);
          if (rightElbow.dx > leftElbow.dx && rightElbowFlexion > 15) {
            canvas.drawArc(arcRect6, radians(90),
                radians(-rightElbowFlexion.toDouble()), true, targetPaint2);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[4]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[4]]!), 8, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[5]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[5]]!), 8, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[9]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[9]]!), 8, pointPaint);
          } else if (leftElbow.dx > rightElbow.dx && leftElbowFlexion > 15) {
            canvas.drawArc(arcRect5, radians(-90),
                radians(leftElbowFlexion.toDouble()), true, targetPaint2);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[0]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[0]]!), 8, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[1]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[1]]!), 8, pointPaint);
            canvas.drawCircle(offsetForPart(angleLandmarksByType[target[2]]!),
                12, targetPaint0);
            canvas.drawCircle(
                offsetForPart(angleLandmarksByType[target[2]]!), 8, pointPaint);
          }
          break;
        case 'seatedTrunk.mp4':
          inLeftRangeHip(myLeftHipList);
          inRightRangeHip(myLeftHipList);
          outRangeHip(myLeftHipList);
          break;

        // case 'seatedTrunk.mp4':
        //canvas.drawArc(
        //   arcRect3, radians(110), radians(30), true, targetPaint2);
        //   break;
      }

      //canvas.drawArc(arcRect, startAngle, sweepAngle, true, targetPaint2);

      //----------angle end shoulder--------------

      switch (videoName) {
        case 'neck_extension.mp4':

          ///---do this now
          inRightRangeNeck(myNoseList1);
          inRangeNeck(myDistanceShourder);
          outRangeNeck(myNoseList1);
          break;

        case 'seated_shoulder_flexion.mp4':
          inLeftRangeRom(myLeftShoulderList);
          inRightRangeRom(myLeftShoulderList);
          outRangeRom(myLeftShoulderList);
          break;
      }
    }

//---temporary off for presentation
    // for (final part in pose!.landmarks) {
    // Landmark points

    // canvas.drawCircle(offsetForPart(part), 8, pointPaint);

    // if (part.type.isLeftSide) {
    //  canvas.drawCircle(offsetForPart(part), 3, leftPointPaint);
    //  } else if (part.type.isRightSide) {
    // canvas.drawCircle(offsetForPart(part), 3, rightPointPaint);
    // }

    // tp.paint(canvas, offsetForPart(part));
    // }
  }

  // void _paintMask(Canvas canvas, Size size) {
  // if (mask == null) return;

  //canvas.drawImageRect(
  //   mask!,
  //   Rect.fromLTWH(0, 0, mask!.width.toDouble(), mask!.height.toDouble()),
  //   Rect.fromLTWH(0, 0, size.width, size.height),
  //   maskPaint);
  // }

  @override
  bool shouldRepaint(PoseMaskPainter oldDelegate) {
    return oldDelegate.pose != pose ||
        //oldDelegate.mask != mask ||
        oldDelegate.imageSize != imageSize;
  }

  List<List<PoseLandmarkType>> get angles => [
        [
          PoseLandmarkType.leftShoulder,
          PoseLandmarkType.leftElbow,
          PoseLandmarkType.leftWrist,
        ],
        [
          PoseLandmarkType.rightHip,
          PoseLandmarkType.rightKnee,
          PoseLandmarkType.rightAnkle
        ],
        [
          PoseLandmarkType.rightShoulder,
          PoseLandmarkType.rightElbow,
          PoseLandmarkType.rightWrist,
        ],
        [
          PoseLandmarkType.leftHip,
          PoseLandmarkType.leftKnee,
          PoseLandmarkType.leftAnkle
        ],
      ];

  List<List<PoseLandmarkType>> get targets => [
        [
          PoseLandmarkType.rightElbow,
          PoseLandmarkType.rightShoulder,
          PoseLandmarkType.rightWrist,
          PoseLandmarkType.nose,
          PoseLandmarkType.leftShoulder,
          PoseLandmarkType.leftElbow,
          PoseLandmarkType.rightKnee,
          PoseLandmarkType.rightHip,
          PoseLandmarkType.rightAnkle,
          PoseLandmarkType.leftWrist,
          PoseLandmarkType.leftHip,
          PoseLandmarkType.leftAnkle,
          PoseLandmarkType.leftKnee,
        ]
      ];

  List<List<PoseLandmarkType>> get connections => [
        // [PoseLandmarkType.leftEar, PoseLandmarkType.leftEyeOuter],
        // [PoseLandmarkType.leftEyeOuter, PoseLandmarkType.leftEye],
        // [PoseLandmarkType.leftEye, PoseLandmarkType.leftEyeInner],
        //[PoseLandmarkType.leftEyeInner, PoseLandmarkType.nose],
        //[PoseLandmarkType.nose, PoseLandmarkType.rightEyeInner],
        //[PoseLandmarkType.rightEyeInner, PoseLandmarkType.rightEye],
        //[PoseLandmarkType.rightEye, PoseLandmarkType.rightEyeOuter],
        //[PoseLandmarkType.rightEyeOuter, PoseLandmarkType.rightEar],
        //[PoseLandmarkType.mouthLeft, PoseLandmarkType.mouthRight],
        [PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder],
        [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip],
        [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip],
        [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow],
        [PoseLandmarkType.rightWrist, PoseLandmarkType.rightElbow],
        [PoseLandmarkType.rightWrist, PoseLandmarkType.rightThumb],
        [PoseLandmarkType.rightWrist, PoseLandmarkType.rightIndexFinger],
        [PoseLandmarkType.rightWrist, PoseLandmarkType.rightPinkyFinger],
        [PoseLandmarkType.leftHip, PoseLandmarkType.rightHip],
        [PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee],
        [PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee],
        [PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle],
        [PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle],
        [PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder],
        [PoseLandmarkType.leftWrist, PoseLandmarkType.leftElbow],
        [PoseLandmarkType.leftWrist, PoseLandmarkType.leftThumb],
        [PoseLandmarkType.leftWrist, PoseLandmarkType.leftIndexFinger],
        [PoseLandmarkType.leftWrist, PoseLandmarkType.leftPinkyFinger],
        [PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel],
        [PoseLandmarkType.leftAnkle, PoseLandmarkType.leftToe],
        [PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel],
        [PoseLandmarkType.rightAnkle, PoseLandmarkType.rightToe],
        [PoseLandmarkType.rightHeel, PoseLandmarkType.rightToe],
        [PoseLandmarkType.leftHeel, PoseLandmarkType.leftToe],
        [PoseLandmarkType.rightIndexFinger, PoseLandmarkType.rightPinkyFinger],
        [PoseLandmarkType.leftIndexFinger, PoseLandmarkType.leftPinkyFinger],
      ];
  void inDownPosition(list, list1) {
    if (list1[0] > 90 && upPosition == true) {
      downPosition = true;
      upPosition = false;
      checkPosition = false;
      if (list1[0] < 90) {
        tts.speak("turn out your legs more");
      }
      //flutterTts.speak('Up'); knee
    }
  }

  void inUpPosition(list, list1, list2) {
    if (list[0] < -10 && list1[0] < 100) {
      if (reps <= 0 && list1[0] > 85 && scount == false) {
        checkPosition = true;
        scount = true;
      }

      if (downPosition == true && scount == true) {
        reps = reps + 1;
        //flutterTts.speak('Down');
        // if (list1[0] < 75) {
        // tts.speak("spread your feet");
        // }
      }
      if (list1[0] < 75) {
        tts.speak("spread your feet");
      }

      downPosition = false;
      upPosition = true;
    }
  }

  //------Seated Thoracic Extension---------------
  void inLeftRangeCardio(list) {
    if (list[0] > 130 && list[0] < 175 && tiltHead == true) {
      //flutterTts.speak('Hold 5 seconds');
      //tts.speak("Hold 5 seconds");
      clockPosition = true;
      ntiltHead = false;
    }
    // clockPosition = false;
  }

  void outRangeCardio(list) {
    if (list[0] < 15) {
      // if (ntiltHead == true) {
      // neckreps = neckreps + 1;
      // }
      //flutterTts.speak('Hold for 5 seconds');
      clockPosition = false;
      tiltHead = false;
      ntiltHead = false;
      FlutterRingtonePlayer.stop();
    }
  }

// check tilthead posture
  void inRightRangeCardio(list) {
    if (list[0] > 130 && list[0] < 180) {
      tiltHead = true;
    } else {
      tiltHead = false;
      clockPosition = false;
    }
  }

  //--------middle_scalene exercise----------
  void inLeftRangeScalene(list) {
    if (list[0] > 90 && list[0] < 135 && tiltHead == true) {
      //flutterTts.speak('Hold 5 seconds');
      //tts.speak("Hold 5 seconds");
      clockPosition = true;
      ntiltHead = true;
    }
  }

  void outRangeScalene(list) {
    if (list[0] < 15) {
      // if (ntiltHead == true) {
      // neckreps = neckreps + 1;
      // }
      //flutterTts.speak('Hold for 5 seconds');
      clockPosition = false;
      tiltHead = false;
      ntiltHead = false;
      FlutterRingtonePlayer.stop();
    }
  }

  void noseRangeScalene(list) {
    if (list[0] > 20 && list[0] < 40) {
      tiltHead = true;
    } else {
      tiltHead = false;
      clockPosition = false;
    }
  }

//------------Active NECK lateral exercise EXERCISE -----------------
  void inRange(list) {
    if (list[0] > 40 && list[0] < 60 && tiltHead == true) {
      //flutterTts.speak('Hold 5 seconds');
      //tts.speak("Hold 5 seconds");
      clockPosition = true;
      ntiltHead = true;
    }
  }

  void outRange(list) {
    if (list[0] < 15) {
      // if (ntiltHead == true) {
      // neckreps = neckreps + 1;
      // }
      //flutterTts.speak('Hold for 5 seconds');
      clockPosition = false;
      tiltHead = false;
      ntiltHead = false;
      FlutterRingtonePlayer.stop();
    }
  }

// check tilthead posture
  void noseRange(list) {
    if (list[0] > 60 && list[0] < 80) {
      tiltHead = true;
    } else {
      tiltHead = false;
      clockPosition = false;
    }
  }

//----------Standing straight leg raise--------------

  void inLeftRangeHip(list) {
    if (list[0] > 20 && list[0] < 90 && tiltHead == true) {
      //flutterTts.speak('Hold 5 seconds');
      //tts.speak("Hold 5 seconds");
      clockPosition = true;
      ntiltHead = true;
    }
  }

  void outRangeHip(list) {
    if (list[0] < 15) {
      // if (ntiltHead == true) {
      // neckreps = neckreps + 1;
      // }
      //flutterTts.speak('Hold for 5 seconds');
      clockPosition = false;
      tiltHead = false;
      ntiltHead = false;
      FlutterRingtonePlayer.stop();
    }
  }

// check tilthead posture
  void inRightRangeHip(list) {
    if (list[0] > 25 && list[0] < 90) {
      tiltHead = true;
    } else {
      tiltHead = false;
      clockPosition = false;
    }
  }

  //------ROM_Seated shoulder Flexion---------------
  void inLeftRangeRom(list) {
    if (list[0] > 80 && list[0] < 180 && tiltHead == true) {
      //flutterTts.speak('Hold 5 seconds');
      //tts.speak("Hold 5 seconds");
      clockPosition = true;
      ntiltHead = true;
      // maxFlexion = shoulderxx;
    }
  }

  void outRangeRom(list) {
    if (list[0] < 15) {
      // if (ntiltHead == true) {
      // neckreps = neckreps + 1;
      // }
      //flutterTts.speak('Hold for 5 seconds');
      clockPosition = false;
      tiltHead = false;
      ntiltHead = false;
      //maxFlexion = 0;
      FlutterRingtonePlayer.stop();
    }
  }

// check rightrange
  void inRightRangeRom(list) {
    if (list[0] > 10 && list[0] < 180) {
      tiltHead = true;
    } else {
      tiltHead = false;
      clockPosition = false;
      //maxFlexion = 0;
    }
  }

  //-------neck stretch test---
  void inRightRangeNeck(list) {
    if (list[0] > 60 && list[0] < 70 && tiltHead == true) {
      //flutterTts.speak('Hold 5 seconds');
      //tts.speak("Hold 5 seconds");
      clockPosition = true;
      ntiltHead = true;
      // maxFlexion = shoulderxx;
    }
  }

  void outRangeNeck(list) {
    if (list[0] < 45) {
      // if (ntiltHead == true) {
      // neckreps = neckreps + 1;
      // }
      //flutterTts.speak('Hold for 5 seconds');
      clockPosition = false;
      tiltHead = false;
      ntiltHead = false;
      //maxFlexion = 0;
      FlutterRingtonePlayer.stop();
    }
  }

// check tilthead posture
  void inRangeNeck(list) {
    if (list[0] < 80) {
      tiltHead = true;
    } else {
      tiltHead = false;
      clockPosition = false;
      //maxFlexion = 0;
    }
  }

//--------------left knee extension

  void inLeftRangeKnee(list) {
    if (list[0] > 155 && list[0] < 170 && tiltHead == true) {
      //flutterTts.speak('Hold 5 seconds');
      //tts.speak("Hold 5 seconds");
      clockPosition = true;
      ntiltHead = true;
      // maxFlexion = shoulderxx;
    }
  }

  void outRangeKnee(list) {
    if (list[0] < 100) {
      // if (ntiltHead == true) {
      // neckreps = neckreps + 1;
      // }
      //flutterTts.speak('Hold for 5 seconds');
      clockPosition = false;
      tiltHead = false;
      ntiltHead = false;
      //maxFlexion = 0;
      FlutterRingtonePlayer.stop();
    }
  }

// check tilthead posture
  void inDistanceToKnee(list) {
    if (list[0] < 30) {
      tiltHead = true;
    } else {
      tiltHead = false;
      clockPosition = false;
      //maxFlexion = 0;
    }
  }
}
