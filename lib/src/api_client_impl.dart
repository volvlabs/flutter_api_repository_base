import 'dart:io';

import 'package:dio/dio.dart';
import 'package:env_variables/env_variables.dart';
import 'package:flutter_api_repository_base/src/api_client.dart';
import 'package:flutter_api_repository_base/src/api_exception.dart';
import 'package:flutter_api_repository_base/src/error_response.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ApiClient)
class ApiClientImpl implements ApiClient {
  final String basePath = EnvVariables.fromEnvironment("BASE_URL");
  final Dio _dio;
  Map<String, dynamic> _headers = {'content-type': 'application/json'};

  ApiClientImpl() : _dio = Dio();

  void addHeader(String key, dynamic value) {
    _headers[key] = value;
  }

  @override
  void addInterceptor(InterceptorsWrapper interceptors) {
    _dio.interceptors.add(interceptors);
  }

  Future<Response> _doRequest(String method, String endpoint,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? urlParams,
      Map<String, dynamic>? query,
      bool isMultipart = false}) async {
    final updatedEndpoint = replaceUrlParams(endpoint, urlParams: urlParams);
    try {
      dynamic formData = data;
      if (data != null && isMultipart) {
        formData = FormData.fromMap(data);
      }
      final response = await _dio.request('$basePath$updatedEndpoint',
          data: formData,
          queryParameters: query,
          options: _getRequestOptions(method));
      return response;
    } catch (e) {
      if (e is DioException) {
        var statusCode = 500;
        ErrorResponse? errorResponse;
        if (e.error is SocketException) {
          errorResponse =
              ErrorResponse(message: 'Could not connect to server. Try again');
        } else if (e.error is HttpException) {
          errorResponse =
              ErrorResponse(message: 'Could not connect to server. Try again');
        } else {
          if (e.response != null) {
            statusCode = e.response!.statusCode ?? statusCode;
            errorResponse = ErrorResponse.fromJson(e.response!.data);
          } else {
            errorResponse = ErrorResponse(message: 'Crash error here!!!');
          }
        }
        return Future.error(ApiException(
            statusCode, 'Error making $method request: $e', errorResponse));
      } else {
        return Future.error(e);
      }
    }
  }

  @override
  Future<Response> get(String endpoint,
      {Map<String, dynamic>? urlParams, Map<String, dynamic>? query}) async {
    return _doRequest('GET', endpoint, urlParams: urlParams, query: query);
  }

  @override
  Future<Response> post(String endpoint, dynamic data,
      {Map<String, dynamic>? urlParams,
      Map<String, dynamic>? query,
      bool isMultipart = false}) async {
    return _doRequest('POST', endpoint,
        data: data,
        urlParams: urlParams,
        query: query,
        isMultipart: isMultipart);
  }

  @override
  Future<Response> put(String endpoint, dynamic data,
      {Map<String, dynamic>? urlParams,
      Map<String, dynamic>? query,
      bool isMultipart = false}) async {
    return _doRequest('PUT', endpoint,
        data: data,
        urlParams: urlParams,
        query: query,
        isMultipart: isMultipart);
  }

  @override
  Future<Response> delete(String endpoint,
      {Map<String, dynamic>? urlParams, Map<String, dynamic>? query}) async {
    return _doRequest('DELETE', endpoint,
        data: null, urlParams: urlParams, query: query);
  }

  Options _getRequestOptions(String method) {
    return Options(method: method, headers: _headers);
  }

  String replaceUrlParams(String endpoint, {Map<String, dynamic>? urlParams}) {
    if (urlParams != null) {
      for (var param in urlParams.entries) {
        endpoint = endpoint.replaceFirst('{${param.key}}', param.value);
      }
    }

    return endpoint;
  }
}
