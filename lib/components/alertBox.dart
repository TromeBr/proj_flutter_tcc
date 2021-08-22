import 'package:flutter/material.dart';


alert(String page, String msg, {BuildContext context}){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(page),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      );
    }
  );
}