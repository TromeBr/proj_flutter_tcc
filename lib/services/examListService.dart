import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proj_flutter_tcc/models/medExam.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proj_flutter_tcc/services/loginServices.dart' as loginService;

Future<List<MedExam>> getExamesByCpf() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String result = prefs?.getString("userContext");
    Map<String,dynamic> decoded = jsonDecode(result);
    
    final response = await http.get(
        Uri.parse(
            'https://orchestrator-medikeep.herokuapp.com/exams/patient/' + UserContext.fromJson(decoded).CPF),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'Authorization' : 'Bearer ${UserContext.fromJson(decoded).token}'
        });

    List<MedExam> medExams = [];

    if (response.statusCode == 200) {
      List examsResponse = jsonDecode(response.body);
      examsResponse.forEach((exam) {
        medExams.add(new MedExam(exam['exam'], DateTime.parse(exam['date']),
            id: exam['id'],
            fileId: exam['file'],
            lab: exam['lab'],
            requestingPhysician: exam['requestingPhysician'],));
      });
    }
    if(response.statusCode == 403)
    {
      var _finalUser = await loginService.login(UserContext.fromJson(decoded).CPF, prefs?.getString("passwordContext"));
      if(_finalUser != null)
        return getExamesByCpf();
    }
    if (response.statusCode == 406) {
      medExams.clear();
    }
    return medExams;
  } on Exception catch (error) {
    throw new Exception(error.toString());
  }
}
