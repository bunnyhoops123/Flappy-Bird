import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyBird extends StatelessWidget {
  final birdY;
  const MyBird(this.birdY, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, birdY),
      child: Image.asset(
        'assets/bird.png',
        width: 60,
      ),
    );
  }
}
