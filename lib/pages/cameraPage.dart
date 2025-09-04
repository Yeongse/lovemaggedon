import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import './registerPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'homePage.dart';
import '../providers.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/ad_banner_footer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

    // 権限が未決定または拒否されている場合は権限を要求
    if (status.isDenied || status.isRestricted) {
      debugPrint('Requesting camera permission, current status: $status');
      status = await Permission.camera.request();
      debugPrint('Permission request result: $status');
    }

    // 最終的な権限状態をチェック
    if (status.isGranted) {
      setState(() {
        _cameraPermissionDenied = false;
      });
      debugPrint('Camera permission granted');
    } else {
      setState(() {
        _cameraPermissionDenied = true;
      });
      debugPrint('Camera permission denied: $status');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.bgra8888, enableAudio: false);
    _initializeControllerFuture = Future.wait([
      _controller.initialize(),
      _checkCameraPermission(),
    ]);
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
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
          child: const Text('ホームに戻る',
              style: TextStyle(fontSize: 18)), // フォントサイズを少し大きく
          onPressed: () {
            ref.read(memberNumProvider.notifier).state = 0;
            ref.read(memberIndexProvider.notifier).state = 0;
            ref.read(membersProvider.notifier).state = [];
            ref.read(isTestModeProvider.notifier).state = false;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const HomePage(title: 'ドキドキマッチング！！')),
              (route) => false,
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
              bottomNavigationBar: const AdBannerFooter(),
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
                      final mediaQuery = MediaQuery.of(context);
                      final double screenHeight = mediaQuery.size.height;
                      final double bottomPadding = mediaQuery.padding.bottom;
                      // バナー広告の想定高さ（ロード前でも確保）
                      final double adHeight = AdSize.banner.height.toDouble();
                      // FABとテキストのための余白を十分に確保
                      const double fabAndTextReserve = 120.0; // ボタン+テキスト分
                      final double maxCameraHeight = screenHeight -
                          adHeight -
                          bottomPadding -
                          fabAndTextReserve;

                      // 撮影プレビューと同一のアスペクト比で描画する
                      final Size? previewSize = _controller.value.previewSize;
                      final bool isPortrait =
                          mediaQuery.orientation == Orientation.portrait;
                      final double aspect = previewSize != null
                          ? (isPortrait
                              ? previewSize.height / previewSize.width
                              : previewSize.width / previewSize.height)
                          : (isPortrait
                              ? 1 / _controller.value.aspectRatio
                              : _controller.value.aspectRatio);

                      return Column(
                        children: [
                          // カメラ領域（高さ上限あり、横方向は余白可）
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: maxCameraHeight.clamp(0, screenHeight),
                            ),
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: aspect,
                                child: CameraPreview(_controller),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
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
                          // 残りは自然に埋める
                          const Spacer(),
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
              bottomNavigationBar: const AdBannerFooter(),
            );
    });
  }
}
