
import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/editor.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/login_constants.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginUpdateWidgetState();
  }
}

class LoginUpdateWidgetState extends State<LoginScreen> {
  final TextEditingController _loginUser = TextEditingController();
  final TextEditingController _loginPassword = TextEditingController();
  bool _loginButtonVerify = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            PaddingWidgetPattern(32.0),
            Container(
              child: Image.asset(
                logoPath,
                height: 120,
                width: 120,
                fit: BoxFit.contain,
              ),
            ),
            PaddingWidgetPattern(8.0),
            Editor(
              nameLabel: usernameLabelText,
              controller: _loginUser,
              icon: Icons.account_circle_sharp,
              iconColor: Colors.indigo,
            ),
            Editor(
              nameLabel: passwordLabelText,
              controller: _loginPassword,
              standardPassword: true,
              wordSugestion: false,
              autocorrect: false,
            ),
            PaddingWidgetPattern(8.0),
            ElevatedButton(
              child: Text(loginButtonText),
              onPressed: _loginButtonVerify ? () => signInUser(context) : null,
            ),
            Text(orTyped),
            ElevatedButton(
              child: Text(registerButtonText),
              onPressed: null,
            ),
          ],
        ));
  }

  void signInUser(BuildContext context) {
    final String _user = _loginUser.text;
    final String _password = _loginPassword.text;
    if (_user != null && _password != null) {
      final loginFinal = UserLogin(_user, _password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$loginFinal'),
        ),
      );
      debugPrint('$loginFinal');
    } else {}
  }

  void enableButton() {
    if (_loginUser.text.isNotEmpty && _loginPassword.text.isNotEmpty) {
      setState(() {
        _loginButtonVerify = true;
      });
    }
    else {
      setState(() {
        _loginButtonVerify = false;
      });
    }
  }
}