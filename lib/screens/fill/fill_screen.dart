import 'dart:collection';

import 'package:affinnes/point.dart';
import 'package:affinnes/screens/fill/image_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image/image.dart' as img;

class FillScreen extends StatefulWidget {
  const FillScreen({super.key});

  @override
  State<FillScreen> createState() => _FillScreenState();
}

class _FillScreenState extends State<FillScreen> {
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> fillImage(
      Uint8List imageData, int startX, int startY, Color fillColor) async {
    img.Image _image = img.decodeImage(imageData.buffer.asUint8List())!;

    // Получение цвета затравочного пикселя
    int targetColor = _image.getPixel(startX, startY);

    // Создание очереди для алгоритма заливки
    Queue<Point> queue = Queue();
    queue.add(Point(startX.toDouble(), startY.toDouble()));

    // Пока очередь не пуста, продолжаем алгоритм заливки
    while (queue.isNotEmpty) {
      Point currentPoint = queue.removeFirst();

      // Проверка, не выходим ли за границы изображения
      if (currentPoint.x >= 0 &&
          currentPoint.x < _image.width &&
          currentPoint.y >= 0 &&
          currentPoint.y < _image.height) {
        // Проверка, является ли текущий пиксель цветом затравки
        if (_image.getPixelSafe(currentPoint.x.toInt(), currentPoint.y.toInt()) ==
            targetColor) {
          // debugPrint('color: ${fillColor.value}');

          // Закрасить текущий пиксель новым цветом
          _image.setPixelRgba(
            currentPoint.x.toInt(),
            currentPoint.y.toInt(),
            fillColor.red,
            fillColor.green,
            fillColor.blue,
          );

          // Добавить соседние пиксели в очередь для обработки
          queue.add(Point(currentPoint.x + 1, currentPoint.y));
          queue.add(Point(currentPoint.x - 1, currentPoint.y));
          queue.add(Point(currentPoint.x, currentPoint.y + 1));
          queue.add(Point(currentPoint.x, currentPoint.y - 1));
        }
      }
    }

    // Сохранение измененного изображения
    final ByteData modifiedByteData =
        ByteData.sublistView(Uint8List.fromList(img.encodePng(_image)));

    // final codec =
    //     await ui.instantiateImageCodec(modifiedByteData.buffer.asUint8List());
    // final frameInfo = await codec.getNextFrame();
    // final modifiedImage = frameInfo.image;

    setState(() {
      image = modifiedByteData.buffer.asUint8List();
    });
  }

  Future<void> init() async {
    final data = await generateImage();

    setState(() {
      image = data!.buffer.asUint8List();
    });

    if (image != null) {
      await fillImage(
        image!,
        50,
        50,
        Colors.green,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null) Image.memory(image!),
          ],
        ),
      ),
    );
  }
}
