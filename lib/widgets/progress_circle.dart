import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressCircle extends CustomPainter {
  final double progress;

  ProgressCircle({this.progress});

  final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 18;

  @override
  void paint(Canvas canvas, Size size) {
    var size = 330.0;
    Rect rect = Rect.fromCenter(
      center: Offset(0, 0),
      width: size,
      height: size,
    );
    final startAngle = -math.pi / 2;
    final sweepAngle = math.pi * progress;
    canvas.drawArc(rect, startAngle, sweepAngle, false, _paint);
  }

  @override
  bool shouldRepaint(ProgressCircle oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
