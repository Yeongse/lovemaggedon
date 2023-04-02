import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './homePage.dart';
import './members.dart';

void main() {
  runApp(const MyApp());
}

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
