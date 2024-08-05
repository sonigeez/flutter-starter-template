import 'dart:math';
import 'dart:ui';

Color generateRandomLightColor() {
  final random = Random();

  int red = random.nextInt(56) + 200;
  int green = random.nextInt(56) + 200;
  int blue = random.nextInt(56) + 200;

  // Ensure the color isn't pure white
  while (red == 255 && green == 255 && blue == 255) {
    red = random.nextInt(56) + 200;
    green = random.nextInt(56) + 200;
    blue = random.nextInt(56) + 200;
  }
  return Color.fromRGBO(red, green, blue, 1.0);
}
