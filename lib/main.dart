import 'package:flutter/material.dart';
import 'package:pomodoro_clock/views/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pomodoro Clock',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
