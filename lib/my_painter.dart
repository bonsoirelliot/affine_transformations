import 'dart:math' as math;
import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final List<Point> originalPoints;
  final double rotationAngle;
  final double translationX;
  final double translationY;
  final double scaleX;
  final double scaleY;

  MyPainter({
    required this.originalPoints,
    required this.rotationAngle,
    required this.translationX,
    required this.translationY,
    required this.scaleX,
    required this.scaleY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //* Копирую точки
    List<Point> points = List.from(originalPoints);

    applyRotation(points);
    applyScaling(points);
    applyTranslation(points);

    //* Параметры рисования
    Paint paint = Paint()
      ..color = Colors.blue
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
  }

  //* Метод переноса точки на dx dy
  void applyTranslation(List<Point> points) {
    for (int i = 0; i < points.length; i++) {
      points[i] = Point(
        points[i].x + translationX,
        points[i].y + translationY,
      );
    }
  }

  //* Метод расширения(сжатия) объекта по dx dy
  void applyScaling(List<Point> points) {
    for (int i = 0; i < points.length; i++) {
      points[i] = Point(
        points[i].x * scaleX,
        points[i].y * scaleY,
      );
    }
  }

  //* Метод поворота на заданный угол
  void applyRotation(List<Point> points) {
    double angle = rotationAngle * (math.pi / 180.0);
    double cosA = math.cos(angle);
    double sinA = math.sin(angle);

    for (int i = 1; i < points.length; i++) {
      double x = points[i].x;
      double y = points[i].y;

      double xPrime = x * cosA - y * sinA;
      double yPrime = x * sinA + y * cosA;

      points[i] = Point(xPrime, yPrime);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Point {
  double x;
  double y;

  Point(this.x, this.y);
}
