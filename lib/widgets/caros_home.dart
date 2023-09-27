// carousel_widget.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/playAreas.dart';


class PlayAreaCarousel extends StatelessWidget {
  final List<PlayArea> playAreas;
  final List options=['assets/carousel1.png',
    'assets/carousel2.png','assets/caros34.png','assets/caros45.png',
  ];

  PlayAreaCarousel({required this.playAreas});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: options.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        final playArea = options[index];
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: Card(
            elevation: 5.0,
            child: Image.asset(playArea),
            ),
          );
      },
      options: CarouselOptions(
        autoPlay: true,
        enableInfiniteScroll: false,
        initialPage: 0,
        viewportFraction: 0.8,
        aspectRatio: 2.0,
      ),
    );
  }
}
