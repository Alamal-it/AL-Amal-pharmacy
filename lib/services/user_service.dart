class UserService {
  UserService._internal();
  static final UserService instance = UserService._internal();

  bool isLoggedIn = false;
  String name = '';
  String phone = '';

  void loginAsGuestUser({required String name, required String phone}) {
    this.name = name;
    this.phone = phone;
    isLoggedIn = true;
  }
}