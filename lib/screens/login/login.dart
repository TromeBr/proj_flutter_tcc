import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proj_flutter_tcc/components/alertBox.dart';
import 'package:proj_flutter_tcc/components/textBox.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:proj_flutter_tcc/screens/exams/consultList.dart';
import 'package:proj_flutter_tcc/screens/login/register.dart';
import 'package:proj_flutter_tcc/services/loginServices.dart' as loginService;

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
  final TextEditingController _loginCPF = TextEditingController();
  final TextEditingController _loginPassword = TextEditingController();
  bool _loginButtonVerify = false;
  bool _isLoading = false;
  bool _selected = false;

  @override
  void initState() {
    _isLoading = false;
    _selected = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: IgnorePointer(
        ignoring: _selected,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                PaddingWidgetPattern(50.0),
                Container(
                  child: Image.asset(
                    Constants.LOGO_PATH_S1_P,
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
              ),
              Container(
                child: Text(
                  Constants.MEDIKEEP,
                  style: TextStyle(
                    fontFamily: 'Syncopate',
                    color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //PaddingWidgetPattern(8.0),
                TextBoxStandard(
                  nameLabel: Constants.CPF_LABEL_TEXT,
                  keyboardType: TextInputType.number,
                  controller: _loginCPF,
                  icon: Icons.account_circle_sharp,
                  iconColor: Color(Constants.SYSTEM_PRIMARY_COLOR),
                  onChange: enableButton,
                ),
                TextBoxStandard(
                  nameLabel: Constants.PASSWORD_LABEL_TEXT,
                  controller: _loginPassword,
                  icon: Icons.vpn_key_sharp,
                  iconColor: Color(Constants.SYSTEM_PRIMARY_COLOR),
                  obscureText: true,
                  wordSuggestion: false,
                  autocorrect: false,
                  onChange: enableButton,
                ),
                PaddingWidgetPattern(15.0),
                _isLoading ? Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        color: Color(Constants.SYSTEM_PRIMARY_COLOR),
                        strokeWidth: 2,
                      ),
                      width: 50,
                      height: 50,
                    )
                ) : Container(
                  width: 300.0,
                  height: 50.0,
                  child: OutlinedButton(
                    child: Text(
                      Constants.LOGIN_BUTTON_TEXT,
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _loginButtonVerify
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
                    _loginButtonVerify ? () => signInUser(context) : null,
                  ),
                ),
                PaddingWidgetPattern(8.0),
                Text(Constants.OR_TYPED),
                PaddingWidgetPattern(8.0),
                Container(
                  width: 300.0,
                  height: 50.0,
                  child: OutlinedButton(
                      child: Text(
                        Constants.USER_REGISTRATION_BUTTON_TEXT,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color(Constants.SYSTEM_PRIMARY_COLOR),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        side: BorderSide(
                          width: 2,
                          color: Colors.black26,
                          style: BorderStyle.solid,
                        ),
                      ),
                      onPressed: () {
                        final Future<UserContext> future = Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UserRegistrationScreen();
                            },
                          ),
                        );
                        future.then((UserContext) {});
                      }),
                ),
              ],
            ),
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
          return new MedExamConsultScreen();
        },
      ),
    );
  }

  Future<Widget> signInUser(BuildContext context) async {
    String _email = _loginCPF.text;
    String _password = _loginPassword.text;
    setState(() {
      _isLoading = true;
      _selected = true;
    });
    var _finalUser = await loginService.login(_email, _password);
    if (_finalUser != null) {
      return goToMedConsultScreenTest(context);
    } else {
      alert(context, "Login", msg: "Login Inválido");
      _loginCPF.text = '';
      _loginPassword.text = '';
      setState(() {
        _loginButtonVerify = false;
        _isLoading = false;
        _selected = false;
      });
    }
  }

  void enableButton(String _) {
    if (_loginCPF.text.isNotEmpty && _loginPassword.text.isNotEmpty) {
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
