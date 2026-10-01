class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NoInternetException extends ApiException {
  NoInternetException() : super('لا يوجد اتصال بالإنترنت، تأكدي من الشبكة وحاولي مرة أخرى');
}

class ServerException extends ApiException {
  ServerException({int? statusCode})
      : super('حدث خطأ من السيرفر، حاولي مرة أخرى لاحقاً', statusCode: statusCode);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super('انتهت صلاحية الجلسة، الرجاء تسجيل الدخول مرة أخرى');
}