import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc {
  DateTime initialTime;
  DateTime currentTime;
  Duration duration;
  String currentDisplayTime;
  bool running;

  BehaviorSubject<Duration> _subjectCount;

  CounterBloc({@required this.initialTime, @required this.running}) {
    _subjectCount = BehaviorSubject<Duration>.seeded(this.duration);
    currentTime = initialTime;
  }

  Stream<Duration> get timeObservable => _subjectCount.stream;

  void toggle() {
    running = !running;
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (running == true) {
        currentTime = currentTime.add(const Duration(seconds: 1));
        duration = currentTime.difference(initialTime);
        _subjectCount.sink.add(duration);
      } else {
        timer.cancel();
      }
    });
  }

  void dissolve() {
    _subjectCount.close();
  }
}
