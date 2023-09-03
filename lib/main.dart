import 'package:flutter/material.dart';
import './providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './pages/homePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ドキマチ',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const HomePage(title: 'ドキドキマッチング！！'),
    );
  }
}
