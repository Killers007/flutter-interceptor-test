/*
 * NON REACTIVE DATA
 */
class GlobalStates {
  ///Singleton factory
  static final GlobalStates _instance = GlobalStates._internal();

  factory GlobalStates() {
    return _instance;
  }

  GlobalStates._internal();
}
