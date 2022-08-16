import 'package:flutter/material.dart';
import 'package:firebase_signin/model/days.dart';
import 'package:firebase_signin/constants.dart';
import 'package:firebase_signin/reusable_widgets/reusable_widget.dart';
import 'package:firebase_signin/reusable_widgets/heading_widget.dart';
import 'package:firebase_signin/preview.dart';

class ExerciseScreen extends StatelessWidget {
  final int currentDay = 4;
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      height: MediaQuery.of(context).size.height * 0.9,
      width: double.infinity,
      child: Column(
        children: [_buildDateSection(), _buildActivitySection(context)],
      ),
    );
  }

  Widget _buildActivitySection(BuildContext context) {
    return Expanded(
        child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: CustomColors.kBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            // Ideally these cards should be the data fetched from API or they have a specific model but for simplicity let's just go like this :)
            child: SingleChildScrollView(
                child: Column(children: [
              HeadingWidget(
                text1: 'ACTIVITY',
                text2: 'Show All',
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PreView()),
                  );
                },
                child: _buildCard(
                    // color: CustomColors.kYellowColor,
                    iconPath: 'assets/images/squat1.jpg',
                    time: 'Completed',
                    title: 'Biceps Curl',
                    subtitle: 'Repeat 3-5 times'),
              ),
              _buildCard(
                  // color: CustomColors.kYellowColor,
                  iconPath: 'assets/images/squat2.jpg',
                  time: 'start',
                  title: 'Shoulder Press',
                  subtitle: 'Repeat 3-5 times'),
              _buildCard(
                  // color: CustomColors.kYellowColor,
                  iconPath: 'assets/images/squat3.jpg',
                  time: 'start',
                  title: 'Upright Row',
                  subtitle: 'Repeat 3-5 times'),
              _buildCard(
                  // color: CustomColors.kYellowColor,
                  iconPath: 'assets/images/squat4.jpg',
                  time: 'start',
                  title: 'Lateral Raise',
                  subtitle: 'Repeat 3-5 times'),
              _buildCard(
                  // color: CustomColors.kYellowColor,
                  iconPath: 'assets/images/squat1.jpg',
                  time: 'start',
                  title: 'Bent Over Row',
                  subtitle: 'Repeat 3-5 times'),
            ]))));
  }

  Container _buildCard(
      {required String iconPath,
      required String title,
      required String subtitle,
      required String time}) {
    return Container(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              //color: Colors.red,
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.all(2),
            child: Image.asset(iconPath),
            width: 76,
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                subtitle,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
              )
            ],
          ),
          Expanded(child: Container()),
          Text(
            time,
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 15.0),
          ),
        ],
      ),
    );
  }

  Container _buildDateSection() {
    return Container(
      height: 100,
      // color: Colors.red,
      child: ListView.builder(
          itemCount: days.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            int dayValue = int.parse(days[index].dayNumber);
            return Container(
              padding: const EdgeInsets.all(6.0),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Text(
                    days[index].dayName,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: dayValue == currentDay
                            ? CustomColors.kPrimaryColor
                            : currentDay < dayValue
                                ? CustomColors.kLightColor
                                : Colors.white),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                  CircleAvatar(
                      backgroundColor: dayValue == currentDay
                          ? CustomColors.kPrimaryColor
                          : Colors.transparent,
                      child: Text(
                        days[index].dayNumber,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: dayValue >= currentDay
                                ? CustomColors.kLightColor
                                : Colors.white),
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
