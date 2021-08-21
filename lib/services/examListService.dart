import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proj_flutter_tcc/models/medExam.dart';
import 'package:proj_flutter_tcc/models/user_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<MedExam>> getExamesByCpf() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs?.getString("userContext");
    Map<String,dynamic> decoded = jsonDecode(result);
    print(UserContext.fromJson(decoded).token);

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
            requestingPhysician: exam['requestingPhysician'], reportingPhysician: exam['reportingPhysician']));
      });
    }
    if (response.statusCode == 406) {
      medExams.clear();
    }
    return medExams;
  } on Exception catch (error) {
    throw new Exception(error.toString());
  }
}
