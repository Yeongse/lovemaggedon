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
        appBar: AppBar(
          title: const Text(
            "初期設定",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '参加する人数を入力してね(男女合計)',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 24.0),
                DropdownButton<int>(
                  value: memberNum,
                  items:
                      memberNumLists.map<DropdownMenuItem<int>>((int number) {
                    return DropdownMenuItem<int>(
                      value: number,
                      child: Text(
                        '$number人',
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 16.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (newNumber) {
                    setState(() {
                      memberNum = newNumber as int;
                    });
                  },
                  dropdownColor: Colors.white,
                  style:
                      const TextStyle(color: Colors.deepPurple, fontSize: 16.0),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    '参加人数を確定する',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    ref.read(memberNumProvider.notifier).state = memberNum;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GuidePage()),
                    );
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
