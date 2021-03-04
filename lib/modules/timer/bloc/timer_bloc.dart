import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class TimerBloc {
  int initialTime = 0;

  BehaviorSubject<int> _subjectTime;

  TimerBloc({@required this.initialTime}) {
    _subjectTime = BehaviorSubject<int>.seeded(this.initialTime);
  }

  Stream<int> get timeObservable => _subjectTime.stream;

  void increment() {
    initialTime++;
    _subjectTime.sink.add(initialTime);
  }
}
