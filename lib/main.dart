import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(const StringCalculatorApp());
}

class StringCalculatorApp extends StatelessWidget {
  const StringCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'String Calculator',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      home: const CalculatorScreen(),
    );
  }
}
