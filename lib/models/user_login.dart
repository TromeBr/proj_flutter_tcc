
class UserLogin {
  final String loginUser;
  final String loginPassword;
  String loginEmail;
  String loginCPF;


  UserLogin(this.loginUser, this.loginPassword, {this.loginEmail, this.loginCPF});


  @override
  String toString() {
    return 'UserLogin{User: $loginUser, Password: $loginPassword}';
  }
}
