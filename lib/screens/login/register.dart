import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proj_flutter_tcc/components/alertBox.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/consts.dart';
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
  final TextEditingController _registerSex = TextEditingController();
  final TextEditingController _registerBirthDate = TextEditingController();
  var maskDate = new MaskTextInputFormatter(mask: '##/##/####');
  bool _matchingPasswords = false;

  void initState() {
    DateTime now = DateTime.now().add(Duration(hours: -3));
    _registerBirthDate.text = DateFormat('dd/MM/yyyy').format(now).toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPattern(titleScreen: REGISTRATIONTITLESCREEN,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //PaddingWidgetPattern(4.0),
            TextBoxStandard(
              nameLabel: NAMELABELTEXT,
              controller: _registerFirstName,
            ),
            TextBoxStandard(
              nameLabel: SURNAMELABELTEXT,
              controller: _registerSurname,
            ),
            TextBoxStandard(
              nameLabel: EMAILLABELTEXT,
              controller: _registerEmail,
            ),
            TextBoxStandard(
              nameLabel: CPFLABELTEXT,
              controller: _registerCPF,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                readOnly: true,
                inputFormatters: [maskDate],
                controller: _registerBirthDate,
                style: TextStyle(fontSize: 24.0),
                decoration: InputDecoration(
                    labelText: 'Data',
                    suffix: InkWell(
                        onTap: () => _selectDate(context),
                        child: Icon(
                          Icons.calendar_today,
                          color: Color(SYSTEMPRIMARYCOLOR),
                        ))),
              ),
            ),
            TextBoxStandard(
              nameLabel: PASSWORDLABELTEXT,
              controller: _registerPassword,
              onChange: MatchingPasswords,
              obscureText: true,
            ),
            TextBoxStandard(
              nameLabel: PASSWORDAGAINLABELTEXT,
              controller: _registerPasswordAgain,
              onChange: MatchingPasswords,
              obscureText: true,
            ),
            PaddingWidgetPattern(30.0),
            Container(
              height: 50.0,
              width: 300.0,
              child: OutlinedButton(
                child: Text(
                  RECORDUSERBUTTONTEXT,
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor:_matchingPasswords ? Color(SYSTEMPRIMARYCOLOR) : Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  side: BorderSide(
                    width: 2,
                    color: Colors.black26,
                    style: BorderStyle.solid,
                  ),
                ),
                onPressed: _matchingPasswords ? () => signUpUser(context) : null
              ),
            ),
          ],
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
    try{
      final DateTime date = DateTime.parse(_registerBirthDate.text != ''
          ? _registerBirthDate.text.split('/').reversed.join('')
          : '1900/01/01');
      UserContext _user = new UserContext(_registerCPF.text, password: _registerPassword.text, sex: 'M', name: _registerFirstName.text,surname: _registerSurname.text,
          birthDate: date, email: _registerEmail.text);
      var _userCreation = await loginService.userSignUp(_user);
      if(_userCreation != null) {
        return goToMedConsultScreenTest(context);
      } else {
        Navigator.pop(context);
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (context) => UserRegistrationScreen()));
        alert(context,"Registro de usuário", "Não foi possível criar o usuário");
      }
    }
    on Exception catch (error) {
      return alert(context, 'Registro de usuário', error.toString());
    }

  }
  _selectDate(BuildContext context) async {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(hours: -3)),
        firstDate: DateTime(1900),
        lastDate: DateTime.utc(
            DateTime.now().year, DateTime.now().month, DateTime.now().day))
        .then((date) {
      setState(() {
        _registerBirthDate.text = DateFormat('dd/MM/yyyy').format(date).toString();
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
}
