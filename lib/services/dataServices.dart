import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proj_flutter_tcc/services/loginServices.dart' as loginService;

Future<bool> userUpdate(UserContext user) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs?.getString("userContext");
    String passwordDefault = prefs?.getString("passwordContext");
    Map<String, dynamic> decoded = jsonDecode(result);
    Encrypted passwordUpdate;

    final responseKey = await http.get(
      Uri.parse('https://orchestrator-medikeep.herokuapp.com/auth/key'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
    );
    if(responseKey.statusCode == 200 || user.password.isEmpty) {

        Map mapResponseKey = json.decode(responseKey.body);
        final publicKey = RSAKeyParser().parse(
            mapResponseKey['publicKey']) as RSAPublicKey;
        final encrypter = Encrypter(
            RSA(publicKey: publicKey, encoding: RSAEncoding.PKCS1));
        final passwordEncrypt = encrypter.encrypt(user.password.isNotEmpty ? user.password: passwordDefault);
        passwordUpdate = passwordEncrypt;

      String body = jsonEncode({
        'name': '${user.name}',
        'surname': '${user.surname}',
        'cpf': '${user.CPF}',
        'sex': '${user.sex}',
        'email': '${user.email}',
        'birthDate': '${DateFormat('yyyy-MM-dd').format(user.birthDate)}',
        'password': '${passwordUpdate.base64.toString()}'
      });
      final response = await http.put(
        Uri.parse('https://orchestrator-medikeep.herokuapp.com/auth/update'),
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'Authorization': 'Bearer ${UserContext.fromJson(decoded).token}'
        },
      );


      if (response.statusCode == 200) {
        Map mapResponse = json.decode(response.body);
        prefs.remove('userContext');
        prefs.setString("userContext", jsonEncode(mapResponse).toString());
        if(user.password.isNotEmpty){
          prefs.remove('passwordContext');
          prefs.setString("passwordContext", user.password);
        }


        return true;
      }
      if(response.statusCode == 403)
      {
        var _finalUser = await loginService.login(UserContext.fromJson(decoded).CPF, prefs?.getString("passwordContext"));
        if(_finalUser != null)
          return userUpdate(user);
      }
      return false;
    }
    else{
      return false;
    }
  } on Exception catch (error) {
    throw new Exception(error.toString());
  }
}

Future<bool> deleteUser() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs?.getString("userContext");
    Map<String, dynamic> decoded = jsonDecode(result);

    final response = await http.delete(
      Uri.parse(
          'https://orchestrator-medikeep.herokuapp.com/auth/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Authorization': 'Bearer ${UserContext.fromJson(decoded).token}'
      },
    );
    bool resultAPI = false;
    Map<String, dynamic> responseAPI = jsonDecode(response.body);
    if (response.statusCode == 200) {
      resultAPI = true;
    }
    if(response.statusCode == 403)
    {
      var _finalUser = await loginService.login(UserContext.fromJson(decoded).CPF, prefs?.getString("passwordContext"));
      if(_finalUser != null)
        return deleteUser();
    }
    if(response.statusCode == 500)
      throw new Exception(responseAPI["error"]);

    return resultAPI;
  } on Exception catch (error) {
    throw new Exception(error.toString());
  }
}

