import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_signin/screens/general_exercise.dart';
import 'package:firebase_signin/screens/general_rom.dart';

import 'package:firebase_signin/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_signin/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'homeScreen',
      routes: {
        'homeScreen': (context) => HomeScreen(),
        'secondScreen': ((context) => GeneralExercise()),
        'thirdScreen': ((context) => GeneralRom()),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
