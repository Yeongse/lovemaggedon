import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../models/member.dart';
import '../providers.dart';
import './guidePage.dart';

class RegisterPage extends StatelessWidget {
  final String imagePath;
  const RegisterPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final int index = ref.watch(memberIndexProvider);
      final List<String> sexes = ['男の子', '女の子'];
      String name = "";
      String sex = "";

      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Center(
                child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: const Text('撮り直す'),
                    onPressed: () async {
                      final shouldNavigate = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('確認'),
                                content: const Text('本当に撮り直しますか？'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('キャンセル'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          ) ??
                          false;
                      if (shouldNavigate) {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                Container(
                  width: 300,
                  height: 400,
                  child: Image.file(File(imagePath)),
                ),
                SizedBox(
                  width: deviceSize.width * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: '名前を入力してね',
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (text) {
                        name = text;
                      },
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: DropdownButton(
                    value: sexes[0],
                    items: sexes.map<DropdownMenuItem<String>>((String sex) {
                      return DropdownMenuItem<String>(
                        value: sex,
                        child: Text(sex),
                      );
                    }).toList(),
                    onChanged: (newSex) {
                      sex = newSex!;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: const Text('登録する'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('確認'),
                            content: const Text('これで登録していいですか？'),
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
                                  final Member member =
                                      Member(index, sex, name, imagePath);
                                  // 新メンバーの追加
                                  ref
                                      .read(membersProvider.notifier)
                                      .update((state) {
                                    state.add(member);
                                    return state;
                                  });
                                  // インデックスの一個ずらし
                                  ref
                                      .read(memberIndexProvider.notifier)
                                      .update((state) => state + 1);
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
                )
              ],
            )),
          ));
    });
  }
}
