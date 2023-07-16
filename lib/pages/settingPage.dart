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
  List<int> memberNum = [1, 2, 3, 4, 5, 6];
  int maleNum = 1;
  int femaleNum = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      // final count = ref.watch(counterProvider);
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
                            child: const Text('男性の人数を入力してね')),
                        Container(
                          alignment: Alignment.center,
                          child: DropdownButton(
                            value: maleNum,
                            items: memberNum
                                .map<DropdownMenuItem<int>>((int number) {
                              return DropdownMenuItem<int>(
                                value: number,
                                child: Text(number.toString() + '人'),
                              );
                            }).toList(),
                            onChanged: (newNumber) {
                              setState(() {
                                maleNum = newNumber as int;
                              });
                            },
                          ),
                        )
                      ],
                    )),
                Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: const Text('女性の人数を入力してね')),
                        Container(
                          alignment: Alignment.center,
                          child: DropdownButton(
                            value: femaleNum,
                            items: memberNum
                                .map<DropdownMenuItem<int>>((int number) {
                              return DropdownMenuItem<int>(
                                value: number,
                                child: Text(number.toString() + '人'),
                              );
                            }).toList(),
                            onChanged: (newNumber) {
                              setState(() {
                                femaleNum = newNumber as int;
                              });
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              child: const Text('参加人数を確定する'),
                              onPressed: () {
                                ref.read(maleNumProvider.notifier).state =
                                    maleNum;
                                ref.read(femaleNumProvider.notifier).state =
                                    femaleNum;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const GuidePage(sex: 'male')),
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
