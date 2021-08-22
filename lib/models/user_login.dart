
class UserContext {
  String name;
  String password;
  String surname;
  String email;
  DateTime birthDate;
  String sex;
  String CPF;
  int message;
  String token;


  UserContext(this.CPF, {this.password, this.surname, this.name, this.email, this.birthDate, this.sex});


  UserContext.fromJson(Map<String, dynamic> json)
      : name = json['nome'],
        email = json['email'],
        surname = json['sobrenome'],
        CPF = json['cpf'],
        birthDate = json['birthDate'],
        sex = json['sexo'],
        token = json['token'],
        message = json['message'];

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email']  = this.email;
    data['surname'] = this.surname;
    data['CPF'] = this.CPF;
    data['birthDate'] = this.birthDate;
    data['sex'] = this.sex;
    data['token'] = this.token;
    data['message'] = this.message;
    return data;
  }

  @override
  String toString() {
    return 'UserLogin{User: $name, Password: $password}';
  }
}
