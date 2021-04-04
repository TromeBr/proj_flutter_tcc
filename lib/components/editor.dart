
import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  final String nameLabel;
  final String hintLabel;
  final TextEditingController controller;
  final IconData icon;
  final Color iconColor;
  final bool standardPassword;
  final bool wordSugestion;
  final bool autocorrect;
  final TextInputType keyboardType;

  Editor({
    this.nameLabel,
    this.hintLabel,
    this.controller,
    this.icon,
    this.iconColor,
    this.standardPassword = false,
    this.wordSugestion = true,
    this.autocorrect = true,
    this.keyboardType = TextInputType.text,
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
            icon: icon != null ? Icon(icon, color: iconColor) : null),
        obscureText: standardPassword,
        enableSuggestions: wordSugestion,
        autocorrect: autocorrect,
        keyboardType: keyboardType,
      ),
    );
  }
}