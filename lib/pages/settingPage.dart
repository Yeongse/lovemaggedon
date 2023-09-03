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
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    style: const TextStyle(
                        color: Colors.deepPurple, fontSize: 16.0),
                  ),
                  const SizedBox(height: 32.0),
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
                      '人数を確定する',
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
                            content: const Text('人数に間違いはない？\n※後から変更できないよ'),
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
                                  ref.read(memberNumProvider.notifier).state =
                                      memberNum;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GuidePage()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
