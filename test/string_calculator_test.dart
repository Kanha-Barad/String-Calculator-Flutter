import 'package:flutter_test/flutter_test.dart';
import 'package:string_calculator_flutter/string_calculator.dart';

void main() {
  late StringCalculator calc;

  setUp(() {
    calc = StringCalculator();
  });

  test('returns 0 for empty string', () {
    expect(calc.add(''), 0);
  });
}
