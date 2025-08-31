class StringCalculator {
  int add(String numbers) {
    if (numbers.isEmpty) return 0;
    // Minimal: if not empty and has no delimiters, parse as single number.
    return int.parse(numbers);
  }
}
