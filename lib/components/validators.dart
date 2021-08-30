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

bool validatePassword(String password) {
  Pattern pattern = r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,20}$";
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(password))
    return true;
  else
    return false;
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