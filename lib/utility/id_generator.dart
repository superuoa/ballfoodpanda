import 'dart:math';

class IdGenerator {
  String idGenerator() {
    final now = DateTime.now();
    Random random = Random();
    int i = random.nextInt(1000000);

    return now.microsecondsSinceEpoch.toString() + i.toString();
  }
}