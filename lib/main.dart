import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/application.dart';
import 'screen/event.dart';

void main() async {
  Application.preferences = await SharedPreferences.getInstance();

  runApp(const Event());
}
