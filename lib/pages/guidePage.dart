import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import './cameraPage.dart';
import './allMembersPage.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final int index = ref.watch(memberIndexProvider);

      Widget buildScaffold(String text, Function onPressed) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: Padding(
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
                  const SizedBox(height: 40.0),
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
        );
      }

      if (index >= ref.watch(memberNumProvider)) {
        return buildScaffold(
          '全員の登録が完了したよ！お疲れさま！',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllMembersPage()),
            );
          },
        );
      } else {
        return ref.watch(cameraProvider).when(
              data: (camera) {
                return buildScaffold(
                  '${index + 1}番目の参加者を登録するよ!',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraPage(camera: camera),
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
