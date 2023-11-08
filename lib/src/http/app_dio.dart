import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

mixin AppDio {
  static Future<Dio> getConnection() async {
    Dio dio = Dio();

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        onRequest(options);
        handler.next(options);
      },
      onResponse: onResponse,
      onError: (error, handler) async {
        onError(dio, error, handler);
      },
    ));

    return dio;
  }

  static void onRequest(RequestOptions options) {
    options.headers["Accept"] = "application/json";
    options.headers["Content-Type"] = "application/json";

    debugPrint('-----------| Request log |-----------');
    debugPrint('${options.uri}');
  }

  static void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    debugPrint('-----------| Response log |-----------');
    debugPrint(response.data);
    handler.next(response);
  }

  static void onError(
      Dio dio, DioError error, ErrorInterceptorHandler handler) {
    debugPrint('-----------| Error log |-----------');
    debugPrint('${error.response}');
    handler.next(error);
  }
}
