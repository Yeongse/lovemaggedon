import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

import './members.dart';

Future<CameraController> getCamera() async {
  final cameras = await availableCameras();
  final frontCamera = cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.front,
  );
  // print(cameras);
  print(frontCamera);
  final cameraController = CameraController(frontCamera, ResolutionPreset.high);
  await cameraController.initialize();
  return cameraController;
}

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

    return FutureBuilder(
        future: getCamera(),
        builder:
            (BuildContext context, AsyncSnapshot<CameraController> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final cameraController = snapshot.data;
            // print(cameraController);
            return Scaffold(
                appBar: AppBar(),
                body: Center(
                    child: Column(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        child: Text('まずは$sexStringの$index番目の人の登録です。')),
                    Container(
                        alignment: Alignment.center,
                        child: Text('自撮りを登録してください。')),
                    // CameraPreview(snapshot.data),
                  ],
                )));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
