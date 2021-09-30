import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convert/convert.dart';
import 'package:proj_flutter_tcc/models/constants.dart' as Constants;

Future<File> getFile({String id = '', String lab}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs?.getString("userContext");
    Map<String, dynamic> decoded = jsonDecode(result);
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer ${UserContext.fromJson(decoded).token}'
    };

    String url =
        'https://orchestrator-medikeep.herokuapp.com/exams/' + id.toString();

    if (lab != null) url += '?lab=' + lab;

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      Directory filesDir = await getApplicationDocumentsDirectory();
      Map<String, dynamic> fileResponse = jsonDecode(response.body);
      Uint8List bytes = hex.decode(fileResponse['file']);
      File fileReturn = File(filesDir.path + '/patient/files/' + fileResponse['name']);
      if (!fileReturn.existsSync()) {
        fileReturn.createSync(recursive: true);
        fileReturn.writeAsBytesSync(bytes);
      }
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
