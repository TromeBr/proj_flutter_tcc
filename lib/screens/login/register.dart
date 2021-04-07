
import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/login_constants.dart';
import 'package:proj_flutter_tcc/components/textBox.dart';

class UserRegistrationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserRegistrationWidgetState();
  }
}


class UserRegistrationWidgetState extends State<UserRegistrationScreen>{
  final TextEditingController _registerUser = TextEditingController();
  final TextEditingController _registerPassword = TextEditingController();
  final TextEditingController _registerPasswordAgain = TextEditingController();
  final TextEditingController _registerEmail = TextEditingController();
  final TextEditingController _registerCPF = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(registrationTitleScreen),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PaddingWidgetPattern(8.0),
            TextBox(
              nameLabel: usernameLabelText,
              controller: _registerUser,
            ),TextBox(
              nameLabel: emailLabelText,
              controller: _registerEmail,
            ),TextBox(
              nameLabel: CPFLabelText,
              controller: _registerCPF,
            ),TextBox(
              nameLabel: passwordLabelText,
              controller: _registerPassword,
              obscureText: true,
            ),TextBox(
              nameLabel: passwordAgainLabelText,
              controller: _registerPasswordAgain,
              obscureText: true,
            ),
            PaddingWidgetPattern(8.0),
            ElevatedButton(
              child: Text(recordUserButtonText),
              onPressed: (){},
            )
          ],
        ),
      ),
    );
  }
  
}
