import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proj_flutter_tcc/components/appException.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<UserContext> login(String CPF, String password) async {
  try {
    UserContext user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String body = jsonEncode({ "cpf": CPF, "password": password });
    final response = await http.post(
        Uri.parse(
            'https://auth-medikeep.herokuapp.com/auth/login'),
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
      prefs.setString("userCPF", mapResponse["cpf"]);
    }
    else{
      user = null;
    }
    return user;

  } on Exception catch (error) {
    throw new Exception(error.toString());
  }
}

Future<UserContext> userSignUp(UserContext user) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserContext userReturn;
    String body = jsonEncode({'name': '${user.name}', 'surname': '${user.surname}','cpf': '${user.CPF}', 'sex': '${user.sex}',
  'email': '${user.email}', 'birthDate': '${user.birthDate}', 'password': '${user.password}'});
    print(body);
    final response = await http.post(
      Uri.parse(
          'http://auth-medikeep.herokuapp.com/auth/signup'),
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },

    );

    Map mapResponse = json.decode(body);
    if (response.statusCode == 200) {
      userReturn = user;
      prefs.setString("userCPF", mapResponse["cpf"]);
    }
    else{
      userReturn = null;
    }
    return userReturn;
  } on Exception catch (error) {
    throw Exception('Erro: $error');
  }
}