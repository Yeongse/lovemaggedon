import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class AllMembersPage extends StatelessWidget {
  const AllMembersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final int index = ref.watch(memberIndexProvider);
      return Scaffold(
          appBar: AppBar(), body: const Center(child: Text('ComingSoon')));
    });
  }
}
