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

  test('returns the number for single value', () {
    expect(calc.add('1'), 1);
    expect(calc.add('42'), 42);
  });

  test('handles two numbers', () {
    expect(calc.add('1,5'), 6);
  });

  test('handles any amount of numbers', () {
    expect(calc.add('1,2,3,4,5'), 15);
  });

  test('handles newlines between numbers', () {
    expect(calc.add('1\n2,3'), 6);
    expect(calc.add('10\n20\n30'), 60);
  });

}
