import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cameraPage.dart';
import './members.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({Key? key, required this.sex}) : super(key: key);

  final String sex;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final members = Provider.of<Members>(context);

    String sexString = sex == 'male' ? '男性' : '女性';
    int index = sex == 'male' ? members.maleIndex : members.femaleIndex;

    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                'まずは$sexStringの皆さんの登録です',
                style: const TextStyle(
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
                    MaterialPageRoute(
                        builder: (context) =>
                            CameraPage(index: index, sex: sex)),
                  );
                }),
          ],
        )));
  }
}
