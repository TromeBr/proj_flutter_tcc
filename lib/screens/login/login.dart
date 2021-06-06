import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/textBox.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/login_constants.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:proj_flutter_tcc/screens/login/register.dart';

class LoginScreen extends StatefulWidget {
  LoginUpdateWidgetState state;

  @override
  State<StatefulWidget> createState() {
    var state = LoginUpdateWidgetState();
    this.state = state;
    return state;
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
          TextBoxStandard(
            nameLabel: usernameLabelText,
            controller: _loginUser,
            icon: Icons.account_circle_sharp,
            iconColor: Colors.indigo,
            onChange: enableButton,
          ),
          TextBoxStandard(
            nameLabel: passwordLabelText,
            controller: _loginPassword,
            obscureText: true,
            wordSugestion: false,
            autocorrect: false,
            onChange: enableButton,
          ),
          PaddingWidgetPattern(15.0),
      Container(
        width: 300.0,
        height: 50.0,
        child: OutlinedButton(
          child: Text(
            loginButtonText,
            style: TextStyle(color: Colors.white),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            side: BorderSide(
              width: 2,
              color: Colors.black26,
              style: BorderStyle.solid,
            ),
          ),
          onPressed: _loginButtonVerify ? () => signInUser(context) : null,
        ),
      ),
          PaddingWidgetPattern(8.0),
          Text(orTyped),
          PaddingWidgetPattern(8.0),
      Container(
        width: 300.0,
        height: 50.0,
        child: OutlinedButton(
            child: Text(
              userRegistrationButtonText,
              style: TextStyle(color: Colors.white),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              side: BorderSide(
                width: 2,
                color: Colors.black26,
                style: BorderStyle.solid,
              ),
            ),
            onPressed: () {
              final Future<UserLogin> future = Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return UserRegistrationScreen();
                  },
                ),
              );
              future.then((UserLogin) {});
            }),
      ),

        ],
      ),
    );
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

  void enableButton(String _) {
    if (_loginUser.text.isNotEmpty && _loginPassword.text.isNotEmpty) {
      setState(() {
        _loginButtonVerify = true;
      });
    } else {
      setState(() {
        _loginButtonVerify = false;
      });
    }
  }
}
