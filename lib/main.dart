import 'package:flutter/material.dart';

import 'models/constants.dart' as Constants;
import 'screens/exams/consultList.dart';
import 'screens/login/login.dart';

void main() => runApp(TCCApp());

class TCCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(Constants.SYSTEM_PRIMARY_COLOR),
        accentColor: Color(Constants.SYSTEM_SECUNDARY_COLOR),
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
      routes: {
        '/consultList': (context) => MedExamConsultScreen(),
      },
    );
  }
}
