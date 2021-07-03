import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proj_flutter_tcc/models/medExam.dart';

Future<List<MedExam>> getExamesByCpf (String cpf) async {
  final response = await http.get(
    Uri.parse('http://localhost:3000/exams/patient/' + cpf
  ));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }
  return null;
}
