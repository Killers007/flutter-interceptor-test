// ignore_for_file: avoid_print

import 'package:desktop_app/repository/presensi.dart';
import 'package:desktop_app/utils/api/api_consumer.dart';
import 'package:desktop_app/utils/preferences.dart';
import 'package:dio/dio.dart';

class CustomInterceptors extends Interceptor {
  final Dio dio;
  CustomInterceptors(this.dio);

  Future _refreshMethod(
      Response response, ResponseInterceptorHandler handler) async {
    var token = await PresensiRepository().refreshToken();
    String newAccessToken = token;

    // Break jika refresh token expired
    if (token == null) {
      return super.onResponse(response, handler);
    }

    // Set new access token
    UtilPreferences.setToken(
      accessToken: newAccessToken,
    );

    RequestOptions options = response.requestOptions;

    options.headers.addAll({'X-Token': newAccessToken});

    final data = await dio.request(options.path,
        options: Options(headers: options.headers));
    return super.onResponse(data, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
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
