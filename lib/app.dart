// ignore_for_file: must_be_immutable

import 'package:desktop_app/screen/event.dart';
import 'package:desktop_app/screen/login.dart';
import 'package:desktop_app/states/state.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.light;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => EventState()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: MaterialApp(
          title: 'App',
          themeMode: themeMode,
          home: WillPopScope(
            child: Consumer<AuthState>(
              builder: (context, percentDone, child) {
                return context.watch<AuthState>().isLogged
                    ? const EventScreen()
                    : const LoginScreen();
              },
            ),
            onWillPop: onWillPop,
          ),
        ),
      ),
    );
  }

  DateTime? currentBackPressTime;

  /// Function double tap back when close from apps
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Tekan lagi untuk keluar aplikasi');
      return Future.value(false);
    }
    return Future.value(true);
  }
}
