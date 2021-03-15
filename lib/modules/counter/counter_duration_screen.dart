import 'package:flutter/material.dart';

class CounterDurationScreen extends StatelessWidget {
  final Duration duration;

  CounterDurationScreen({@required this.duration});

  @override
  Widget build(BuildContext build) {
    return Container(
      height: 100,
      width: 300,
      child: GridView.count(
        primary: false,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        crossAxisCount: 3,
        children: [
          TimeSlot(
            displayValue: duration.inHours.toString().padLeft(2, '0'),
          ),
          TimeSlot(
            displayValue: duration.inMinutes.toString().padLeft(2, '0'),
          ),
          TimeSlot(
            displayValue: duration.inSeconds.toString().padLeft(2, '0'),
          ),
        ],
      ),
    );
  }
}

class TimeSlot extends StatelessWidget {
  final String displayValue;

  TimeSlot({@required this.displayValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Text(
        displayValue,
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
