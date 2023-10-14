import 'package:dio/dio.dart';

abstract class ApiClient {
  Future<Response> get(String endpoint,
      {Map<String, dynamic>? urlParams, Map<String, dynamic>? query});
  Future<Response> post(String endpoint, dynamic data,
      {Map<String, dynamic>? urlParams,
      Map<String, dynamic>? query,
      bool isMultipart = false});
  Future<Response> put(String endpoint, dynamic data,
      {Map<String, dynamic>? urlParams,
      Map<String, dynamic>? query,
      bool isMultipart = false});
  Future<Response> delete(String endpoint,
      {Map<String, dynamic>? urlParams, Map<String, dynamic>? query});
  void addInterceptor(InterceptorsWrapper interceptors);
}
