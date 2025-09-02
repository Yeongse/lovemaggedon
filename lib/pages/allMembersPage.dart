import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../providers.dart';
import './matchGuidePage.dart';
import './notPlayablePage.dart';
import '../widgets/ad_banner_footer.dart';

class MemberComponent extends StatelessWidget {
  final Member member;
  const MemberComponent({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;

      Widget _imageFromPath(String path) {
        if (path.startsWith('assets/')) {
          return Image.asset(path, fit: BoxFit.cover);
        }
        return Image.file(File(path), fit: BoxFit.cover);
      }

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
                    child: _imageFromPath(member.image),
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(memberIndexProvider.notifier).update((state) => 0);
      });
      // deviceSize はこのスコープでは未使用
      final allMembers = ref.watch(membersProvider);

      // メンバーが登録されていない場合は性別チェックを行わない
      if (allMembers.isNotEmpty) {
        List<Member> males =
            allMembers.where((member) => member.sex == '男の子').toList();
        List<Member> females =
            allMembers.where((member) => member.sex == '女の子').toList();
        if (males.isEmpty || females.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotPlayablePage(
                  title: 'プレイできません',
                  message: '男の子か女の子のどちらかしかいないため、プレイできません。\nホームに戻って最初からやり直してね。',
                ),
              ),
            );
          });
          return const SizedBox.shrink();
        }
      }

      List<Member> males =
          allMembers.where((member) => member.sex == '男の子').toList();
      List<Member> females =
          allMembers.where((member) => member.sex == '女の子').toList();
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "男の子の参加者",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      if (males.length > 2) // 3人以上の場合のみ表示
                        const Icon(
                          Icons.swipe_left,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  if (males.length > 2) // 3人以上の場合のみ表示
                    const Text(
                      "← スワイプで全員見れるよ →",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 12.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.blue.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.blueAccent.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: males
                            .map((maleMember) =>
                                MemberComponent(member: maleMember))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "女の子の参加者",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      if (females.length > 2) // 3人以上の場合のみ表示
                        const Icon(
                          Icons.swipe_left,
                          color: Colors.pinkAccent,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  if (females.length > 2) // 3人以上の場合のみ表示
                    const Text(
                      "← スワイプで全員見れるよ →",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 12.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.pink.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.pinkAccent.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: females
                            .map((femaleMember) =>
                                MemberComponent(member: femaleMember))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
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
        ),
        bottomNavigationBar: const AdBannerFooter(),
      );
    });
  }
}
