import 'dart:async';
import 'package:desktop_app/config/environment.dart';
import 'package:desktop_app/config/preferences.dart';
import 'package:desktop_app/utils/api/api_consumer.dart';
import 'package:desktop_app/utils/preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../model/model_api.dart';

class PresensiRepository {
  static ApiConsumer consumer = ApiConsumer(
      apiUrl: !kDebugMode
          ? 'http://api-siapps.gov.id/api'
          : 'https://git.ulm.ac.id/api-siapps/public/api',
      appId: 'PresensiULM',
      apiKey: '605dafe39ee0780e8cf2c829434eea99',
      // apiToken: UtilPreferences.getString(Preferences.accessToken),
      apiTimeout: 20);

  Future<ApiModel> getEvent() async {
    return await consumer
        .limit(20)
        .orderBy({'tanggal': 'DESC'}).execute(url: '/presensi/event');
  }

  /*
   * Refresh token jika acces token expired
   */
  Future refreshToken() async {
    FormData formData = FormData.fromMap({
      "tokenRefresh": UtilPreferences.getString(Preferences.refreshToken),
    });

    final response = await consumer.execute(
        url: '/auth/refresh', formData: formData, method: MethodRequest.PUT);

    if (response.code == CODE.SUCCESS) {
      return response.data['accessToken'];
    } else {
      return null;
    }
  }

  Future auth() async {
    return await consumer.auth(username: '130239244', password: '1q2w3e4r');
  }

  ///Singleton factory
  static final PresensiRepository _instance = PresensiRepository._internal();

  factory PresensiRepository() {
    return _instance;
  }

  PresensiRepository._internal();
}
