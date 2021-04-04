import 'package:flutter/material.dart';

import 'screens/login/login.dart';

void main() => runApp(TCCApp());

class TCCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  LoginScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
    );
  }
}
