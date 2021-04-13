import 'package:flutter/material.dart';

class TextBox extends StatefulWidget {
  final String nameLabel;
  final String hintLabel;
  final TextEditingController controller;
  final IconData icon;
  final Color iconColor;
  final bool obscureText;
  final bool wordSugestion;
  final bool autocorrect;
  final TextInputType keyboardType;
  final Function onChange;


  TextBox({
    this.nameLabel,
    this.hintLabel,
    this.controller,
    this.icon,
    this.iconColor,
    this.obscureText = false,
    this.wordSugestion = true,
    this.autocorrect = true,
    this.keyboardType = TextInputType.text,
    this.onChange,
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
      wordSugestion: this.wordSugestion,
      autocorrect: this.autocorrect,
      keyboardType: this.keyboardType,
      onChange: this.onChange,
    );
  }
}

class TextBoxState extends State<TextBox> {
  final String nameLabel;
  final String hintLabel;
  final TextEditingController controller;
  final IconData icon;
  final Color iconColor;
  final bool obscureText;
  final bool wordSugestion;
  final bool autocorrect;
  final TextInputType keyboardType;
  final Function onChange;
  bool _isHidden = true;

  TextBoxState({
    this.nameLabel,
    this.hintLabel,
    this.controller,
    this.icon,
    this.iconColor,
    this.obscureText = false,
    this.wordSugestion = true,
    this.autocorrect = true,
    this.keyboardType = TextInputType.text,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
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
        obscureText: !_isHidden,
        enableSuggestions: wordSugestion,
        autocorrect: autocorrect,
        keyboardType: keyboardType,
        onChanged: onChange,
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
