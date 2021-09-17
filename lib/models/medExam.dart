import 'dart:io';

import 'package:proj_flutter_tcc/models/patient.dart';

class MedExam {
  final int id;
  final String exam;
  File file;
  final Object requestingPhysician;
  final Object reportingPhysician;
  final DateTime date;

  MedExam(
    this.exam,
    this.date, {
      this.id,
    this.file,
    this.requestingPhysician,
    this.reportingPhysician,
  });

  @override
  String toString() {
    return 'Tipo de Exame: $exam, Data do Exame: $date}';
  }
}
