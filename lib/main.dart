import 'package:flutter/material.dart';

import 'models/constants.dart' as Constants;
import 'screens/exams/consultList.dart';
import 'screens/login/login.dart';
import 'screens/user/myData.dart';
import 'screens/login/splash.dart';

void main() => runApp(TCCApp());

class TCCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(Constants.SYSTEM_PRIMARY_COLOR),
        accentColor: Color(Constants.SYSTEM_SECUNDARY_COLOR),
        scrollbarTheme: ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(Colors.grey[500]),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(Constants.SYSTEM_PRIMARY_COLOR),
        accentColor: Color(Constants.SYSTEM_SECUNDARY_COLOR),
        scrollbarTheme: ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(Colors.grey[500]),
        ),
      ),
      routes: {
        '/consultList': (context) => MedExamConsultScreen(),
        '/myData': (context) => MyDataScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
