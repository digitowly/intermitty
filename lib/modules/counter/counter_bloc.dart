import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Phase { FASTING, EATING }

class CounterBloc with WidgetsBindingObserver {
  final Future<String> initialTimeFuture;
  final Duration fastingTime;
  final Duration foodTime;
  Phase phase;

  DateTime initialTime;
  DateTime currentTime;
  Duration duration;
  bool running;

  BehaviorSubject<Duration> _subjectCount;

  CounterBloc({
    @required this.initialTimeFuture,
    @required this.fastingTime,
    @required this.foodTime,
    @required this.phase,
    @required this.running,
  }) {
    _subjectCount = BehaviorSubject<Duration>.seeded(this.duration);
    WidgetsBinding.instance.addObserver(this);
    initStartTime();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('WOW: $state');
    saveTimeData(currentTime);
  }

  Stream<Duration> get timeObservable => _subjectCount.stream;

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
    switch (phase) {
      case Phase.FASTING:
        return fastingTime;
      case Phase.EATING:
        return foodTime;
      default:
        return fastingTime;
    }
  }

  void switchPhase() {
    phase = phase == Phase.FASTING ? Phase.EATING : Phase.FASTING;
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
        duration = currentTime.difference(initialTime);
        if (duration >= currentPhaseDuration()) {
          switchPhase();
        }
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
