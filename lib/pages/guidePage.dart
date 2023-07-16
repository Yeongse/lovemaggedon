import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import './cameraPage.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({Key? key, required this.sex}) : super(key: key);

  final String sex;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      String sexString = sex == 'male' ? '男性' : '女性';
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
                          'まずは$sexStringの皆さんの登録です',
                          style: const TextStyle(
                              fontFamily: 'Bebas Neue',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                          child: const Text('参加者の登録に進む'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CameraPage(
                                      camera: camera, index: 0, sex: sex)),
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
    });
  }
}
