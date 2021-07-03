import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/consts.dart';
import 'package:proj_flutter_tcc/components/textBox.dart';

class UserRegistrationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserRegistrationWidgetState();
  }
}

class UserRegistrationWidgetState extends State<UserRegistrationScreen> {
  final TextEditingController _registerUser = TextEditingController();
  final TextEditingController _registerPassword = TextEditingController();
  final TextEditingController _registerPasswordAgain = TextEditingController();
  final TextEditingController _registerEmail = TextEditingController();
  final TextEditingController _registerCPF = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPattern(titleScreen: registrationTitleScreen,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PaddingWidgetPattern(8.0),
            TextBoxStandard(
              nameLabel: usernameLabelText,
              controller: _registerUser,
            ),
            TextBoxStandard(
              nameLabel: emailLabelText,
              controller: _registerEmail,
            ),
            TextBoxStandard(
              nameLabel: CPFLabelText,
              controller: _registerCPF,
            ),
            TextBoxStandard(
              nameLabel: passwordLabelText,
              controller: _registerPassword,
              obscureText: true,
            ),
            TextBoxStandard(
              nameLabel: passwordAgainLabelText,
              controller: _registerPasswordAgain,
              obscureText: true,
            ),
            PaddingWidgetPattern(30.0),
            Container(
              height: 50.0,
              width: 300.0,
              child: OutlinedButton(
                child: Text(
                  recordUserButtonText,
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color(systemPrimaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  side: BorderSide(
                    width: 2,
                    color: Colors.black26,
                    style: BorderStyle.solid,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
