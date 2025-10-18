import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioClient {
  final Dio _dio;

  DioClient._internal(this._dio);

  @visibleForTesting
  DioClient.from(this._dio);
  factory DioClient.create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://petstore3.swagger.io/api/v3',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return DioClient._internal(dio);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: query, options: options);
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: query,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return _dio.put(path, data: data, queryParameters: query, options: options);
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: query,
      options: options,
    );
  }
}
