import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient instance = ApiClient._internal();

  // TODO: اربطي هذي الدالة بـ Firebase عشان تجيب التوكن الحقيقي، مثال:
  // Future<String?> Function() getToken = () async =>
  //     await FirebaseAuth.instance.currentUser?.getIdToken();
  Future<String?> Function() getToken = () async => null;

  Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
    if (response.statusCode >= 500) {
      throw ServerException(statusCode: response.statusCode);
    }
    if (response.statusCode >= 400) {
      final body = _tryDecode(response.body);
      final message = (body is Map && body['message'] != null)
          ? body['message'].toString()
          : 'حدث خطأ، حاولي مرة أخرى';
      throw ApiException(message, statusCode: response.statusCode);
    }
    return _tryDecode(response.body);
  }

  dynamic _tryDecode(String body) {
    if (body.isEmpty) return null;
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  Future<dynamic> get(String url, {bool withAuth = true}) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: await _headers(withAuth: withAuth))
          .timeout(ApiConfig.timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('حدث خطأ غير متوقع، حاولي مرة أخرى');
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> body,
      {bool withAuth = true}) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: await _headers(withAuth: withAuth),
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('حدث خطأ غير متوقع، حاولي مرة أخرى');
    }
  }

  Future<dynamic> put(String url, Map<String, dynamic> body,
      {bool withAuth = true}) async {
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: await _headers(withAuth: withAuth),
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('حدث خطأ غير متوقع، حاولي مرة أخرى');
    }
  }

  Future<dynamic> delete(String url, {bool withAuth = true}) async {
    try {
      final response = await http
          .delete(Uri.parse(url), headers: await _headers(withAuth: withAuth))
          .timeout(ApiConfig.timeout);
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('حدث خطأ غير متوقع، حاولي مرة أخرى');
    }
  }
}