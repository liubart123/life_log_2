import 'dart:convert';
import 'dart:math';

class RandomUtils {
  static Random getRandomWithStringSeed(String seed) {
    return Random(
      utf8.encode(seed).fold<int>(0, (result, byte) => (result * 2) + byte),
    );
  }
}
