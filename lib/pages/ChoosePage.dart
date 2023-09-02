import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../providers.dart';
import './matchGuidePage.dart';

class LargeMemberRadioComponent extends StatefulWidget {
  final Member member;
  final ValueChanged<int?> onValueChanged;

  const LargeMemberRadioComponent({
    Key? key,
    required this.member,
    required this.onValueChanged,
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

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          alignment: Alignment.center,
          width: deviceSize.width * 0.60,
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
                    child: Image.file(
                      File(widget.member.image),
                      fit: BoxFit.cover,
                    ),
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
                Radio(
                  value: widget.member.index,
                  groupValue: selectedValue,
                  onChanged: (int? value) {
                    setState(() {
                      selectedValue = value;
                    });
                    widget.onValueChanged(value);
                  },
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
      List<Member> males =
          allMembers.where((member) => member.sex == '男の子').toList();
      List<Member> females =
          allMembers.where((member) => member.sex == '女の子').toList();
      final Member chooser = allMembers[index];

      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "ドキドキ！",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24.0),
                const Text(
                  "お相手の皆さん",
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
                    children: (chooser.sex == "男の子" ? females : males)
                        .map((femaleMember) => LargeMemberRadioComponent(
                              member: femaleMember,
                              onValueChanged: (value) {
                                setState(() {
                                  loveMemberIndex = value;
                                });
                              },
                            ))
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
                      'この人に決める',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('確認'),
                            content: Text(
                                '$chooserさんが気になるのは${allMembers[loveMemberIndex!].name}さんなんだね？'),
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
                                  if (loveMemberIndex == -1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('相手を選んでください！'),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    ref
                                        .read(membersProvider.notifier)
                                        .update((state) {
                                      state[index]
                                          .setLoveMember(loveMemberIndex!);
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
                                  }
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
          ));
    });
  }
}
