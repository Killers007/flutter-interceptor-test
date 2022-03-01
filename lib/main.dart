import 'package:desktop_app/model/model_api.dart';
import 'package:desktop_app/api/repository.dart';
import 'package:desktop_app/utils/api/consumer.dart';
import 'package:desktop_app/utils/logger.dart';
import 'package:desktop_app/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/application.dart';
import 'config/preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  void initData() async {
    Application.preferences = await SharedPreferences.getInstance();

    // final auth =
    //     await Consumer().auth(username: '130239244', password: '1q2w3e4r');

    // if (auth.code == CODE.SUCCESS) {
    //   UtilPreferences.setToken(
    //       accessToken: auth.data['accessToken'],
    //       refreshToken: auth.data['refreshToken']);
    // }

    final data = await PresensiRepository().getPengaturanPresensi();
    UtilLogger.log('DATA', data.toJson());
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'You have pushed the button this many tismes:',
            ),
          ],
        ),
      ),
    );
  }
}
