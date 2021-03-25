import 'package:flutter/material.dart';
import 'dart:math' as math;

class StaticCircleOutline extends CustomPainter {
  final double segment;
  Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 30;

  StaticCircleOutline({this.segment}) {
    _paint.color = Colors.purple;
  }

  StaticCircleOutline.eating({this.segment}) {
    _paint.color = Colors.green;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var size = 330.0;
    Rect rect = Rect.fromCenter(
      center: Offset(0, 0),
      width: size,
      height: size,
    );
    final startAngle = -math.pi / 3;
    final sweepAngle = math.pi * segment;
    canvas.drawArc(rect, startAngle, sweepAngle, false, _paint);
  }

  @override
  bool shouldRepaint(StaticCircleOutline oldDelegate) {
    return oldDelegate.segment != segment;
  }
}
