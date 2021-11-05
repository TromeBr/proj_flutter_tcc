import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proj_flutter_tcc/components/alertBox.dart';
import 'package:proj_flutter_tcc/components/sharedPreferenceInit.dart';
import 'package:proj_flutter_tcc/components/validators.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;
import 'package:proj_flutter_tcc/components/textBox.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:proj_flutter_tcc/services/dataServices.dart' as dataService;

class MyDataScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyDataWidgetState();
  }
}

class MyDataWidgetState extends State<MyDataScreen> {
  TextEditingController _userPassword = TextEditingController();
  TextEditingController _userEmail = TextEditingController();
  TextEditingController _userCPF = TextEditingController();
  TextEditingController _userCPFConfirmation = TextEditingController();
  TextEditingController _userPasswordConfirmation = TextEditingController();
  TextEditingController _userFirstName = TextEditingController();
  TextEditingController _userSurname = TextEditingController();
  TextEditingController _userBirthDate = TextEditingController();
  var maskDate = new MaskTextInputFormatter(mask: '##/##/####');
  String _value = 'M';
  bool _updateVerify = false;
  UserContext _userContext;
  bool validateCPF = false;
  bool passwordValidator = false;

  UserContext get userContext => _userContext;

  set userContext(UserContext value) {
    _userContext = value;
  }

  @override
  void initState() {
    super.initState();
    getUser(context);
  }

