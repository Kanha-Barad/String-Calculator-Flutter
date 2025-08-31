class StringCalculator {
  int add(String numbers) {
    if (numbers.isEmpty) return 0;

    final parts = numbers.split(RegExp(r'[,\n]'));
    final ints = parts.where((p) => p.isNotEmpty).map((p) => int.parse(p)).toList();
    return ints.fold(0, (a, b) => a + b);
  }
}
