// ignore_for_file: avoid_print

import 'package:desktop_app/utils/api/consumer.dart';
import 'package:desktop_app/utils/logger.dart';
import 'package:desktop_app/utils/preferences.dart';
import 'package:dio/dio.dart';

class CustomInterceptors extends Interceptor {
  final Dio dio;
  CustomInterceptors(this.dio);

  void _refreshMethod(
      Response response, ResponseInterceptorHandler handler) async {
    dio.interceptors.requestLock.lock();
    dio.interceptors.responseLock.lock();

    var token = await Consumer().refreshToken();
    String newAccessToken = token;

    // Break jika refresh token expired
    if (token == null) {
      return super.onResponse(response, handler);
    }

    UtilPreferences.setToken(
      accessToken: newAccessToken,
    );

    RequestOptions options = response.requestOptions;

    options.headers.addAll({'X-Token': newAccessToken});

    dio.interceptors.requestLock.unlock();
    dio.interceptors.responseLock.unlock();

    UtilLogger.log('DIO OPTIONS', options.headers);
    return super.onRequest(options, RequestInterceptorHandler());
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    int statusCode = response.data['code'];

    if (statusCode == 401) {
      return _refreshMethod(response, handler);
    }

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}
