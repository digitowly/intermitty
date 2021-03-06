import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc {
  int initialTime = 0;
  bool running = false;

  BehaviorSubject<int> _subjectCount;

  CounterBloc({@required this.initialTime, @required this.running}) {
    _subjectCount = BehaviorSubject<int>.seeded(this.initialTime);
  }

  Stream<int> get timeObservable => _subjectCount.stream;

  void toggle() {
    running = !running;
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (running == true) {
        initialTime++;
        _subjectCount.sink.add(initialTime);
      } else {
        timer.cancel();
      }
    });
  }

  void dissolve() {
    _subjectCount.close();
  }
}
