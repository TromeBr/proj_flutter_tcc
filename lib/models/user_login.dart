
class UserContext {
  final String name;
  String password;
  String surname;
  String email;
  DateTime birthDate;
  String sex;
  String CPF;
  String statusCode;


  UserContext(this.CPF, {this.password, this.surname, this.name, this.email, this.birthDate, this.sex});

  UserContext.fromJson(Map<String, dynamic> json)
      : name = json['nome'],
        email = json['email'],
        surname = json['sobrenome'],
        CPF = json['cpf'],
        birthDate = json['birthDate'],
        sex = json['sexo'],
        statusCode = json['statusCode'];



  @override
  String toString() {
    return 'UserLogin{User: $name, Password: $password}';
  }
}
