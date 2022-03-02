class Environment {
  // ignore: constant_identifier_names
  static const bool DEBUG = true;

  ///Singleton factory
  static final Environment _instance = Environment._internal();

  factory Environment() {
    return _instance;
  }

  Environment._internal();
}
