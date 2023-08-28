import 'dart:async';

import 'package:flutter/material.dart';
import 'package:testproject/components/bird.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //bird variables
  static double birdY = 0.0;
  double intialpos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; //how strong gravity is
  double velocity = 3; //how strong the jump is
  double birdWidth = 0.1; //out of two, twoo being the whole screen.
  double birdHeight = 0.1;

  //game settings
  bool gameHasStarted = false;

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      //Upside down parabola
      //quadratic equation
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = intialpos - height;
      });

      //check if bird is dead
      if (birdIsDead()) {
        timer.cancel();
        gameHasStarted = false;
        _showDialog();
      }

      print(birdY);
      //keep the time going
      time += 0.01;
    });
  }

  bool birdIsDead() {
    //check if bird is hitting top or the bottom of the screen
    if ((birdY < -1 || birdY > 1)) {
      return true;
    }

    //check if bird is hitting barriers

    return false;
  }

  void jump() {
    setState(() {
      time = 0;
      intialpos = birdY;
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      intialpos = birdY;
    });
  }

  void _showDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: const Center(
                child: Text(
              "G A M E   O V E R",
              style: TextStyle(color: Colors.white),
            )),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: const Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(children: [
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                    child: Stack(
                  children: [
                    MyBird(birdY),
                    Container(
                      alignment: Alignment(0, -0.5),
                      child: Text(
                        gameHasStarted ? '' : 'T A P   T O   P L A Y ',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    )
                  ],
                )),
              )),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.brown,
              )),
        ]),
      ),
    );
  }
}
