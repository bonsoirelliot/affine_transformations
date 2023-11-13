import 'package:affinnes/my_painter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double rotationAngle = 0.0;
  double translationX = 0.0;
  double translationY = 0.0;
  double scaleX = 1.0;
  double scaleY = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            width: 300,
            child: CustomPaint(
              painter: MyPainter(
                originalPoints: [
                  Point(0, 0),
                  Point(50, 0),
                  Point(50, 50),
                  Point(0, 50),
                ],
                rotationAngle: rotationAngle,
                translationX: translationX,
                translationY: translationY,
                scaleX: scaleX,
                scaleY: scaleY,
              ),
            ),
          ),
          Text(
            'Поворот на $rotationAngle градусов',
          ),
          Slider(
            value: rotationAngle,
            min: -180,
            max: 180,
            onChanged: (val) {
              setState(() {
                rotationAngle = val;
              });
            },
          ),
          Text(
            'Смещение на $translationX по X',
          ),
          Slider(
            value: translationX,
            min: -180,
            max: 180,
            onChanged: (val) {
              setState(() {
                translationX = val;
              });
            },
          ),
          Text(
            'Смещение на $translationY по Y',
          ),
          Slider(
            value: translationY,
            min: -180,
            max: 180,
            onChanged: (val) {
              setState(() {
                translationY = val;
              });
            },
          ),
          Text(
            'Масштабирование по X в ${scaleX.toStringAsFixed(2)} раз',
          ),
          Slider(
            value: scaleX,
            min: 0.1,
            max: 2.0,
            onChanged: (val) {
              setState(() {
                scaleX = val;
              });
            },
          ),
          Text(
            'Масштабирование по Y в ${scaleX.toStringAsFixed(2)} раз',
          ),
          Slider(
            value: scaleY,
            min: 0.1,
            max: 2.0,
            onChanged: (val) {
              setState(() {
                scaleY = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
