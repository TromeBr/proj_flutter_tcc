import 'dart:convert';
import 'dart:io';
import "package:hex/hex.dart";

import 'package:http/http.dart' as http;
import 'package:proj_flutter_tcc/models/medExam.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> insertExam(MedExam exam) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs?.getString("userContext");
    Map<String, dynamic> decoded = jsonDecode(result);

    String body = jsonEncode({
      "exam": '${exam.exam}',
      "date": '${exam.date}',
      //"requestingPhysician": '${exam.requestingPhysician}',
      "patient": '${UserContext.fromJson(decoded).CPF}',
      "file": '${HEX.encode(await exam.file.readAsBytes())}'
    });

    final response = await http.post(
      Uri.parse('https://orchestrator-medikeep.herokuapp.com/exams'),
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'Authorization': 'Bearer ${UserContext.fromJson(decoded).token}'
      },
    );
    Map<String, dynamic> responseAPI = jsonDecode(response.body);
    String resultAPI;
    if (response.statusCode == 200) {
      resultAPI = responseAPI['id'].toString();
    }
    if (response.statusCode == 500) throw new Exception(responseAPI["error"]);

    return resultAPI;
  } on Exception catch (error) {
    throw new Exception(error.toString());
  }
}

Future<bool> deleteExam(String examId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs?.getString("userContext");
    Map<String, dynamic> decoded = jsonDecode(result);

    final response = await http.delete(
      Uri.parse('https://orchestrator-medikeep.herokuapp.com/exams/' + examId),
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
    if (response.statusCode == 500) throw new Exception(responseAPI["error"]);

    return resultAPI;
  } on Exception catch (error) {
    throw new Exception(error.toString());
  }
}
