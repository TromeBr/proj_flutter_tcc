import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<UserContext> login(String CPF, String password) async {
  try {
    UserContext user;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final responseKey = await http.get(
      Uri.parse('https://orchestrator-medikeep.herokuapp.com/auth/key'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
    );

    if(responseKey.statusCode == 200){
      Map mapResponseKey = json.decode(responseKey.body);
      final publicKey = RSAKeyParser().parse(mapResponseKey['publicKey']) as RSAPublicKey;
      final encrypter = Encrypter(RSA(publicKey: publicKey, encoding: RSAEncoding.PKCS1 ));
      final passwordEncrypt = encrypter.encrypt(password);
      String body = jsonEncode({"cpf": CPF, "password": passwordEncrypt.base64.toString()});
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
        prefs.setString("passwordContext", password);
        prefs.setBool("firstTime", false);
      } else {
        user = null;
      }
    }
    return user;
  } on Exception catch (error) {
    throw new Exception(error.toString());
  }
}

Future<void> userSignUp(UserContext user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final responseKey = await http.get(
    Uri.parse('https://orchestrator-medikeep.herokuapp.com/auth/key'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*'
    },
  );
  if(responseKey.statusCode == 200){
    Map mapResponseKey = json.decode(responseKey.body);
    final publicKey = RSAKeyParser().parse(mapResponseKey['publicKey']) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey, encoding: RSAEncoding.PKCS1 ));
    final passwordEncrypt = encrypter.encrypt(user.password);
    String body = jsonEncode({
      'name': '${user.name}',
      'surname': '${user.surname}',
      'cpf': '${user.CPF}',
      'sex': '${user.sex}',
      'email': '${user.email}',
      'birthDate': '${DateFormat('yyyy-MM-dd').format(user.birthDate)}',
      'password': '${passwordEncrypt.base64.toString()}'
    });
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
      prefs.setString("passwordContext", user.password);
      prefs.setBool("firstTime", false);
    } else {
      throw new Exception(json.decode(response.body)["errors"]);
    }
  }
  else{
    throw new Exception('Falha na obtenção de chave publica');
  }

}
