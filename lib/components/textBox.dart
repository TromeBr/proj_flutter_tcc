import 'package:flutter/material.dart';
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;

class TextBoxStandard extends StatefulWidget {
  final String nameLabel;
  final String hintLabel;
  final TextEditingController controller;
  final IconData icon;
  final Color iconColor;
  final bool obscureText;
  final bool wordSuggestion;
  final bool autocorrect;
  final TextInputType keyboardType;
  final Function onChange;
  final Function onTap;
  final bool readOnly;
  final int maxLength;



  TextBoxStandard({
    this.nameLabel,
    this.hintLabel,
    this.controller,
    this.icon,
    this.iconColor,
    this.obscureText = false,
    this.wordSuggestion = true,
    this.autocorrect = true,
    this.keyboardType = TextInputType.text,
    this.onChange,
    this.onTap,
    this.readOnly = false,
    this.maxLength
  });

  @override
  State<StatefulWidget> createState() {
    return TextBoxState(
      nameLabel: this.nameLabel,
      hintLabel: this.hintLabel,
      controller: this.controller,
      icon: this.icon,
      iconColor: this.iconColor,
      obscureText: this.obscureText,
      wordSuggestion: this.wordSuggestion,
      autocorrect: this.autocorrect,
      keyboardType: this.keyboardType,
      onChange: this.onChange,
      onTap: this.onTap,
      readOnly: this.readOnly,
      maxLength: this.maxLength,
    );
  }
}

class TextBoxState extends State<TextBoxStandard> {
  final String nameLabel;
  final String hintLabel;
  final TextEditingController controller;
  final IconData icon;
  final Color iconColor;
  final bool obscureText;
  final bool wordSuggestion;
  final bool autocorrect;
  final TextInputType keyboardType;
  Function onChange;
  final Function onTap;
  final bool readOnly;
  final int maxLength;

  bool _isHidden;

  TextBoxState({
    this.nameLabel,
    this.hintLabel,
    this.controller,
    this.icon,
    this.iconColor,
    this.obscureText = false,
    this.wordSuggestion = true,
    this.autocorrect = true,
    this.keyboardType = TextInputType.text,
    this.onChange,
    this.onTap,
    this.readOnly = false,
    this.maxLength,
  });
  initState(){
      _isHidden = obscureText;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
      child: TextField(
        maxLength: maxLength,
        cursorColor: Color(Constants.SYSTEM_PRIMARY_COLOR),
        readOnly: readOnly,
        controller: controller,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(Constants.SYSTEM_PRIMARY_COLOR)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(Constants.SYSTEM_PRIMARY_COLOR)),
          ),
          labelText: nameLabel,
          labelStyle: TextStyle(color: Colors.black, fontSize: 23),
          hintText: hintLabel,
          icon: icon != null ? Icon(icon, color: iconColor) : null,
          suffix: obscureText
              ? InkWell(
                  onTap: _togglePasswordView,
                  child:
                      Icon(_isHidden ? Icons.visibility : Icons.visibility_off))
              : null,
        ),
        obscureText: _isHidden,
        enableSuggestions: wordSuggestion,
        autocorrect: autocorrect,
        keyboardType: keyboardType,
        onChanged: onChange,
        onTap: onTap,
      ),
    );
  }

  void _togglePasswordView() {

    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
