import 'package:flutter/material.dart';

import 'screens/exams/consult.dart';
import 'screens/exams/register.dart';
import 'screens/login/login.dart';

void main() => runApp(TCCApp());

class TCCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MedExamConsultScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        scrollbarTheme: ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(Colors.grey[500]),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        accentColor: Colors.white,
        scrollbarTheme: ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
    );
  }
}
