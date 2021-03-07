import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterBloc {
  final DateTime initialTime;
  final Duration fastingTime;

  DateTime currentTime;
  Duration duration;
  bool running;

  BehaviorSubject<Duration> _subjectCount;

  CounterBloc({
    @required this.initialTime,
    @required this.fastingTime,
    @required this.running,
  }) {
    _subjectCount = BehaviorSubject<Duration>.seeded(this.duration);
    currentTime = initialTime;
  }

  Stream<Duration> get timeObservable => _subjectCount.stream;

  void saveTimeData(DateTime currentTime) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('time', currentTime.toIso8601String());
  }

  void toggle() {
    running = !running;
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (running == true) {
        currentTime = currentTime.add(const Duration(seconds: 1));
        duration = currentTime.difference(initialTime);
        if (duration >= fastingTime) {
          print('success');
        }
        _subjectCount.sink.add(duration);
      } else {
        saveTimeData(currentTime);
        timer.cancel();
      }
    });
  }

  void dissolve() {
    _subjectCount.close();
  }
}
