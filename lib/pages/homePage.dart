import 'package:flutter/material.dart';
import './settingPage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import './notPlayablePage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '今夜誰かが結ばれる？！',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'ドキドキマッチング',
                    style: TextStyle(
                      fontFamily: 'Bebas Neue',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: SizedBox(
                          width: deviceSize.width * 0.8,
                          height: deviceSize.width * 0.8,
                          child: Image.asset('assets/home.png'))),
                  const SizedBox(height: 24.0),
                  Consumer(builder: (context, ref, _) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('スタート'),
                      onPressed: () async {
                        final PermissionStatus status =
                            await Permission.camera.status;
                        if (status.isGranted) {
                          // 新規プレイ開始前に状態を初期化
                          ref.read(memberNumProvider.notifier).state = 0;
                          ref.read(memberIndexProvider.notifier).state = 0;
                          ref.read(membersProvider.notifier).state = [];
                          ref.read(isTestModeProvider.notifier).state = false;
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingPage()),
                          );
                        } else {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotPlayablePage(
                                title: 'カメラ権限が必要です',
                                message:
                                    'カメラへのアクセス許可がないため、プレイできません。\\n設定からカメラを許可して、ホームに戻ってやり直してね。',
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }),
                  const SizedBox(height: 12.0),
                  Consumer(builder: (context, ref, _) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('テストモードでスタート'),
                      onPressed: () {
                        // 新規プレイ開始前に状態を初期化
                        ref.read(memberNumProvider.notifier).state = 0;
                        ref.read(memberIndexProvider.notifier).state = 0;
                        ref.read(membersProvider.notifier).state = [];
                        ref.read(isTestModeProvider.notifier).state = true;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingPage()),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
