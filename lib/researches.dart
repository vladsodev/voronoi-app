import 'package:image/image.dart' as img;
import 'dart:math';

class DrawPixels{int x; int y; img.Color color; DrawPixels(this.x, this.y, this.color);}

// Функция Генерация x объектов DrawPixels с уникальными координатами в пределах заданной ширины и высоты.
List<DrawPixels> generatePixels(int count, width, height) {
  List<DrawPixels> pixels = [];
  Set<String> positions = {};

  while (pixels.length < count) {
    var x = Random().nextInt(width);
    var y = Random().nextInt(height);
    var key = '$x-$y';
    if (!positions.contains(key)) {
      positions.add(key);
      pixels.add(DrawPixels(x, y, img.ColorInt8.rgb(0, 0, 0))); // здесь указан чёрный цвет изначальный
    }
  }

  return pixels;
}

class RandomColor{int r; int g; int b; RandomColor(this.r, this.g, this.b);}

// Функция генерации случайного цвета
img.Color generateRandomColor() {
  return img.ColorInt8.rgb(
    Random().nextInt(256), // Красный
    Random().nextInt(256), // Зеленый
    Random().nextInt(256), // Синий
  );
}

// Функция для расчёта расстояния между точками
double calculateDistance(int x1, int y1, int x2, int y2) {
  return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
}
