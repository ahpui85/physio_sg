import 'package:firebase_signin/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_signin/model/days.dart';
import 'package:firebase_signin/constants.dart';
import 'package:firebase_signin/reusable_widgets/reusable_widget.dart';
import 'package:firebase_signin/reusable_widgets/heading_widget.dart';
//import 'package:firebase_signin/preview.dart';
import 'package:firebase_signin/screens/instruc_to_preview.dart';

import '../model/rom_list.dart';
import '../widget/rom_box_widget.dart';

class GeneralRom extends StatelessWidget {
  GeneralRom({Key? key}) : super(key: key);

  final items = Rom.getRom();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.blueAccent,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
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
      body: Container(
        color: Colors.redAccent,
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: [_buildRomSection(context)],
        ),
      ),
    );
  }

  Widget _buildRomSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: CustomColors.kBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      // Ideally these cards should be the data fetched from API or they have a specific model but for simplicity let's just go like this :)

      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        const HeadingWidget(
          text1: 'ACTIVITY',
          text2: 'Show All',
        ),
        Expanded(
          child: ListView.builder(
            //shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return RomBox(item: items[index]);
            },
          ),
        ),
      ]),
    );
  }
}
