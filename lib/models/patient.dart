import 'package:proj_flutter_tcc/models/person.dart';

class Patient {
  final Person person;

  Patient(
    this.person,
  );

  @override
  String toString() {
    return 'Paciente{valor: $person}';
  }
}
