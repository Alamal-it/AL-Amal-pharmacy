import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  AuthService._internal();

  static final AuthService instance = AuthService._internal();

  // ============================================================
  // Google OAuth
  // ============================================================

  static const String googleServerClientId =
      '560062857783-v7jh7ra995cihidh8u30nfntl747grr2.apps.googleusercontent.com';

  // ============================================================
  // Backend
  // ============================================================

  // مؤقت إلى أن يعطينا مسؤول الباكند الرابط الحقيقي.
  static const String backendGoogleLoginUrl =
      'https://YOUR-BACKEND-URL/api/auth/google';

  // ============================================================
  // بيانات المستخدم الحالية
  // ============================================================

  bool isLoggedIn = false;

  String? userName;
  String? userPhone;
  String? userEmail;

  // التوكن الذي يرجعه الباكند بعد نجاح تسجيل الدخول.
  String? accessToken;

  // Google ID Token - يستخدم لإرساله للباكند.
  String? googleIdToken;

  // ============================================================
  // Google Sign-In
  // ============================================================

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _googleInitialized = false;

  /// تهيئة Google Sign-In.
  ///
  /// يجب استدعاء هذه الدالة مرة واحدة قبل تسجيل الدخول.
  Future<void> initializeGoogle() async {
    if (_googleInitialized) {
      return;
    }

    await _googleSignIn.initialize(
      serverClientId: googleServerClientId,
    );

    _googleInitialized = true;
  }

  // ============================================================
  // تسجيل الدخول بواسطة Google
  // ============================================================

  Future<GoogleLoginResult> loginWithGoogle() async {
    try {
      // نتأكد أن Google تم تهيئته.
      await initializeGoogle();

      // تسجيل الدخول التفاعلي.
      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      // الحصول على بيانات المصادقة.
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        return GoogleLoginResult.failure(
          'تعذر الحصول على Google ID Token.',
        );
      }

      // نخزن بيانات Google مؤقتًا.
      googleIdToken = idToken;

      // ========================================================
      // إرسال Google ID Token إلى الـ Backend
      // ========================================================

      final response = await http.post(
        Uri.parse(backendGoogleLoginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'idToken': idToken,
        }),
      );

      // ========================================================
      // نجاح الطلب
      // ========================================================

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        final dynamic decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          return GoogleLoginResult.failure(
            'استجابة الباكند غير صحيحة.',
          );
        }

        final dynamic userData = decoded['user'];

        // التوكن الذي يرجعه الباكند.
        final String? backendToken =
            decoded['token']?.toString() ??
                decoded['accessToken']?.toString();

        accessToken = backendToken;

        // ======================================================
        // بيانات المستخدم
        // ======================================================

        if (userData is Map<String, dynamic>) {
          userName =
              userData['name']?.toString() ??
                  userData['fullName']?.toString() ??
                  googleUser.displayName;

          userEmail =
              userData['email']?.toString() ??
                  googleUser.email;

          userPhone =
              userData['phone']?.toString();
        } else {
          userName = googleUser.displayName;
          userEmail = googleUser.email;
        }

        isLoggedIn = true;

        return GoogleLoginResult.success(
          name: userName,
          email: userEmail,
          phone: userPhone,
          accessToken: accessToken,
        );
      }

      // ========================================================
      // خطأ من الباكند
      // ========================================================

      String message = 'فشل تسجيل الدخول بواسطة Google.';

      try {
        final dynamic errorBody = jsonDecode(response.body);

        if (errorBody is Map<String, dynamic>) {
          message =
              errorBody['message']?.toString() ??
                  errorBody['error']?.toString() ??
                  message;
        }
      } catch (_) {
        // تجاهل الخطأ إذا كانت استجابة الباكند ليست JSON.
      }

      return GoogleLoginResult.failure(message);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return GoogleLoginResult.failure(
          'تم إلغاء تسجيل الدخول.',
        );
      }

      return GoogleLoginResult.failure(
        e.description ??
            'حدث خطأ أثناء تسجيل الدخول بواسطة Google.',
      );
    } catch (e) {
      return GoogleLoginResult.failure(
        'حدث خطأ أثناء الاتصال بالخدمة.',
      );
    }
  }

  // ============================================================
  // تسجيل الدخول السريع القديم
  // ============================================================

  void loginQuick({
    required String name,
    required String phone,
  }) {
    isLoggedIn = true;

    userName = name;
    userPhone = phone;
  }

  // ============================================================
  // تسجيل الخروج
  // ============================================================

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // حتى لو فشل Google signOut، نكمل تنظيف الجلسة المحلية.
    }

    isLoggedIn = false;

    userName = null;
    userPhone = null;
    userEmail = null;

    accessToken = null;
    googleIdToken = null;
  }
}

// ============================================================
// نتيجة تسجيل الدخول بواسطة Google
// ============================================================

class GoogleLoginResult {
  final bool success;

  final String? message;

  final String? name;

  final String? email;

  final String? phone;

  final String? accessToken;

  const GoogleLoginResult._({
    required this.success,
    this.message,
    this.name,
    this.email,
    this.phone,
    this.accessToken,
  });

  factory GoogleLoginResult.success({
    String? name,
    String? email,
    String? phone,
    String? accessToken,
  }) {
    return GoogleLoginResult._(
      success: true,
      name: name,
      email: email,
      phone: phone,
      accessToken: accessToken,
    );
  }

  factory GoogleLoginResult.failure(String message) {
    return GoogleLoginResult._(
      success: false,
      message: message,
    );
  }
}