import 'package:flutter/material.dart';
import 'dart:math' as math;

class Pointer extends CustomPainter {
  final double rotation;

  Pointer({@required this.rotation});

  final Paint _paint = Paint()..color = Colors.blue;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    Rect rect = Rect.fromCenter(
      center: Offset(0, -(330 / 4)),
      width: 17,
      height: 365 / 2,
    );
    RRect rrect = RRect.fromRectXY(rect, 30, 30);
    canvas.rotate(math.pi * rotation);
    path.addRRect(rrect);
    canvas.drawShadow(path, Color(0xff000000), 2, false);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(Pointer pointerDelegate) =>
      pointerDelegate.rotation != rotation;
}
