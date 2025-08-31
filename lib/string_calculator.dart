class StringCalculator {
  int add(String input) {
    if (input.isEmpty) return 0;

    List<String> delims = [',', '\n'];
    String body = input;

    if (input.startsWith('//')) {
      final newlineIdx = input.indexOf('\n');
      if (newlineIdx == -1) {
        throw FormatException('Invalid input: missing newline after delimiter header');
      }
      final header = input.substring(2, newlineIdx);

      if (header.startsWith('[') && header.endsWith(']')) {
        final pattern = RegExp(r'\[(.*?)\]');
        for (final m in pattern.allMatches(header)) {
          final d = m.group(1);
          if (d != null && d.isNotEmpty) delims.add(d);
        }
      } else {
        delims.add(header);
      }
      body = input.substring(newlineIdx + 1);
    }

    final splitter = RegExp(delims.map(RegExp.escape).join('|'));
    final parts = body.isEmpty ? <String>[] : body.split(splitter);
    final ints = parts.where((p) => p.isNotEmpty).map((p) => int.parse(p)).toList();
    return ints.fold(0, (a, b) => a + b);
  }
}
