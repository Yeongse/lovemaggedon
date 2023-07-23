import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../providers.dart';

class CouplingPage extends StatelessWidget {
  const CouplingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final int index = ref.watch(memberIndexProvider);
      return Container(
        alignment: Alignment.center,
        width: deviceSize.width * 0.2,
        height: deviceSize.height * 0.2,
        child: const Text("Coming Soon"),
      );
    });
  }
}
