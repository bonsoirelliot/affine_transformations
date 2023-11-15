import 'dart:ui';

import 'package:affinnes/point.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<ByteData?> generateImage() async {
    final points = [
      Point(0, 80),
      Point(0, 100),
      Point(80, 100),
      Point(80, 60),
      Point(100, 60),
      Point(70, 20),
      Point(40, 60),
      Point(60, 60),
      Point(60, 80),
    ];

    final recorder = PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(500, 500)));

    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path = Path();

    path.moveTo(points[0].x, points[0].y);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(
        points[i].x,
        points[i].y,
      );
    }

    path.close();
    canvas.drawPath(path, paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(500, 500);
    final pngBytes = await img.toByteData(format: ImageByteFormat.png);

    return pngBytes;
  }