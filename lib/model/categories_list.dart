import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Categories {
  final String title;
  final Color color;
  final Icon iconName;

  Categories(
    this.title,
    this.color,
    this.iconName,
  );

  static List<Categories> getCategories() {
    List<Categories> items = <Categories>[];
    items.add(Categories(
      "Exercise",
      Colors.blue,
      const Icon(
        Icons.fitness_center,
        size: 26,
      ),
    ));
    items.add(Categories(
      "ROM",
      Colors.green,
      const Icon(
        Icons.airline_seat_recline_extra,
        size: 26,
      ),
    ));
    items.add(Categories(
      "Heart rate",
      Colors.green,
      const Icon(
        Icons.monitor_heart,
        size: 26,
      ),
    ));
    items.add(Categories(
      "Water",
      Colors.blue,
      const Icon(
        Icons.water,
        size: 26,
      ),
    ));
    items.add(Categories(
      "Game",
      Colors.blue,
      const Icon(
        Icons.games,
        size: 26,
      ),
    ));
    items.add(Categories(
      "Gratidue",
      Colors.blue,
      const Icon(
        Icons.health_and_safety_rounded,
        size: 26,
      ),
    ));
    return items;
  }
}
