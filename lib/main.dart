import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ShellGame(),
    );
  }
}

class ShellGame extends StatefulWidget {
  const ShellGame({super.key});

  @override
  _ShellGameState createState() => _ShellGameState();
}

class _ShellGameState extends State<ShellGame> {
  Random random = Random();
  late int correctCup;
  late int selectedCup;
  late int objectCup;
  bool objectVisible = true;
  bool shuffling = false;
  String result = '';

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    objectVisible = true;
    Future.delayed(const Duration(seconds: 2), () {
      objectCup = random.nextInt(3);
      objectVisible = false;
      shuffling = true;
      shuffleCups(); // Start shuffling animation
      Future.delayed(const Duration(seconds: 3), () {
        shuffling = false;
        setState(() {});
      });
    });

    correctCup = -1;
    selectedCup = -1;
    result = '';
  }

  void shuffleCups() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        correctCup = random.nextInt(3);
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          correctCup = random.nextInt(3);
        });
      });
    });
  }

  void selectCup(int cupIndex) {
    if (shuffling || selectedCup != -1) return;

    setState(() {
      selectedCup = cupIndex;
      if (selectedCup == correctCup) {
        result = 'You Win!';
        if (kDebugMode) {
          print(result);
        }
      } else {
        result = 'Try Again';
        if (kDebugMode) {
          print(result);
        }
      }
    });
  }

  void restartGame() {
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Shell Game')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (objectVisible) const Text('Object is here!'),
            if (shuffling)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 200,
                  height: 100,
                  color: Colors.grey,
                  child: const Center(
                    child: Text(
                      'Shuffling Cups...',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            if (!shuffling && !objectVisible)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCup(0),
                  buildCup(1),
                  buildCup(2),
                ],
              ),
            Text(result),
            ElevatedButton(
              onPressed: () {
                restartGame();
              },
              child: const Text('Restart Game'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCup(int cupIndex) {
    return GestureDetector(
      onTap: () {
        selectCup(cupIndex);
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 1), // Cup shuffle duration
        width: 100,
        height: 100,
        color: selectedCup == cupIndex ? Colors.blue : Colors.green,
        alignment: Alignment.center,
        child: Text(
          selectedCup == cupIndex ? 'Object' : 'Cup $cupIndex',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