  @override
  void dispose() {
    _userPassword.dispose();
    _userEmail.dispose();
    _userFirstName.dispose();
    _userSurname.dispose();
    _userBirthDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPattern(
        titleScreen: Constants.DATA_USER_TITLE_SCREEN,
        actions: _updateVerify
            ? <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.update_outlined,
                      color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                    ),
                    onPressed: () async {
                      var errors = _userConsist();
                      if (errors.isEmpty) {
                        if (_userPassword.text.isEmpty)
                          updateUser();
                        else
                          _showPasswordConfirmationDialog();
                      } else
                        errorReturn(context, errorsList: errors);
                    }),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //PaddingWidgetPattern(4.0),
            TextBoxStandard(
              nameLabel: Constants.CPF_LABEL_TEXT,
              controller: _userCPF,
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
              child: TextFormField(
                onChanged: hasChanged,
                readOnly: true,
                inputFormatters: [maskDate],
                controller: _userBirthDate,
                style: TextStyle(fontSize: 24.0),
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                ),
              ),
            ),
            TextBoxStandard(
              nameLabel: Constants.NAME_LABEL_TEXT,
              controller: _userFirstName,
              onChange: hasChanged,
            ),
            TextBoxStandard(
              nameLabel: Constants.SURNAME_LABEL_TEXT,
              controller: _userSurname,
              onChange: hasChanged,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
            ),

            TextBoxStandard(
              nameLabel: Constants.EMAIL_LABEL_TEXT,
              controller: _userEmail,
              keyboardType: TextInputType.emailAddress,
              onChange: hasChanged,
            ),

            TextBoxStandard(
              nameLabel: Constants.PASSWORD_LABEL_TEXT,
              controller: _userPassword,
              obscureText: true,
              onChange: hasChanged,
            ),
            Container(
                margin: EdgeInsets.only(top: 30.0, left: 20.0),
                width: double.infinity,
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text(
                      'Sexo:',
                      style: TextStyle(fontSize: 24),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10.0)),
                    DropdownButton<String>(
                      style: TextStyle(fontSize: 24, color: Colors.black),
                      iconSize: 24,
                      elevation: 16,
                      hint: Text("Sexo"),
                      value: _value,
                      autofocus: true,
                      onChanged: (String val) {
                        setState(() {
                          _value = val;
                        });
                        hasChanged('');
                      },
                      items: <DropdownMenuItem<String>>[
                        new DropdownMenuItem(
                          child: new Text('Masculino'),
                          value: 'M',
                        ),
                        new DropdownMenuItem(
                          child: new Text('Feminino'),
                          value: 'F',
                        ),
                        new DropdownMenuItem(
                          child: new Text('Outro'),
                          value: 'U',
                        ),
                      ],
                    ),
                  ],
                )),
            PaddingWidgetPattern(15.0),
            Container(
              height: 50.0,
              width: 300.0,
              child: OutlinedButton(
                child: Text(
                  Constants.USER_REMOVE,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _showUserConfirmationDialog();
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            PaddingWidgetPattern(20.0),
          ],
        ),
      ),
    );
  }

  List<String> _userConsist() {
    List<String> errors = [];
    if (_userFirstName.text.isEmpty) {
      errors.add('O primeiro nome não foi fornecido');
    }
    if (_userSurname.text.isEmpty) {
      errors.add('O sobrenome nome não foi fornecido');
    }
    if (validateEmail(_userEmail.text)) {
      errors.add('Um E-mail válido não foi fornecido');
    }
    if (_userPassword.text.isNotEmpty) if (validatePassword(_userPassword.text)) {
      errors.add('A senha não atende aos critérios de segurança');
    }
    return errors;
  }

  Future<String> getUser(BuildContext context) async {
    var user = await initializePreference();
    if (user != null) {
      Map<String, dynamic> decoded = jsonDecode(user);
      setState(() {
        this._userFirstName.text = UserContext.fromJson(decoded).name;
        this._userSurname.text = UserContext.fromJson(decoded).surname;
        this._userEmail.text = UserContext.fromJson(decoded).email;
        this._userCPF.text = UserContext.fromJson(decoded).CPF;
        this._userBirthDate.text = DateFormat('dd/MM/yyyy')
            .format(UserContext.fromJson(decoded).birthDate)
            .toString();
        this._userPassword.text = UserContext.fromJson(decoded).password;
        this._value = UserContext.fromJson(decoded).sex;
      });
      final DateTime date = _userBirthDate.text != ''
          ? DateFormat('dd/MM/yyyy').parse(_userBirthDate.text)
          : null;
      UserContext _user = new UserContext(_userCPF.text,
          password: '',
          sex: _value,
          name: _userFirstName.text,
          surname: _userSurname.text,
          birthDate: date,
          email: _userEmail.text);
      userContext = _user;
    }
  }

  void hasChanged(String _) {
    final DateTime date = _userBirthDate.text != ''
        ? DateFormat('dd/MM/yyyy').parse(_userBirthDate.text)
        : null;
    UserContext _newUser = new UserContext(_userCPF.text,
        password: _userPassword.text,
        sex: _value,
        name: _userFirstName.text,
        surname: _userSurname.text,
        birthDate: date,
        email: _userEmail.text);
    if (userChanged(_newUser)) {
      setState(() {
        _updateVerify = true;
      });
    } else {
      setState(() {
        _updateVerify = false;
      });
    }
  }

  bool userChanged(UserContext newUser) {
    return userContext != newUser;
  }

  void _updateResult(String messageTitle, String message) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(messageTitle),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).restorablePopAndPushNamed('/myData');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUserConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Atenção: Remoção de Usuário'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Ao confirmar com seu CPF, seu usuário será deletado.'),
                TextFormField(
                  controller: _userCPFConfirmation,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: Constants.CPF_LABEL_TEXT,
                      errorText: validateCPF ? 'CPF inválido' : null),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirmar'),
              onPressed: () async {
                if (_userCPFConfirmation.text == _userCPF.text) {
                  _userCPFConfirmation.text = '';
                  var _userDelete = await dataService.deleteUser();
                  if (_userDelete)
                    _deleteResult("Remoção Concluída",
                        "O usuário foi deletado com sucesso",
                        userDeleted: true);
                  else
                    _deleteResult(
                        "Erro ao deletar", "Por favor, tente mais tarde");
                } else {
                  setState(() {
                    validateCPF = true;
                  });
                  Navigator.of(context).pop();
                  _showUserConfirmationDialog();
                }
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                setState(() {
                  validateCPF = false;
                });
                _userCPFConfirmation.text = '';
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showPasswordConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação de Senha'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _userPasswordConfirmation,
                  decoration: InputDecoration(
                      labelText: 'Digite a nova senha novamente',
                      errorText: passwordValidator ? 'Senha Inválida' : null),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirmar'),
              onPressed: () async {
                if (_userPasswordConfirmation.text == _userPassword.text) {
                  _userPasswordConfirmation.text = '';
                  updateUser();
                } else {
                  setState(() {
                    passwordValidator = true;
                  });
                  Navigator.of(context).pop();
                  _showPasswordConfirmationDialog();
                }
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                setState(() {
                  passwordValidator = false;
                });
                _userPasswordConfirmation.text = '';
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteResult(String error, String messageError,
      {bool userDeleted = false}) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(error),
          content: Text(messageError),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if (userDeleted)
                  Navigator.of(context)
                      .restorablePopAndPushNamed('/LoginScreen');
                else
                  Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> updateUser() async {
    var _userUpdate =
        await dataService.userUpdate(this._userContext);
    if (_userUpdate)
      _updateResult("Alteração concluída",
          "O usuário foi alterado com sucesso");
    else
      _updateResult("Erro ao atualizar",
          "Por favor, tente mais tarde");
  }
}
