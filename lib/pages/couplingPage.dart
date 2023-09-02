import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../models/love.dart';
import '../models/line.dart';
import '../providers.dart';
import 'dart:math' as math;
import './finalPage.dart';

class SmallMemberRadioComponent extends StatefulWidget {
  final Member member;
  final GlobalKey? globalKey;
  final bool isRadio;
  final bool isSmall;

  const SmallMemberRadioComponent({
    Key? key,
    this.globalKey,
    this.isRadio = true,
    this.isSmall = true,
    required this.member,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SmallMemberRadioComponentState createState() =>
      _SmallMemberRadioComponentState();
}

class _SmallMemberRadioComponentState extends State<SmallMemberRadioComponent> {
  int? selectedValue; // Radioの選択値を管理するための変数

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    // 画像のサイズを定義
    double imageWidth = deviceSize.width * (widget.isSmall ? 0.15 : 0.3);
    double imageHeight = imageWidth * 1.5; // 画像を長方形にするために高さを1.5倍にします。

    List<Widget> mainChildren = [
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // ここで角を丸くします。
              child: Image.file(
                File(widget.member.image),
                fit: BoxFit.cover, // 画像がコンテナにフィットするようにする。
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            widget.member.name,
            style: const TextStyle(
              fontSize: 14.0, // フォントサイズを少し大きくする。
              fontWeight: FontWeight.bold, // テキストを太字にする。
            ),
          ),
        ],
      ),
    ];
    if (widget.isRadio) {
      mainChildren.insert(
          widget.member.sex == "男の子" ? 1 : 0,
          Container(
            key: widget.globalKey,
            child: Transform.scale(
                scale: 0.3,
                child: Radio(
                  value: widget.member.index,
                  groupValue: selectedValue,
                  onChanged: (int? value) {},
                )),
          ));
    }

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10.0), // 余白を追加して、見た目を良くする。
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: mainChildren,
      ),
    );
  }
}

class CouplingPage extends StatefulWidget {
  const CouplingPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CouplingPageState createState() => _CouplingPageState();
}

class _CouplingPageState extends State<CouplingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  List<Line> lines = [];
  List<Love> matchedLoves = [];

  String direction = "からの";
  int revealIndex = -1;
  bool isOpened = false;
  bool isInitialTimePassed = false;

  late List<GlobalKey> globalKeys;
  late List<Love> allLoves;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2, milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        isInitialTimePassed = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final memberNum = ref.watch(memberNumProvider);
      final allMembers = ref.watch(membersProvider);
      List<Member> males =
          allMembers.where((member) => member.sex == '男の子').toList();
      List<Member> females =
          allMembers.where((member) => member.sex == '女の子').toList();

      globalKeys = List.generate(memberNum, (index) => GlobalKey());
      allLoves = allMembers
          .map((member) => Love(member.index, member.loveMemberIndex))
          .toList();

      return Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            CustomPaint(
              painter:
                  MultiLinePainter(lines: lines, progress: _animation.value),
              child: Container(),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: males
                      .map((maleMember) => SmallMemberRadioComponent(
                            globalKey: globalKeys[maleMember.index],
                            member: maleMember,
                          ))
                      .toList(),
                ),
                Column(
                  children: females
                      .map((femaleMember) => SmallMemberRadioComponent(
                            globalKey: globalKeys[femaleMember.index],
                            member: femaleMember,
                          ))
                      .toList(),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SizedBox(
                width: deviceSize.width * 0.4,
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: '誰かを選んでね',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
                    errorStyle:
                        const TextStyle(color: Colors.redAccent, fontSize: 8),
                  ),
                  dropdownColor: Colors.white,
                  value: revealIndex == -1 ? null : revealIndex,
                  hint: const Text('誰の気持ち？'),
                  icon:
                      const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                  items: allMembers.map<DropdownMenuItem<int>>((Member member) {
                    return DropdownMenuItem<int>(
                      value: member.index,
                      child: Text(
                        member.name,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    );
                  }).toList(),
                  onChanged: (newRevealIndex) {
                    setState(() {
                      revealIndex = newRevealIndex!;
                    });
                  },
                ),
              ),
              SizedBox(
                width: deviceSize.width * 0.4,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: '向きを選択してね',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    errorStyle:
                        const TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                  dropdownColor: Colors.white,
                  value: direction,
                  hint: const Text('どっち向き？'),
                  icon:
                      const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                  items: ["からの", "への"]
                      .map<DropdownMenuItem<String>>((String direction) {
                    return DropdownMenuItem<String>(
                      value: direction,
                      child: Text(
                        direction,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    );
                  }).toList(),
                  onChanged: (newDirection) {
                    setState(() {
                      direction = newDirection!;
                    });
                  },
                ),
              )
            ]),
            // 線引くボタン
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  if (revealIndex != -1) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('確認'),
                          content: Text(
                              '${allMembers[revealIndex].name}$direction気持ちを確認しても良い？'),
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
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  setState(() {
                                    matchedLoves = allLoves
                                        .where((Love love) => direction == "からの"
                                            ? love.fromIndex == revealIndex
                                            : love.toIndex == revealIndex)
                                        .toList();
                                    isOpened = true;
                                    if (matchedLoves.isEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('ごめんなさい'),
                                            content:
                                                const Text('気になる人はいなかったみたい...'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('戻る'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      lines = matchedLoves.map((Love love) {
                                        final RenderBox renderBoxFrom =
                                            globalKeys[love.fromIndex]
                                                    .currentContext!
                                                    .findRenderObject()
                                                as RenderBox;
                                        final RenderBox renderBoxTo =
                                            globalKeys[love.toIndex]
                                                    .currentContext!
                                                    .findRenderObject()
                                                as RenderBox;
                                        final topLeftPositionFrom =
                                            renderBoxFrom
                                                .localToGlobal(Offset.zero);
                                        final topLeftPositionTo = renderBoxTo
                                            .localToGlobal(Offset.zero);
                                        final centerPositionFrom =
                                            topLeftPositionFrom.translate(
                                          renderBoxFrom.size.width / 2,
                                          renderBoxFrom.size.height / 2,
                                        );
                                        final centerPositionTo =
                                            topLeftPositionTo.translate(
                                          renderBoxTo.size.width / 2,
                                          renderBoxTo.size.height / 2,
                                        );

                                        return Line(
                                            startX: centerPositionFrom.dx,
                                            startY: centerPositionFrom.dy -
                                                102 +
                                                100 +
                                                2,
                                            endX: centerPositionTo.dx,
                                            endY: centerPositionTo.dy -
                                                102 +
                                                100 +
                                                2);
                                      }).toList();
                                      _controller.forward(from: 0);
                                      Navigator.of(context).pop();
                                    }
                                  });
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('ごめんなさい'),
                          content: const Text('誰の気持ちを確認するか決めてね！'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('戻る'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('気持ちを確認する♡'),
              ),
            ),
            // 結ばれたか確認ボタン
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('結ばれたか確認する'),
                onPressed: () {
                  if (isOpened == true) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('確認'),
                          content: const Text('お相手の気持ちを確認して良い？'),
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
                                var pickedMember =
                                    allMembers[matchedLoves[0].toIndex];
                                var couple = getCouple(
                                    matchedLoves, pickedMember, allMembers);
                                _showPopUp(context, couple);
                                setState(() {
                                  isOpened = false;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('ごめんなさい'),
                          content: const Text('結果は気持ちを確認した後でお願い'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('戻る'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            // 最終結果確認ボタン
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // もう少し淡いピンク色に変更
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 5,
                ),
                child: const Text('最終結果を確認する'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('確認'),
                        content: const Text('最終結果を確認して良い？\n※全員の結果が見えてしまうよ'),
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
                                    builder: (context) => const FinalPage()),
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
          ]),
        ),
      );
    });
  }
}

