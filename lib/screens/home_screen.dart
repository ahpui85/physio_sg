import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_signin/model/categories_list.dart';
import 'package:firebase_signin/screens/general_rom.dart';

import 'package:firebase_signin/screens/signin_screen.dart';

import 'package:flutter/material.dart';
//import 'package:firebase_signin/screens/exercise_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final items = Categories.getCategories();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.blueAccent,
            size: 30,
          ),
          onPressed: () {},
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
      body: MyGrid(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}

class MyGrid extends StatelessWidget {
  const MyGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(crossAxisCount: 2, children: <Widget>[
      MyCard(
        title: 'Exercise',
        route: 'secondScreen',
        Color: Colors.blue,
        Icon: const Icon(
          Icons.fitness_center,
          size: 50,
        ),
      ),
      MyCard(
        title: 'Range of motion',
        route: 'thirdScreen',
        Color: Colors.green,
        Icon: const Icon(
          Icons.airline_seat_recline_extra,
          size: 50,
        ),
      ),
      MyCard(
        title: 'Image',
        route: 'thirdScreen',
        Color: Colors.green,
        Icon: const Icon(
          Icons.image,
          size: 50,
        ),
      ),
      MyCard(
        title: 'Water',
        route: 'thirdScreen',
        Color: Colors.blue,
        Icon: const Icon(
          Icons.water_drop_rounded,
          size: 50,
        ),
      ),
      MyCard(
        title: 'Game',
        route: 'thirdScreen',
        Color: Colors.blue,
        Icon: const Icon(
          Icons.games,
          size: 50,
        ),
      ),
      MyCard(
        title: 'Gratidue',
        route: 'thirdScreen',
        Color: Colors.green,
        Icon: const Icon(
          Icons.health_and_safety_rounded,
          size: 50,
        ),
      ),
    ]);
  }
}

class MyCard extends StatelessWidget {
  final String route;
  final String title;
  final Icon;
  final Color;
  MyCard(
      {required this.route,
      required this.title,
      required this.Icon,
      required this.Color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        child: Container(
            padding: const EdgeInsets.all(40),
            color: Color,
            child: Column(children: [
              Icon,
              Text(title,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center)
            ])),
      ),
    );
  }
}
