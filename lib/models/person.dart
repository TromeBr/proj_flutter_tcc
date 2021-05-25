class Person {
  final String name;
  final int age;
  final String document;
  final DateTime birthday;
  final String city;
  final String state;
  final String country;

  Person(
      this.name,
      this.age,
      this.document,
      this.birthday,
      this.city,
      this.state,
      this.country,
      );

  @override
  String toString() {
    return 'Pessoa{Nome: $name, Idade: $age, Documento: $document, Nascimento: $birthday}';
  }
}
