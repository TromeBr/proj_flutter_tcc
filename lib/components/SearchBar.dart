import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/login_constants.dart';
import 'package:proj_flutter_tcc/components/textBox.dart';

class SearchBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchBarState();
  }
}

class SearchBarState extends State<SearchBar> {
  final TextEditingController _searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaddingWidgetPattern(5.0),
        TextField(
          cursorColor: Colors.deepPurple,
          controller: _searchText,
          style: TextStyle(fontSize: 24.0),
          decoration: InputDecoration(
              labelText: 'Busca',
              labelStyle: TextStyle(color: Colors.deepPurple),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple)),
              icon: Icon(Icons.search, color: Colors.deepPurple),
              suffix: InkWell(
                  onTap: _togglePasswordView,
                  child:
                      Icon(Icons.filter_alt_sharp, color: Colors.deepPurple))),
        ),
        PaddingWidgetPattern(5.0),
        Align(
          alignment: Alignment.bottomRight,
          child: OutlinedButton(
              onPressed: () {
                print('Busca efetuada');
              },
              child: Text(
                'Buscar',
                style: TextStyle(color: Colors.deepPurple),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                side: BorderSide(width: 2, color: Colors.deepPurple),
              )),
        ),
      ],
    );
  }

  void _togglePasswordView() {
    setState(() {});
  }
}
