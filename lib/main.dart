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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
