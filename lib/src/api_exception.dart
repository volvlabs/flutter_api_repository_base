import 'package:flutter_api_repository_base/src/error_response.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final ErrorResponse? response;

  ApiException(this.statusCode, this.message, this.response);

  @override
  String toString() => 'ApiException: $message';

  String getResponseMessage() {
    if (response == null) {
      return "Error occurred performing request. try again.";
    }
    return response!.message;
  }
}
