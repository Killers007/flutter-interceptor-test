class Environment {
  // ignore: constant_identifier_names
  static const bool DEBUG = true;

  static String apiUrl = DEBUG
      ? 'http://api-siapps.gov.id/api'
      : 'https://git.ulm.ac.id/api-siapps/public/api';
  static String apiKey = '605dafe39ee0780e8cf2c829434eea99';
  static String apiId = 'PresensiULM';
  static int apiTimeout = 20;

  ///Singleton factory
  static final Environment _instance = Environment._internal();

  factory Environment() {
    return _instance;
  }

  Environment._internal();
}
