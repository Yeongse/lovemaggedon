import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './members.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final members = Provider.of<Members>(context);

    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                'Coming Soon...',
                style: TextStyle(
                    fontFamily: 'Bebas Neue',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              width: deviceSize.width,
              height: deviceSize.height * 0.1,
            ),
          ],
        )));
  }
}
