
class UserLogin {
  final String loginUser;
  final String loginPassword;

  UserLogin(this.loginUser, this.loginPassword);

  @override
  String toString() {
    return 'UserLogin{User: $loginUser, Password: $loginPassword}';
  }
}
