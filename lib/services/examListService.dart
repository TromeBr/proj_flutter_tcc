import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proj_flutter_tcc/models/medExam.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<MedExam>> getExamesByCpf() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cpf = (prefs.getString("cpf") ?? "");
    final response = await http.get(
        Uri.parse(
            'https://orchestrator-medikeep.herokuapp.com/exams/patient/' + cpf),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*'
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
