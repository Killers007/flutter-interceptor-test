import 'package:desktop_app/states/state.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // showDebugBtn(context, btnColor: Colors.blue);
    AuthState authState = Provider.of<AuthState>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AUTH'),
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              authState.auth();
            },
            child: const Text('LOGIN ME')),
      ),
    );
  }
}
