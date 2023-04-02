import 'package:flutter/material.dart';
import './registerPage.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({Key? key, required this.sex}) : super(key: key);

  final String sex;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    String sexString = sex == 'male' ? '男性' : '女性';

    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                'まずは$sexStringの皆さんの登録です',
                style: TextStyle(
                    fontFamily: 'Bebas Neue',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              width: deviceSize.width,
              height: deviceSize.height * 0.1,
            ),
            ElevatedButton(
                child: const Text('参加者の登録に進む'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                }),
          ],
        )));
  }
}
