
class UserContext {
  String name;
  String password;
  String surname;
  String email;
  DateTime birthDate;
  String sex;
  String CPF;

  String token;


  UserContext(this.CPF, {this.password, this.surname, this.name, this.email, this.birthDate, this.sex});


  UserContext.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        surname = json['surname'],
        CPF = json['cpf'],
        birthDate = json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
        sex = json['sex'],
        token = json['token'];

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email']  = this.email;
    data['surname'] = this.surname;
    data['CPF'] = this.CPF;
    data['birthDate'] = this.birthDate;
    data['sex'] = this.sex;
    data['token'] = this.token;
    return data;
  }

  @override
  String toString() {
    return 'UserLogin{User: $name, Password: $password}';
  }
}
