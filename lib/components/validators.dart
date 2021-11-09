bool validateEmail(String email) {
  Pattern pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(email) || email == null)
    return true;
  else
    return false;
}

List<String> validatePassword(String password) {
  List<String> failedCriteria = [];
  RegExp lowerCaseCriteria = new RegExp(r"^(?=.*[a-z]).+$");
  RegExp upperCaseCriteria = new RegExp(r"^(?=.*[A-Z]).+$");
  RegExp numberCriteria = new RegExp(r"^(?=.*\d).+$");

  if (password.length < 8 || password.length > 20)
    failedCriteria.add("Senha deve conter entre 8 e 20 caracteres");
  if (!lowerCaseCriteria.hasMatch(password))
    failedCriteria.add("Senha deve conter pelo menos uma letra minúscula");
  if (!upperCaseCriteria.hasMatch(password))
    failedCriteria.add("Senha deve conter pelo menos uma letra maiúscula");
  if (!numberCriteria.hasMatch(password))
    failedCriteria.add("Senha deve conter pelo menos um número");
  return failedCriteria;
}

bool validateCPF(String cpf) {
  int sum = 0;
  int rest = 0;

  if (cpf.length != 11 || RegExp(r'^(.)\1+$').hasMatch(cpf)) return true;

  for (int i=1; i<=9; i++)
  sum = sum + int.parse(cpf.substring(i-1, i)) * (11 - i);
  rest = (sum * 10) % 11;

  if ((rest == 10) || (rest == 11))  rest = 0;
  if (rest != int.parse(cpf.substring(9, 10)) ) return true;

  sum = 0;
  for (int i = 1; i <= 10; i++)
  sum = sum + int.parse(cpf.substring(i-1, i)) * (12 - i);
  rest = (sum * 10) % 11;

  if ((rest == 10) || (rest == 11))  rest = 0;
  if (rest != int.parse(cpf.substring(10, 11) ) ) return true;

  return false;
}