import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../providers.dart';
import 'homePage.dart';

// coupleの長さは絶対に2
class CoupleComponent extends StatelessWidget {
  final List<Member> couple;
  const CoupleComponent({Key? key, required this.couple}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: deviceSize.width * 0.95,
        height: deviceSize.width * 0.6,
        decoration: BoxDecoration(
          color: Colors.grey[100], // 背景色を少しグレーにして区別
          borderRadius: BorderRadius.circular(15.0), // 角を丸くする
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 画像の間にスペース
              children: [
                _buildRoundedImage(deviceSize, couple[0].image),
                _buildRoundedImage(deviceSize, couple[1].image),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              '${couple[0].name} & ${couple[1].name} カップル♡',
              style: const TextStyle(
                fontSize: 20, // フォントサイズを大きく
                fontWeight: FontWeight.bold, // 太字に
                color: Colors.red, // 色を深紫に
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class FinalPage extends StatelessWidget {
  const FinalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final allMembers = ref.watch(membersProvider);
      List<List<Member>> allCouples = getCouples(allMembers);

      List<Widget> initialComponents = [
        const SizedBox(height: 80),
        const Center(
          child: Text(
            '今回成立したのは...',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24)
      ];

      List<Widget> coupleComponents = allCouples.isEmpty
          ? const [
              Center(
                child: Text(
                  '残念\nカップルは成立しなかったよ...',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ]
          : allCouples
              .map((couple) => Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10.0), // 上下の余白を追加
                    child: CoupleComponent(
                      couple: couple,
                    ),
                  ))
              .toList();

      Widget resetButton = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
          child: const Text('ホームに戻る',
              style: TextStyle(fontSize: 18)), // フォントサイズを少し大きく
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('確認'),
                  content:
                      const Text('このマッチングを終了するよ？\n※データはもう残らないからスクショするなら今だよ！)'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('キャンセル'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        ref
                            .read(memberNumProvider.notifier)
                            .update((state) => 0);
                        ref
                            .read(memberIndexProvider.notifier)
                            .update((state) => 0);
                        ref
                            .read(membersProvider.notifier)
                            .update((state) => []);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const HomePage(title: 'ドキドキマッチング！！')),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      );

      List<Widget> bodyComponents = []
        ..addAll(initialComponents)
        ..addAll(coupleComponents)
        ..add(resetButton);

      return Scaffold(
        body: Container(
          height: deviceSize.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(20.0), // 全体の余白を追加
            child: Column(children: bodyComponents),
          ),
        ),
      );
    });
  }
}

List<List<Member>> getCouples(List<Member> allMembers) {
  List<List<Member>> couples = [];
  List<Member> allMales =
      allMembers.where((member) => member.sex == '男の子').toList();
  for (var male in allMales) {
    Member likedFemale = allMembers[male.loveMemberIndex];
    if (likedFemale.loveMemberIndex == male.index) {
      couples.add([male, likedFemale]);
    }
  }
  return couples;
}

// 画像の角をフィレットにするヘルパー関数
Widget _buildRoundedImage(Size deviceSize, String imagePath) {
  return Container(
    width: deviceSize.width * 0.4,
    height: deviceSize.width * 0.4,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0), // ここで角をフィレットに
      image: DecorationImage(
        image: FileImage(File(imagePath)),
        fit: BoxFit.cover,
      ),
    ),
  );
}
