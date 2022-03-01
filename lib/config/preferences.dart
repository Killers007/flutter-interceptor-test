class Preferences {
  static String accessToken = 'accessToken';
  static String refreshToken = 'refreshToken';

  ///Singleton factory
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();
}
