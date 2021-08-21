import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/sharedPreferenceInit.dart';
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:proj_flutter_tcc/screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HamburguerMenu extends StatefulWidget {
  
  HamburguerMenuState state;

  @override
  State<StatefulWidget> createState() {
    var state = HamburguerMenuState();
    this.state = state;
    return state;
  }
}

class HamburguerMenuState extends State<HamburguerMenu> {
  String name = 'Nome Teste';
  String email = 'Email Teste';
  @override
  void initState() {
    super.initState();
    getUser(context);
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scrollbar(
        isAlwaysShown: false,
        child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(Constants.SYSTEM_PRIMARY_COLOR),
            ),
            arrowColor: Colors.white,
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Color(Constants.SYSTEM_PRIMARY_COLOR),
              ),
            ),
            onDetailsPressed: () {},
            otherAccountsPictures: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 0.0),
                  GestureDetector(
                    onTap: () {
                    },
                    child: CircleAvatar(
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Sair'),
            onTap: ()  {
              //Navigator.pop(context);
              logout(context);
            },
          ),
        ],
      ),),
    );
  }

  HamburguerMenuState();

  Future<void> logout(BuildContext context) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(prefs.getString('userContext'));
      prefs.remove('userContext');
      print(prefs.getString('userContext'));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext ctx) => LoginScreen()));

  }
  Future<String> getUser(BuildContext context) async {
    var _user = await initializePreference();
    if(_user != null) {
      Map<String,dynamic> decoded = jsonDecode(_user);
      setState(() {
        this.name = UserContext.fromJson(decoded).name;
        this.email = UserContext.fromJson(decoded).email;
      });
    }
  }
}
