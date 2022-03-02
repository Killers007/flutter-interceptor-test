import 'package:desktop_app/config/preferences.dart';
import 'package:desktop_app/model/model_api.dart';
import 'package:desktop_app/repository/presensi.dart';
import 'package:desktop_app/utils/api/api_consumer.dart';
import 'package:desktop_app/utils/logger.dart';
import 'package:desktop_app/utils/preferences.dart';
import 'package:flutter/foundation.dart';

class AuthState with ChangeNotifier {
  bool isLogged = false;
  bool isLoading = false;
  bool showPassword = false;
  // UserIntegrasiModel userIntegrasi;
  Map<String, dynamic>? error;

  AuthState() {
    initData();
  }

  initData() async {
    try {
      ///Setup SharedPreferences
      final hasToken = UtilPreferences.containsKey(Preferences.refreshToken);

      if (hasToken!) {
        isLogged = true;
      } else {
        isLogged = false;
      }

      UtilLogger.log('LOGGIN ?', isLogged);

      notifyListeners();
    } catch (e) {
      UtilLogger.log('ADA ERROR CUY', e);
      notifyListeners();
    }
  }

  auth() async {
    final auth = await PresensiRepository().auth();

    if (auth.code == CODE.SUCCESS) {
      UtilPreferences.setToken(
          accessToken: auth.data['accessToken'],
          refreshToken: auth.data['refreshToken']);

      isLogged = true;
      notifyListeners();
    }
  }

  logout() async {
    UtilPreferences.remove(Preferences.accessToken);
    UtilPreferences.remove(Preferences.refreshToken);
    isLogged = false;
    notifyListeners();
  }
}
