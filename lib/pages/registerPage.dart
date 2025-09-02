import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../models/member.dart';
import '../providers.dart';
import './guidePage.dart';
import '../widgets/ad_banner_footer.dart';

class RegisterPage extends StatefulWidget {
  final String imagePath;
  const RegisterPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name = "";
  String sex = "";

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final int index = ref.watch(memberIndexProvider);
      final bool isTest = ref.watch(isTestModeProvider);
      final List<String> sexes = ['男の子', '女の子'];

      return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            height: deviceSize.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('撮り直す'),
                      onPressed: () async {
                        final shouldNavigate = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('確認'),
                                  content: const Text('本当に撮り直しても大丈夫？'),
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
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 270,
                      height: 360,
                      child: (() {
                        final String displayPath = isTest
                            ? (sex == '女の子'
                                ? 'assets/female_sanple.png'
                                : 'assets/male_sample.png')
                            : widget.imagePath;
                        if (displayPath.startsWith('assets/')) {
                          return Image.asset(displayPath, fit: BoxFit.cover);
                        }
                        return Image.file(File(displayPath), fit: BoxFit.cover);
                      })(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: deviceSize.width * 0.6,
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
                            )),
                        onChanged: (text) {
                          setState(() {
                            name = text;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: deviceSize.width * 0.6,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: '性別を選択してね',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          errorStyle: const TextStyle(
                              color: Colors.redAccent, fontSize: 12),
                        ),
                        dropdownColor: Colors.white,
                        value: sex.isEmpty ? null : sex,
                        hint: const Text('性別がここに入るよ'),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.blueGrey),
                        items:
                            sexes.map<DropdownMenuItem<String>>((String sex) {
                          return DropdownMenuItem<String>(
                            value: sex,
                            child: Text(
                              sex,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          );
                        }).toList(),
                        onChanged: (newSex) {
                          setState(() {
                            sex = newSex!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '性別が入力されてないよ！';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('登録する'),
                      onPressed: () {
                        // まず入力チェックを行う
                        if (sex.isEmpty || name.isEmpty) {
                          // sexまたはnameが空の場合、エラーモーダルを表示
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                icon: const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                title: const Text(
                                  '入力不足',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text('性別と名前を入力してね！'),
                                backgroundColor: Colors.white,
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // 入力に問題がない場合、確認モーダルを表示
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('確認'),
                                content: const Text('この内容で登録しても大丈夫？？'),
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
                                      final String imagePathToSave = isTest
                                          ? (sex == '女の子'
                                              ? 'assets/female_sanple.png'
                                              : 'assets/male_sample.png')
                                          : widget.imagePath;
                                      final Member member = Member(
                                          index, sex, name, imagePathToSave);
                                      ref
                                          .read(membersProvider.notifier)
                                          .update((state) {
                                        state.add(member);
                                        return state;
                                      });
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
                        }
                      },
                    )
                  ],
                )),
              ),
            ),
          ),
          bottomNavigationBar: const AdBannerFooter());
    });
  }
}
