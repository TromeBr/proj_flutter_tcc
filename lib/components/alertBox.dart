import 'package:flutter/material.dart';


alert(BuildContext context,String page, {String msg, List<String> msgList}){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(page),
        content: msgList.isNotEmpty ? SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              for (var msg in msgList) Text('- ' + msg),
            ],
          ),
        ) : msg.isNotEmpty ? msg : null,
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      );
    }
  );
}