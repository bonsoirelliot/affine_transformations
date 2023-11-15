import 'dart:math' as math;
import 'package:affinnes/point.dart';
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

    final rotationPoint = Point(0, 100);

    for (int i = 0; i < points.length; i++) {
      //* Перенос в начало координат
      double x = points[i].x - rotationPoint.x;
      double y = points[i].y - rotationPoint.y;

      //* Поворот
      double xPrime = x * cosA - y * sinA;
      double yPrime = x * sinA + y * cosA;

      //* Возврат в исходную систему
      points[i] = Point(xPrime + rotationPoint.x, yPrime + rotationPoint.y);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
