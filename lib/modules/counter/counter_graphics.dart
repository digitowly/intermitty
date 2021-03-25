import 'package:flutter/material.dart';
import 'package:intermitty/widgets/circles/progress_circle_outline.dart';
import 'package:intermitty/widgets/circles/static_circle_fill.dart';
import 'package:intermitty/widgets/circles/static_circle_outline.dart';
import 'package:intermitty/widgets/pointer.dart';

import 'counter_duration_screen.dart';

class CounterGraphics extends StatelessWidget {
  final double progress;
  final Duration duration;
  CounterGraphics({@required this.progress, @required this.duration});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CustomPaint(
          painter: StaticCircleOutline(segment: 2),
        ),
        CustomPaint(
          painter: StaticCircleOutline.eating(segment: .5),
        ),
        CustomPaint(
          painter: ProgressCircleOutlinne(progress: progress, segment: 2),
        ),
        CustomPaint(
          painter: Pointer(rotation: progress),
        ),
        CustomPaint(
          painter: StaticCircleFill(),
        ),
        CounterDurationScreen(duration: duration),
      ],
    );
  }
}
