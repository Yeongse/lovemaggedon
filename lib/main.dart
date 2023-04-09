import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import './homePage.dart';
import './members.dart';

void main() {
  runApp(const MyApp());
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // カメラを初期化
//   final cameras = await availableCameras();
//   final firstCamera = cameras.first;

//   runApp(MyApp(camera: firstCamera));
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Members(),
      child: MaterialApp(
        title: 'ラブマゲドン',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: const HomePage(title: 'ラブマゲドン！！'),
      ),
    );
  }
}
