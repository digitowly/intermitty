import 'package:flutter/material.dart';

class StaticCircleFill extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset.zero, 20, Paint());
  }

  @override
  bool shouldRepaint(StaticCircleFill circleFill) => false;
}
