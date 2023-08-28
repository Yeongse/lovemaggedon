import 'dart:io';
import 'package:flutter/material.dart';

class FinalPage extends StatelessWidget {
  const FinalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "最終結果",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: const Text("Coming Soon..."));
  }
}
