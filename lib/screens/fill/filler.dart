import 'dart:collection';

import 'package:affinnes/point.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class Filler {
  Future<Uint8List> floodFillImage(
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
        if (_image.getPixelSafe(
                currentPoint.x.toInt(), currentPoint.y.toInt()) ==
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

    return modifiedByteData.buffer.asUint8List();
  }

  Future<Uint8List> rowFillImage(
      Uint8List imageData, int startX, int startY, Color fillColor) async {
    // Декодирование изображения из переданных данных
    img.Image _image = img.decodeImage(imageData.buffer.asUint8List())!;

    // Цвет пикселя, с которого начнется заливка
    int targetColor = _image.getPixel(startX, startY);

    // Стек для хранения координат пикселей, которые нужно обработать
    List<int> stack = [];

    // Функция для добавления координат в стек
    void push(int x, int y) {
      stack.add(x);
      stack.add(y);
    }

    // Функция для извлечения координат из стека
    void pop() {
      if (stack.isNotEmpty) {
        startY = stack.removeLast();
        startX = stack.removeLast();
      } else {
        // Если стек пуст, устанавливаем startY в -1 для завершения алгоритма
        startY = -1;
      }
    }

    // Проверка, что начальный пиксель имеет цвет, который нужно заменить
    if (_image.getPixel(startX, startY) != targetColor) {
      // Если начальный пиксель не тот, который нужно заменить, возвращаем исходные данные
      return imageData.buffer.asUint8List();
    }

    // Добавление начального пикселя в стек
    push(startX, startY);

    // Пока стек не пуст
    while (stack.isNotEmpty) {
      // Извлекаем координаты из стека
      pop();

      int x = startX;
      int y = startY;

      // Пока не достигнут верхний край изображения или пока не встречен пиксель другого цвета
      while (y >= 0 && _image.getPixel(x, y) == targetColor) {
        y--;
      }

      // Восстанавливаем y на первый пиксель, который нужно закрасить
      y++;

      // Флаги для отслеживания границы заполняемой области
      bool spanLeft = false;
      bool spanRight = false;

      // Пока не достигнут нижний край изображения или пока не встречен пиксель другого цвета
      while (y < _image.height && _image.getPixel(x, y) == targetColor) {
        // Закрашиваем текущий пиксель
        _image.setPixelRgba(x, y, fillColor.red, fillColor.green, fillColor.blue);

        // Проверяем соседние пиксели для добавления в стек
        if (!spanLeft && x > 0 && _image.getPixel(x - 1, y) == targetColor) {
          push(x - 1, y);
          spanLeft = true;
        } else if (spanLeft && x > 0 && _image.getPixel(x - 1, y) != targetColor) {
          spanLeft = false;
        }

        if (!spanRight && x < _image.width - 1 && _image.getPixel(x + 1, y) == targetColor) {
          push(x + 1, y);
          spanRight = true;
        } else if (spanRight && x < _image.width - 1 && _image.getPixel(x + 1, y) != targetColor) {
          spanRight = false;
        }

        // Переходим к следующей строке
        y++;
      }
    }

    // Кодируем измененное изображение в формат PNG
    final ByteData modifiedByteData =
        ByteData.sublistView(Uint8List.fromList(img.encodePng(_image)));

    // Возвращаем измененные данные
    return modifiedByteData.buffer.asUint8List();
  }
}
