import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import './choosePage.dart';
import './couplingPage.dart';
import '../models/member.dart';

class MatchGuidePage extends StatelessWidget {
  const MatchGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final int index = ref.watch(memberIndexProvider);
      final allMembers = ref.watch(membersProvider);

      Widget buildScaffold(Member chooser, String text, Function onPressed) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: deviceSize.width,
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontFamily: 'Bebas Neue',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.file(
                        File(chooser.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
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
                      onPressed: onPressed as void Function()?,
                      child: const Text('次に進む'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      if (index >= ref.watch(memberNumProvider)) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: deviceSize.width,
                      child: const Text(
                        '全員の登録が完了したよ！\n結果はどうかな〜♡',
                        style: TextStyle(
                          fontFamily: 'Bebas Neue',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CouplingPage()),
                        );
                      },
                      child: const Text('次に進む'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        Member chooser = allMembers[index];
        return ref.watch(cameraProvider).when(
              data: (camera) {
                return buildScaffold(
                  chooser,
                  '${chooser.name}さん\n気になる相手を選んでね♡',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChoosePage(),
                      ),
                    );
                  },
                );
              },
              loading: () {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              },
              error: (err, stack) => Scaffold(
                body: Center(child: Text('Error: $err')),
              ),
            );
      }
    });
  }
}
