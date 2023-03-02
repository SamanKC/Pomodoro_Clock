import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _timeLeft = 1500; // 25 minutes in seconds
  String _status = "working";
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        if (_status == "working") {
          setState(() {
            _timeLeft = 300; // 5 minutes in seconds
            _status = "break";
          });
        } else {
          setState(() {
            _timeLeft = 1500;
            _status = "working";
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pomodoro Clock"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_timeLeft > 0) return;
          setState(() {
            _timeLeft = 1500;
            _status = "working";
          });
        },
        child: Icon(Icons.refresh),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${_timeLeft ~/ 60}:${_timeLeft % 60 < 10 ? "0" : ""}${_timeLeft % 60}",
              style: TextStyle(fontSize: 72),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.play_arrow),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.stop),
                ),
               const SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
