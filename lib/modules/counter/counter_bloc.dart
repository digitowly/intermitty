import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Phase { FASTING, EATING }

class CounterState {
  Duration duration;
  Phase phase;

  CounterState({@required this.phase});
}

class CounterBloc with WidgetsBindingObserver {
  final Future<String> initialTimeFuture;
  final Duration fastingTime;
  final Duration foodTime;
  Phase initPhase;

  DateTime initialTime;
  DateTime currentTime;
  bool running;

  var counterState;

  BehaviorSubject<CounterState> _subjectCount;

  CounterBloc({
    @required this.initialTimeFuture,
    @required this.fastingTime,
    @required this.foodTime,
    @required this.initPhase,
    @required this.running,
  }) {
    counterState = CounterState(phase: initPhase);
    _subjectCount = BehaviorSubject<CounterState>.seeded(counterState);
    WidgetsBinding.instance.addObserver(this);
    initStartTime();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('WOW: $state');
    saveTimeData(currentTime);
  }

  Stream<CounterState> get timeObservable => _subjectCount.stream;

  void initStartTime() async {
    final initTime = await initialTimeFuture;
    if (initTime.isNotEmpty) {
      initialTime = DateTime.parse(initTime);
    } else {
      initialTime = DateTime.now();
    }
    currentTime = DateTime.now();
    toggle();
  }

  Duration currentPhaseDuration() {
    switch (counterState.phase) {
      case Phase.FASTING:
        return fastingTime;
      case Phase.EATING:
        return foodTime;
      default:
        return fastingTime;
    }
  }

  void switchPhase() {
    counterState.phase =
        counterState.phase == Phase.FASTING ? Phase.EATING : Phase.FASTING;
    saveTimeData(currentTime);
    initialTime = DateTime.now();
  }

  void saveTimeData(DateTime currentTime) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('time', currentTime.toIso8601String());
  }

  void toggle() {
    running = !running;
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (running == true) {
        currentTime = currentTime.add(const Duration(seconds: 1));
        counterState.duration = currentTime.difference(initialTime);
        if (counterState.duration >= currentPhaseDuration()) {
          switchPhase();
        }
        _subjectCount.sink.add(counterState);
      } else {
        timer.cancel();
      }
    });
  }

  void dissolve() {
    _subjectCount.close();
  }
}
