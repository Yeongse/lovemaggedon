import 'dart:io';

import 'package:flutter/material.dart';
import './settingPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('スタート'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
