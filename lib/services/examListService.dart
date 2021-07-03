import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:proj_flutter_tcc/models/medExam.dart';

Future<List<MedExam>> getExamesByCpf(String cpf) async {
  try {
    final response = await http.get(
      Uri.parse('https://orchestrator-medikeep.herokuapp.com/exams/patient/' + cpf),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*'
    });
    log(jsonEncode(response));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  } on Exception catch (error) {
    log(jsonEncode(error));
  }
}
