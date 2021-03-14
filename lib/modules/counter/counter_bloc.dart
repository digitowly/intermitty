import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterBloc {
  final Future<String> initialTimeFuture;
  final Duration fastingTime;

  DateTime initialTime;
  DateTime currentTime;
  Duration duration;
  bool running;

  BehaviorSubject<Duration> _subjectCount;

  void initStartTime() async {
    final initTime = await initialTimeFuture;
    if (initTime.isNotEmpty) {
      initialTime = DateTime.parse(initTime);
    } else {
      initialTime = DateTime.now();
    }
    currentTime = DateTime.now();
  }

  CounterBloc({
    @required this.initialTimeFuture,
    @required this.fastingTime,
    @required this.running,
  }) {
    _subjectCount = BehaviorSubject<Duration>.seeded(this.duration);
    initStartTime();
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
          // print('success');
        }
        _subjectCount.sink.add(duration);
      } else {
        // saveTimeData(currentTime);
        timer.cancel();
      }
    });
  }

  void dissolve() {
    _subjectCount.close();
  }
}
