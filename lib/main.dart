import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(TCCApp());

class TCCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TelaLogin(),
      ),
    );
  }
}

class TelaLogin extends StatelessWidget {
  final TextEditingController _LoginUser = TextEditingController();
  final TextEditingController _LoginPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
        ),
        Container(
          child: Image.asset(
            'assets/images/PUC_SP.png',
            height: 120,
            width: 120,
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _LoginUser,
            style: TextStyle(fontSize: 24.0),
            decoration: InputDecoration(
              labelText: 'Nome de usuário',
              hintText: 'Usuário',
              icon: Icon(
                Icons.account_circle_sharp,
                color: Colors.blueAccent,
              ),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _LoginPassword,
            style: TextStyle(fontSize: 24.0),
            decoration: InputDecoration(
              labelText: 'Senha',
              hintText: '******',
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        ElevatedButton(
          child: Text('Login'),
          onPressed: () {
            final String _user = _LoginUser.text;
            final String _password = _LoginPassword.text;
            if (_user != null && _password != null) {
              final loginFinal = LoginUsuario(_user, _password);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$loginFinal'),
                ),
              );
              debugPrint('$loginFinal');
            } else {}
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Text('Ou'),
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        ElevatedButton(child: Text('Registre-se'), onPressed: null),
      ],
    ));
  }
}

class LoginUsuario {
  final String loginUser;
  final String loginPassword;

  LoginUsuario(this.loginUser, this.loginPassword);

  @override
  String toString() {
    return 'LoginUsuario{User: $loginUser, Password: $loginPassword}';
  }
}


