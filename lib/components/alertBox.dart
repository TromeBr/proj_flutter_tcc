import 'package:flutter/material.dart';


alert(BuildContext context,String page, String msg){
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