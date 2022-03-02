import 'package:desktop_app/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Application.preferences = await SharedPreferences.getInstance();

  runApp(App());
}
