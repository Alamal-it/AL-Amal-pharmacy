// TODO: هذا تخزين مؤقت بالذاكرة. لاحقًا اربطيه بـ API حقيقي (OTP على الجوال مثلاً)
// وبتخزين دائم (shared_preferences) عشان الجلسة ما تروح لما يقفل التطبيق.
class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  bool isLoggedIn = false;
  String? userName;
  String? userPhone;

  void loginQuick({required String name, required String phone}) {
    isLoggedIn = true;
    userName = name;
    userPhone = phone;
  }

  void logout() {
    isLoggedIn = false;
    userName = null;
    userPhone = null;
  }
}