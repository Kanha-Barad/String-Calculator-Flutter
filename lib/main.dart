import 'package:flutter/material.dart';
import 'package:string_calculator_flutter/home_page.dart';

void main() {
  runApp(const StringCalculatorApp());
}

class StringCalculatorApp extends StatelessWidget {
  const StringCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'String Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const HomePage(),
    );
  }
}
