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

  test('supports custom single-char delimiter', () {
    expect(calc.add('//;\n1;2'), 3);
    expect(calc.add('//|\n4|6|10'), 20);
  });

  test('supports custom multi-length delimiter with brackets', () {
    expect(calc.add('//[***]\n1***2***3'), 6);
    expect(calc.add('//[abc]\n7abc8abc9'), 24);
  });

  test('throws for single negative number', () {
    expect(() => calc.add('1,-2,3'), throwsA(isA<Exception>()));
    try {
      calc.add('1,-2,3');
      fail('Expected exception for negative');
    } catch (e) {
      expect(e.toString(), contains('negative numbers not allowed -2'));
    }
  });

  test('throws listing all negative numbers', () {
    try {
      calc.add('-1,2,-3,-5');
      fail('Expected exception');
    } catch (e) {
      expect(e.toString(), contains('negative numbers not allowed -1,-3,-5'));
    }
  });

}
