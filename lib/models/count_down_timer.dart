import 'package:flutter/material.dart';

class CountDownTimer {
  final int duration;
  final Color fillColor;
  final onComplete;

  CountDownTimer({
    required this.duration,
    required this.fillColor,
    required this.onComplete,
  });
}
