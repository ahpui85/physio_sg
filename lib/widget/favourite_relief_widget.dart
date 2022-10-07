import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../screens/results.dart';

class FavoriteRelief extends StatefulWidget {
  const FavoriteRelief({Key? key}) : super(key: key);

  @override
  State<FavoriteRelief> createState() => _FavoriteReliefState();
}

class _FavoriteReliefState extends State<FavoriteRelief> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.red,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
}
