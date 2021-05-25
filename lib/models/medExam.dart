import 'package:proj_flutter_tcc/models/patient.dart';

class MedExam {
  final Patient medExamPatient;
  final String medExamType;
  final DateTime medExamDate;

  MedExam(
      this.medExamPatient,
      this.medExamType,
      this.medExamDate,
      );

  @override
  String toString() {
    return 'Exame{Paciente: $medExamPatient, Tipo de Exame: $medExamType, Data do Exame: $medExamDate}';
  }
}
