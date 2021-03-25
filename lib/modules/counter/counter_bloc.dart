import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intermitty/utils/helpers/normalizer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Phase { FASTING, EATING }

class CounterState {
  Duration duration;
  Phase phase;
  double circleValue = 0.0;

  CounterState({@required this.duration, @required this.phase});
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
    counterState =
        CounterState(duration: const Duration(seconds: 0), phase: initPhase);
    _subjectCount = BehaviorSubject<CounterState>.seeded(counterState);
    WidgetsBinding.instance.addObserver(this);
    initStartTime();
  }

  Stream<CounterState> get stream => _subjectCount.stream;
  CounterState get current => _subjectCount.value;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('WOW: $state');
    saveTimeData(currentTime);
  }

  void initStartTime() async {
    final initTime = await initialTimeFuture;
    if (initTime.isNotEmpty) {
      initialTime = DateTime.parse(initTime);
    } else {
      initialTime = DateTime.now();
    }
    currentTime = DateTime.now();
    run();
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

  void setCircleValue() {
    counterState.circleValue = Normalizer.forCircle(
      maxMeasure: currentPhaseDuration().inSeconds.toDouble(),
      minMeasure: 0.0,
    ).normalize(
      counterState.duration.inSeconds.toDouble(),
    );
  }

  void run() {
    running = !running;
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (running == true) {
        if (counterState.duration >= currentPhaseDuration()) {
          switchPhase();
        }
        currentTime = currentTime.add(const Duration(seconds: 1));
        counterState.duration = currentTime.difference(initialTime);
        setCircleValue();
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
