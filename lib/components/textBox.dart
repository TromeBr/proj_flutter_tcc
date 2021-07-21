import 'package:flutter/material.dart';

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
    this.readOnly = false

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
  final Function onChange;
  final Function onTap;
  final bool readOnly;
  
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
  });
  initState(){
      _isHidden = obscureText;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          labelText: nameLabel,
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
