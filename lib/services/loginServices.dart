import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:proj_flutter_tcc/components/appException.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<UserContext> login(String CPF, String password) async {
  try {
    UserContext user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String body = jsonEncode({"cpf": CPF, "password": password});
    final response = await http.post(
      Uri.parse('https://orchestrator-medikeep.herokuapp.com/auth/login'),
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
    );
    Map mapResponse = json.decode(response.body);
    //mapResponse['dataNasc']
    if (response.statusCode == 200) {
      user = UserContext.fromJson(mapResponse);
      prefs.setString("userContext", response.body);
      prefs.setBool("firstTime", false);
    } else {
      user = null;
    }
    return user;
  } on Exception catch (error) {
    throw new Exception(error.toString());
  }
}

Future<void> userSignUp(UserContext user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String body = jsonEncode({
    'name': '${user.name}',
    'surname': '${user.surname}',
    'cpf': '${user.CPF}',
    'sex': '${user.sex}',
    'email': '${user.email}',
    'birthDate': '${DateFormat('yyyy-MM-dd').format(user.birthDate)}',
    'password': '${user.password}'
  });
  print(body);
  final response = await http.post(
    Uri.parse('https://orchestrator-medikeep.herokuapp.com/auth/signup'),
    body: body,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*'
    },
  );

  Map mapResponse = json.decode(body);
  if (response.statusCode == 200) {
    mapResponse["token"] = json.decode(response.body)["token"]; 
    prefs.setString("userContext", jsonEncode(mapResponse).toString());
    prefs.setBool("firstTime", false);
  } else {
    throw new Exception(json.decode(response.body)["errors"]);
  }
}
