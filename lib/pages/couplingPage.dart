import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../providers.dart';

class CouplingPage extends StatefulWidget {
  const CouplingPage({Key? key}) : super(key: key);

  @override
  _CouplingPageState createState() => _CouplingPageState();
}

class _CouplingPageState extends State<CouplingPage> {
  String name = "";
  String sex = "";

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final allMembers = ref.watch(membersProvider);
      for (var member in allMembers) {
        print(member.loveMemberIndex);
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "マッチング",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: const Text("Coming Soon"),
      );
    });
  }
}
