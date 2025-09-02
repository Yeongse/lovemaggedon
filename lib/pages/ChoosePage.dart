import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../providers.dart';
import './matchGuidePage.dart';
import '../widgets/ad_banner_footer.dart';

class LargeMemberRadioComponent extends StatefulWidget {
  final Member member;

  const LargeMemberRadioComponent({
    Key? key,
    required this.member,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LargeMemberRadioComponentState createState() =>
      _LargeMemberRadioComponentState();
}

class _LargeMemberRadioComponentState extends State<LargeMemberRadioComponent> {
  int? selectedValue; // Radioの選択値を管理するための変数

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final int index = ref.watch(memberIndexProvider);
      final allMembers = ref.watch(membersProvider);

      // 配列の範囲外アクセスを防ぐ
      if (allMembers.isEmpty || index >= allMembers.length || index < 0) {
        return const SizedBox.shrink();
      }

      final Member chooser = allMembers[index];

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          alignment: Alignment.center,
          width: deviceSize.width * 0.80,
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
              mainAxisSize: MainAxisSize.min,
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
                    child: widget.member.image.startsWith('assets/')
                        ? Image.asset(widget.member.image, fit: BoxFit.cover)
                        : Image.file(File(widget.member.image),
                            fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.member.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'この人に決める♡',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('確認'),
                            content: Text(
                                '${chooser.name}さんが気になるのは\n${widget.member.name}さんなんだね？'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('戻る'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  ref
                                      .read(membersProvider.notifier)
                                      .update((state) {
                                    state[index]
                                        .setLoveMember(widget.member.index);
                                    return state;
                                  });
                                  ref
                                      .read(memberIndexProvider.notifier)
                                      .update((state) => state + 1);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MatchGuidePage()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
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

class ChoosePage extends StatefulWidget {
  const ChoosePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  int? loveMemberIndex = -1;
  // int? selectedValueInChoosePage;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final int index = ref.watch(memberIndexProvider);
      final allMembers = ref.watch(membersProvider);

      // 配列の範囲外アクセスを防ぐ
      if (allMembers.isEmpty || index >= allMembers.length || index < 0) {
        return const Scaffold(
          body: Center(
            child: Text('参加者データが見つかりません'),
          ),
        );
      }

      List<Member> males =
          allMembers.where((member) => member.sex == '男の子').toList();
      List<Member> females =
          allMembers.where((member) => member.sex == '女の子').toList();
      final Member chooser = allMembers[index];

      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${chooser.name}さん\n気になる相手を選んでね♡",
                    style: const TextStyle(
                      fontFamily: 'Bebas Neue',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  if ((chooser.sex == "男の子" ? females : males).length >
                      2) // 3人以上の場合のみ表示
                    const Text(
                      "← スワイプで全員見れるよ →",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 20.0),
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
                        children: (chooser.sex == "男の子" ? females : males)
                            .map((member) => LargeMemberRadioComponent(
                                  member: member,
                                ))
                            .toList(),
                      ),
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
