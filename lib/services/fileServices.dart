import 'dart:convert';
import 'dart:io';


import 'package:http/http.dart' as http;
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<File> getFile({int id = 0}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs?.getString("userContext");
    Map<String,dynamic> decoded = jsonDecode(result);

    final response = await http.get(
        Uri.parse(
            'https://orchestrator-medikeep.herokuapp.com/exams/patient/' + id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'Authorization' : 'Bearer ${UserContext.fromJson(decoded).token}'
        });

    File fileReturn;

    if (response.statusCode == 200) {
      return fileReturn;
    }
    if (response.statusCode == 406) {
      return null;
    }
     return null;
  } on Exception catch (error) {
    throw new Exception(error.toString());
  }
}
