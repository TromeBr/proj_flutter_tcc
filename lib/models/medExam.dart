import 'dart:io';


class MedExam {
  String id;
  final String lab;
  final String exam;
  String fileId;
  File file;
  final Map requestingPhysician;
  final Map reportingPhysician;
  final DateTime date;

  MedExam(
    this.exam,
    this.date, {
    this.id,
    this.lab,
    this.fileId,
    this.file,
    this.requestingPhysician,
    this.reportingPhysician,
  });

  @override
  String toString() {
    return 'Tipo de Exame: $exam, Data do Exame: $date}';
  }
}
