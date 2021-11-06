import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:convert/convert.dart';
import 'package:mime/mime.dart';
import 'package:collection/collection.dart';
import 'package:proj_flutter_tcc/services/loginServices.dart' as loginService;

Future<File> getFile({String id = '', String lab}) async {
  try {
    var nameFile = id + '_' + (lab ?? '');
    Directory filesDir = Directory(
        (await getApplicationDocumentsDirectory()).path + '/patient/files/');
    if (!filesDir.existsSync()) filesDir.createSync(recursive: true);
    var file = filesDir.listSync().firstWhereOrNull(
        (file) => basename(file.path).split('.')[0] == nameFile);
    if (file != null) {
      return file;
    }
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
      Map<String, dynamic> fileResponse = jsonDecode(response.body);
      Uint8List bytes = hex.decode(fileResponse['file']);
      final mime = lookupMimeType('', headerBytes: bytes);
      File fileReturn =
          File(filesDir.path + nameFile + '.' + mime.split('/')[1]);
      if (!fileReturn.existsSync()) {
        fileReturn.createSync(recursive: true);
        fileReturn.writeAsBytesSync(bytes);
      }
      return fileReturn;
    }
    if (response.statusCode == 403) {
      var _finalUser = await loginService.login(
          UserContext.fromJson(decoded).CPF,
          prefs?.getString("passwordContext"));
      if (_finalUser != null) return getFile(id: id, lab: lab);
    }
    if (response.statusCode == 406) {
      return null;
    }
    return null;
  } on StateError catch (error) {
    throw new StateError(error.toString());
  } on Exception catch (error) {
    throw new Exception(error.toString());
  }
}
