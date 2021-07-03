import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/models/consts.dart';
import 'package:proj_flutter_tcc/screens/login/login.dart';

class HamburguerMenu extends StatelessWidget {
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
              color: Color(systemPrimaryColor),
            ),
            arrowColor: Colors.white,
            accountName: Text('User Test'),
            accountEmail: Text('usertest@test.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Color(systemPrimaryColor),
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
              logoff(context);
            },
          ),
        ],
      ),),
    );
  }

  HamburguerMenu();

  void logoff(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }
}
