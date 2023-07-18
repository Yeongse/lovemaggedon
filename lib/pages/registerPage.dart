import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: deviceSize.width,
              height: deviceSize.height * 0.1,
              child: const Text(
                'Coming Soon...',
                style: TextStyle(
                    fontFamily: 'Bebas Neue',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
          ],
        )));
  }
}
