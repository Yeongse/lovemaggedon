import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../providers.dart';
import './matchGuidePage.dart';
import 'homePage.dart';

class MemberComponent extends StatelessWidget {
  final Member member;
  const MemberComponent({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          alignment: Alignment.center,
          width: deviceSize.width * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                spreadRadius: 2.0,
                offset: Offset(0, 3),
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 追加
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.file(
                      File(member.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class AllMembersPage extends StatelessWidget {
  const AllMembersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final Widget resetButton = Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            ref.read(memberNumProvider.notifier).update((state) => 0);
            ref.read(memberIndexProvider.notifier).update((state) => 0);
            ref.read(membersProvider.notifier).update((state) => []);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomePage(title: 'ドキドキマッチング！！')),
            );
          },
        ),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(memberIndexProvider.notifier).update((state) => 0);
      });
      final deviceSize = MediaQuery.of(context).size;
      final allMembers = ref.watch(membersProvider);
      List<Member> males =
          allMembers.where((member) => member.sex == '男の子').toList();
      List<Member> females =
          allMembers.where((member) => member.sex == '女の子').toList();
      return (males.isEmpty || females.isEmpty)
          ? Scaffold(
              body: Container(
                height: deviceSize.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '片方の性別しかいないから\nこのゲームは実施できないよ...\n\nもう一度最初からやり直してね',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    resetButton
                  ],
                ),
              ),
            )
          : Scaffold(
              body: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60.0),
                      const Text(
                        "男の子の参加者",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: males
                              .map((maleMember) =>
                                  MemberComponent(member: maleMember))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      const Text(
                        "女の子の参加者",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: females
                              .map((femaleMember) =>
                                  MemberComponent(member: femaleMember))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            '気になる相手を選ぶ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MatchGuidePage()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
    });
  }
}
