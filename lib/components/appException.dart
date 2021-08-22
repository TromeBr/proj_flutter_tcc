
enum Field {
  Name,
  Surname,
  Email,
  CPF,
  Date,
  Sex,
  Password
}

int UserConsist(List<dynamic> errors) {
  int field;

  if (errors.contains('Name not informed'))
    field = Field.Name.index;
  else if (errors.contains('Surname not informed'))
    field = Field.Surname.index;
  else if (errors.contains('Invalid e-mail') || errors.contains('Email not informed'))
    field = Field.Email.index;
  else if (errors.contains('CPF not informed') || errors.contains('Invalid CPF'))
    field = Field.CPF.index;
  else if (errors.contains('Birth date not informed') || errors.contains('Invalid birth date'))
    field = Field.Date.index;
  else if (errors.contains('Sex not informed') || errors.contains('Invalid sex'))
    field = Field.Sex.index;
  else if (errors.contains('Password does not meet safety criteria'))
    field = Field.Password.index;
  else{
    field = -1;
  }

  return field;
}


