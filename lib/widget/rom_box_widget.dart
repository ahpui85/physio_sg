import 'package:firebase_signin/model/rom_list.dart';
import 'package:flutter/material.dart';
import '../screens/instruc_to_preview_rom.dart';

import '../screens/rom_video_info.dart';

class RomBox extends StatelessWidget {
  const RomBox({Key? key, required this.item}) : super(key: key);
  final Rom item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: 140,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RomVideoInfo(item: item)),
                  );
                },
                child: Image.asset("assets/images/" + item.imagePath)),
            Expanded(
                child: Center(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(item.subtitle),
                    ]),
              ),
            )),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InstrucToPreviewRom(item: item)),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Text(item.time),
                ))
          ],
        ),
      ),
    );
  }
}
