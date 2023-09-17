import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import './registerPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'homePage.dart';
import '../providers.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.camera});
  final CameraDescription camera;

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  bool _cameraPermissionDenied = false;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  Future<void> _checkCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      setState(() {
        _cameraPermissionDenied = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.bgra8888, enableAudio: false);
    _initializeControllerFuture = _controller.initialize();
    _checkCameraPermission();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final Widget resetButton = Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
          child: const Text('ホームに戻る',
              style: TextStyle(fontSize: 18)), // フォントサイズを少し大きく
          onPressed: () {
            ref.read(memberNumProvider.notifier).update((state) => 0);
            ref.read(memberIndexProvider.notifier).update((state) => 0);
            ref.read(membersProvider.notifier).update((state) => []);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomePage(title: 'ドキドキマッチング！！')),
            );
          },
        ),
      );

      return _cameraPermissionDenied
          ? Scaffold(
              body: Container(
                height: deviceSize.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'カメラへのアクセス権限がないから\nプレイできないよ...\n\niPhoneの「設定」→「プライバシーとセキュリティ」→「カメラ」で「ドキマチ」に許可を与えてアプリを再起動してね...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    resetButton
                  ],
                ),
              ),
            )
          : Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Stack(
                        children: [
                          CameraPreview(_controller),
                          Positioned(
                            bottom: 10.0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: const Text(
                                '自撮りをしてね',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 6.0,
                                      color: Colors.black,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.deepPurple,
                onPressed: () async {
                  try {
                    await _initializeControllerFuture;
                    final image = await _controller.takePicture();
                    if (!mounted) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(
                          imagePath: image.path,
                        ),
                      ),
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Icon(Icons.camera_alt),
              ),
            );
    });
  }
}
