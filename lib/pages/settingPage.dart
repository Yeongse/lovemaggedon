import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './guidePage.dart';
import '../providers.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<int> memberNumLists = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  int memberNum = 2;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: const Text('参加する人数を入力してね(男女合計)')),
                        Container(
                          alignment: Alignment.center,
                          child: DropdownButton(
                            value: memberNum,
                            items: memberNumLists
                                .map<DropdownMenuItem<int>>((int number) {
                              return DropdownMenuItem<int>(
                                value: number,
                                child: Text(number.toString() + '人'),
                              );
                            }).toList(),
                            onChanged: (newNumber) {
                              setState(() {
                                memberNum = newNumber as int;
                              });
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              child: const Text('参加人数を確定する'),
                              onPressed: () {
                                ref.read(memberNumProvider.notifier).state =
                                    memberNum;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const GuidePage()),
                                );
                              }),
                        )
                      ],
                    ))
              ],
            ),
          ));
    });
  }
}
