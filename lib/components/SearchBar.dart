import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/components/widget_patterns.dart';
import 'package:proj_flutter_tcc/models/consts.dart';
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
        PaddingWidgetPattern(10.0),
        TextFormField(
          controller: _searchText,
          style: TextStyle(fontSize: 24.0),
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (_searchText){
            print(_searchText);
          },
          decoration: InputDecoration(
              labelText: 'Busca',
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(systemPrimaryColor),)),
              icon: Icon(Icons.search),
              suffix: InkWell(
                  onTap: _toggleFilter,
                  child:
                      Icon(Icons.filter_alt_sharp, color: Color(systemPrimaryColor),))),
        ),
      ],
    );
  }

  void _toggleFilter() {
    setState(() {});
  }
}