List<Member> getCouple(
    List<Love> matchedLoves, Member pickedMember, List<Member> allMembers) {
  for (var love in matchedLoves) {
    if (pickedMember.loveMemberIndex == love.fromIndex) {
      return [allMembers[love.fromIndex], allMembers[love.toIndex]];
    }
  }
  return [];
}

// 結果確認時に表示するコンポーネント
void _showPopUp(BuildContext context, List<Member> couple) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final deviceSize = MediaQuery.of(context).size;
      if (couple.isEmpty) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: deviceSize.width * 0.6,
            height: deviceSize.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('残念、両思いはいなかったみたい...'),
                ElevatedButton(
                  child: const Text('戻る'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      } else {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 5.0, // shadow to make the dialog pop
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            width: deviceSize.width * 0.8,
            height: deviceSize.height * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'カップル成立♡',
                      style: TextStyle(
                        fontFamily: 'Bebas Neue',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: couple
                      .map((coupleMember) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SmallMemberRadioComponent(
                              member: coupleMember,
                              isRadio: false,
                              isSmall: false,
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20), // Add some space before the button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('戻る'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    },
  );
}

// 線を描画するためだけのコンポーネント
class MultiLinePainter extends CustomPainter {
  final List<Line> lines;
  final double progress;

  MultiLinePainter({required this.lines, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pinkAccent
      ..strokeWidth = 7.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = null
      ..isAntiAlias = true;

    const double dashWidth = 16.0;
    const double dashSpace = 16.0;

    for (var line in lines) {
      double progressStartX = line.startX;
      double progressStartY = line.startY;
      final totalLength = math.sqrt(math.pow(line.endX - line.startX, 2) +
          math.pow(line.endY - line.startY, 2));
      double dx = (line.endX - line.startX) / totalLength;
      double dy = (line.endY - line.startY) / totalLength;

      double remainingLength = progress * totalLength;

      while (remainingLength > 0) {
        double currentDashLength = math.min(dashWidth, remainingLength);
        canvas.drawLine(
            Offset(progressStartX, progressStartY),
            Offset(progressStartX + dx * currentDashLength,
                progressStartY + dy * currentDashLength),
            paint);
        progressStartX += dx * (currentDashLength + dashSpace);
        progressStartY += dy * (currentDashLength + dashSpace);
        remainingLength -= (currentDashLength + dashSpace);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MultiLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
