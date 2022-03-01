import 'package:shared_preferences/shared_preferences.dart';

class Application {
  static SharedPreferences? preferences;

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
