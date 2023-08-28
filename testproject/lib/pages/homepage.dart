import 'dart:async';

import 'package:flutter/material.dart';
import 'package:testproject/components/barrier.dart';
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

  //barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5; //out of 2
  List<List<double>> barrierHeight = [
    // out of 2, where 2 is the entire height of the screen
    //[topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6]
  ];

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

      //keep the map moving
      moveMap();

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
    //check if bird is whitin x coordinates and y coordinates of the barriers
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + birdWidth >= -birdHeight &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
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

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      //keep barrier moving
      setState(() {
        barrierX[i] -= 0.005;
      });

      //if barrier exists the left part of the screen , keeps it looping
      if (barrierX[i] < 1.5) {
        barrierX[i] += 3;
      }
    }
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
                    MyBird(
                      birdY,
                      birdHeight: birdHeight,
                      birdWidth: birdWidth,
                    ),

                    //tap to play
                    // MyCoverScreen(gameHasStarted: gameHasStarted),

                    //top barrier 0
                    MyBarrier(
                        barrierHeight: barrierHeight[0][0],
                        barrierWidth: barrierWidth,
                        barrierX: barrierX[0],
                        isThisBottomBarrier: false),

                    //Bottom Barrier 0
                    MyBarrier(
                        barrierHeight: barrierHeight[0][1],
                        barrierWidth: barrierWidth,
                        barrierX: barrierX[0],
                        isThisBottomBarrier: true),

                    //top barrier 1
                    MyBarrier(
                        barrierHeight: barrierHeight[1][0],
                        barrierWidth: barrierWidth,
                        barrierX: barrierX[1],
                        isThisBottomBarrier: false),

                    //Bottom Barrier 1
                    MyBarrier(
                        barrierHeight: barrierHeight[1][1],
                        barrierWidth: barrierWidth,
                        barrierX: barrierX[1],
                        isThisBottomBarrier: true),
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
