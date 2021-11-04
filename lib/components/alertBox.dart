import 'package:flutter/material.dart';


alert(BuildContext context,String page, {String msg, List<String> msgList}){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(page),
        content: (msgList != null && msgList.isNotEmpty) ? SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              for (var msg in msgList) Text('- ' + msg),
            ],
          ),
        ) : msg.isNotEmpty ? Text(msg) : null,
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      );
    }
  );
}


void errorReturn(BuildContext context,
    {String errorMessage, List<String> errorsList}) {
  alert(context, "Registro de usuário",
      msg: errorMessage, msgList: errorsList);
}