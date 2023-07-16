import 'package:flutter/material.dart';
import './settingPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

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
              child: Text('飲み会で気になる男女をマッチング⁈', style: TextStyle()),
              width: deviceSize.width,
              height: deviceSize.height * 0.05,
              margin: EdgeInsets.only(top: 20),
            ),
            Container(
              alignment: Alignment.center,
              width: deviceSize.width,
              height: deviceSize.height * 0.1,
              child: const Text(
                'ラブマゲドン!!',
                style: TextStyle(
                    fontFamily: 'Bebas Neue',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            ElevatedButton(
                child: const Text('マッチングを始める'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                }),
          ],
        )));
  }
}
