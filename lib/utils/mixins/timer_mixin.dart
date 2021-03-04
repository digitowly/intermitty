import 'dart:async';

class TimerMixin {
  String printEverySecond(String input) {
    Timer.periodic(const Duration(seconds: 1), (Timer t) => 'la');
  }
}
