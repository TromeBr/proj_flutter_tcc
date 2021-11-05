import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proj_flutter_tcc/components/alertBox.dart';
import 'package:proj_flutter_tcc/components/validators.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;
import 'package:proj_flutter_tcc/components/textBox.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:proj_flutter_tcc/screens/exams/consultList.dart';
import 'package:proj_flutter_tcc/services/loginServices.dart' as loginService;

class UserRegistrationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserRegistrationWidgetState();
  }
}

class UserRegistrationWidgetState extends State<UserRegistrationScreen> {
  final TextEditingController _registerPassword = TextEditingController();
  final TextEditingController _registerPasswordAgain = TextEditingController();
  final TextEditingController _registerEmail = TextEditingController();
  final TextEditingController _registerCPF = TextEditingController();
  final TextEditingController _registerFirstName = TextEditingController();
  final TextEditingController _registerSurname = TextEditingController();
  final TextEditingController _registerBirthDate = TextEditingController();
  var maskDate = new MaskTextInputFormatter(mask: '##/##/####');
  bool _matchingPasswords = false;
  String _value = 'M';
  bool _isLoading = false;
  bool _selected = false;

  void initState() {
    _isLoading = false;
    _selected = false;
    DateTime now = DateTime.now().add(Duration(hours: -3));
    _registerBirthDate.text = DateFormat('dd/MM/yyyy').format(now).toString();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _selected,
      child: Scaffold(
        appBar: AppBarPattern(
          titleScreen: Constants.REGISTRATION_TITLE_SCREEN,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //PaddingWidgetPattern(4.0),
              TextBoxStandard(
                nameLabel: Constants.NAME_LABEL_TEXT,
                controller: _registerFirstName,
              ),
              TextBoxStandard(
                nameLabel: Constants.SURNAME_LABEL_TEXT,
                controller: _registerSurname,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
              ),
              TextBoxStandard(
                nameLabel: Constants.EMAIL_LABEL_TEXT,
                controller: _registerEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              TextBoxStandard(
                nameLabel: Constants.CPF_LABEL_TEXT,
                controller: _registerCPF,
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                child: TextFormField(
                  readOnly: true,
                  inputFormatters: [maskDate],
                  controller: _registerBirthDate,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(
                      labelText: 'Data de Nascimento',
                      suffix: InkWell(
                          onTap: () => _selectDate(context),
                          child: Icon(
                            Icons.calendar_today,
                            color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                          ))),
                ),
              ),
              TextBoxStandard(
                nameLabel: Constants.PASSWORD_LABEL_TEXT,
                controller: _registerPassword,
                onChange: MatchingPasswords,
                obscureText: true,
              ),
              TextBoxStandard(
                nameLabel: Constants.PASSWORD_AGAIN_LABEL_TEXT,
                controller: _registerPasswordAgain,
                onChange: MatchingPasswords,
                obscureText: true,
              ),
              Container(
                  margin: EdgeInsets.only(top: 20.0, left: 20.0),
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
                        onChanged: (String val) {
                          setState(() {
                            _value = val;
                          });
                        },
                      ),
                    ],
                  )),
              PaddingWidgetPattern(15.0),
              _isLoading ? Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(
                      color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                      strokeWidth: 2,
                    ),
                    width: 100,
                    height: 100,
                  )
              ) : Container(
                height: 50.0,
                width: 300.0,
                child: OutlinedButton(
                    child: Text(
                      Constants.RECORD_USER_BUTTON_TEXT,
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _matchingPasswords
                          ? Color(Constants.SYSTEM_PRIMARY_COLOR)
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      side: BorderSide(
                        width: 2,
                        color: Colors.black26,
                        style: BorderStyle.solid,
                      ),
                    ),
                    onPressed:
                    _matchingPasswords ? () => signUpUser(context) : null),
              ),
              PaddingWidgetPattern(20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget goToMedConsultScreenTest(BuildContext context) {
    final Future<UserContext> future = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MedExamConsultScreen();
        },
      ),
    );
  }

  Future<Widget> signUpUser(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
        _selected = true;
      });
      final DateTime date = _registerBirthDate.text != ''
          ? DateFormat('dd/MM/yyyy').parse(_registerBirthDate.text)
          : null;
      var errors = _userConsist();
      if (errors.isNotEmpty) {
        errorReturn(context, errorsList: errors);
        setState(() {
          _isLoading = false;
          _selected = false;
        });
      }
      else{
        UserContext _user = new UserContext(_registerCPF.text,
            password: _registerPassword.text,
            sex: _value,
            name: _registerFirstName.text,
            surname: _registerSurname.text,
            birthDate: date,
            email: _registerEmail.text);
        var _userCreation = await loginService.userSignUp(_user);
        return goToMedConsultScreenTest(context);
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _selected = false;
      });
      errorReturn(context, errorMessage: error.message[0]);
    }
  }

  _selectDate(BuildContext context) async {
    return showDatePicker(
            context: context,
            initialDate: DateTime.now().add(Duration(hours: -3)),
            firstDate: DateTime(1900),
            lastDate: DateTime.utc(
                DateTime.now().year, DateTime.now().month, DateTime.now().day),
            initialDatePickerMode: DatePickerMode.year)
        .then((date) {
      setState(() {
        _registerBirthDate.text =
            DateFormat('dd/MM/yyyy').format(date).toString();
      });
    });
  }

  void MatchingPasswords(String _) {
    if (_registerPassword.text == _registerPasswordAgain.text) {
      setState(() {
        _matchingPasswords = true;
      });
    } else {
      setState(() {
        _matchingPasswords = false;
      });
    }
  }

  List<String> _userConsist() {
    List<String> errors = [];
    if (_registerFirstName.text.isEmpty) {
      errors.add('O primeiro nome não foi fornecido');
    }
    if (_registerSurname.text.isEmpty) {
      errors.add('O sobrenome nome não foi fornecido');
    }
    if (_registerBirthDate.text ==
        DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(Duration(hours: -3)))
            .toString()) {
      errors.add('Uma data de nascimento válida não foi fornecida');
    }
    if (validateEmail(_registerEmail.text)) {
      errors.add('Um E-mail válido não foi fornecido');
    }
    if (validateCPF(_registerCPF.text)) {
      errors.add('Um CPF válido não foi fornecido');
    }
    if (validatePassword(_registerPassword.text)) {
      errors.add('A senha não atende aos critérios de segurança');
    }
    return errors;
  }

}
