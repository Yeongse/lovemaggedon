import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import './cameraPage.dart';
import './allMembersPage.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final int index = ref.watch(memberIndexProvider);
      if (index > ref.watch(memberNumProvider)) {
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
                    '全員の登録が完了したよ！お疲れさま！',
                    style: TextStyle(
                        fontFamily: 'Bebas Neue',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                ElevatedButton(
                    child: const Text('次に進む'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllMembersPage()),
                      );
                    }),
              ],
            )));
      } else {
        return ref.watch(cameraProvider).when(
              data: (camera) {
                return Scaffold(
                    appBar: AppBar(),
                    body: Center(
                        child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: deviceSize.width,
                          height: deviceSize.height * 0.1,
                          child: Text(
                            '$index番目の参加者の登録に移ります(ボタンを押すと画面が変わるよ)',
                            style: const TextStyle(
                                fontFamily: 'Bebas Neue',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                        ElevatedButton(
                            child: const Text('登録に進む'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CameraPage(camera: camera)),
                              );
                            }),
                      ],
                    )));
              },
              loading: () {
                return const CircularProgressIndicator();
              },
              error: (err, stack) => Text('Error: $err'),
            );
      }
    });
  }
}
