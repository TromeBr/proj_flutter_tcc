import 'package:flutter/material.dart';

import 'screens/exams/consult.dart';
import 'screens/exams/register.dart';

void main() => runApp(TCCApp());

class TCCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MedExamConsultScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueAccent,
        accentColor: Colors.blueAccent,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        accentColor: Colors.blueAccent,
      ),
    );
  }
}
