import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

import './members.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key, required this.index, required this.sex})
      : super(key: key);

  final int index;
  final String sex;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final members = Provider.of<Members>(context);

    String sexString = sex == 'male' ? '男性' : '女性';

    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text('まずは$sexStringの$index番目の人の登録です。')),
            Container(alignment: Alignment.center, child: Text('自撮りを登録してください。'))
          ],
        )));
  }
}
