import 'package:flutter/material.dart';

class HamburguerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            arrowColor: Colors.white,
            accountName: Text('User Test'),
            accountEmail: Text('usertest@test.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.deepPurple,
              ),
            ),
            onDetailsPressed: () {},
            otherAccountsPictures: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 0.0),
                  GestureDetector(
                    onTap: () {
                      print('Foi');
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
            title: Text('Item 2'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  HamburguerMenu();
}
