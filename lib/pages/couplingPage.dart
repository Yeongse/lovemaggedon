import 'dart:io';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../models/love.dart';
import '../models/line.dart';
import '../providers.dart';
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
    double imageWidth = deviceSize.width * (widget.isSmall ? 0.12 : 0.3);
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
              child: widget.member.image.startsWith('assets/')
                  ? Image.asset(widget.member.image, fit: BoxFit.cover)
                  : Image.file(
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
  Timer? _delayTimer;

  List<Line> lines = [];
  List<Love> matchedLoves = [];

  String direction = "からの";
  int revealIndex = -1;
  bool isOpened = false;
  bool isInitialTimePassed = false;

  // 新しいフェーズ管理: 0=初期, 1=気持ち確認済み, 2=結果確認済み, 3=次の人確認準備
  int currentPhase = 0;
  bool isInputLocked = false;

  late List<GlobalKey> globalKeys;
  late List<Love> allLoves;
  late List<Member> allMembers;
  final GlobalKey _customPaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2, milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    _delayTimer = Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          isInitialTimePassed = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _delayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final memberNum = ref.watch(memberNumProvider);
      allMembers = ref.watch(membersProvider);
      List<Member> males =
          allMembers.where((member) => member.sex == '男の子').toList();
      List<Member> females =
          allMembers.where((member) => member.sex == '女の子').toList();

      globalKeys = List.generate(memberNum, (index) => GlobalKey());
      allLoves = allMembers
          .map((member) => Love(member.index, member.loveMemberIndex))
          .toList();

      return Scaffold(
        body: Container(
          height: deviceSize.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: [
            // 上部余白
            const SizedBox(height: 20.0),
            // スクロール可能な線描画エリア（画面の80%）
            Container(
              height: deviceSize.height * 0.8,
              child: SingleChildScrollView(
                child: Column(children: [
                  // 上部余白
                  const SizedBox(height: 20.0),
                  // 左右余白付きStack
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.pink.withOpacity(0.08),
                                Colors.purple.withOpacity(0.12),
                                Colors.deepPurple.withOpacity(0.08),
                                Colors.pink.withOpacity(0.06),
                              ],
                              stops: const [0.0, 0.3, 0.7, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: Colors.pink.withOpacity(0.3),
                              width: 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.15),
                                blurRadius: 12.0,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.1),
                                blurRadius: 20.0,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CustomPaint(
                            key: _customPaintKey,
                            painter: MultiLinePainter(
                                lines: lines, progress: _animation.value),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: males
                                        .map((maleMember) =>
                                            SmallMemberRadioComponent(
                                              globalKey:
                                                  globalKeys[maleMember.index],
                                              member: maleMember,
                                            ))
                                        .toList(),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: females
                                        .map((femaleMember) =>
                                            SmallMemberRadioComponent(
                                              globalKey: globalKeys[
                                                  femaleMember.index],
                                              member: femaleMember,
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            // 下部UI（残りのスペース）
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 横一列にした操作UI
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: '誰？',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                errorStyle: const TextStyle(
                                    color: Colors.redAccent, fontSize: 8),
                                filled: isInputLocked,
                                fillColor:
                                    isInputLocked ? Colors.grey.shade200 : null,
                              ),
                              dropdownColor: Colors.white,
                              value: revealIndex == -1 ? null : revealIndex,
                              hint: Text(
                                '選択',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isInputLocked ? Colors.grey : null,
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: isInputLocked
                                    ? Colors.grey
                                    : Colors.blueGrey,
                                size: 20,
                              ),
                              items: allMembers
                                  .map<DropdownMenuItem<int>>((Member member) {
                                return DropdownMenuItem<int>(
                                  value: member.index,
                                  child: Text(
                                    member.name,
                                    style: TextStyle(
                                        color: isInputLocked
                                            ? Colors.grey.shade600
                                            : Colors.black87,
                                        fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              onChanged: isInputLocked
                                  ? null
                                  : (newRevealIndex) {
                                      setState(() {
                                        revealIndex = newRevealIndex!;
                                      });
                                    },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: '向き',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                errorStyle: const TextStyle(
                                    color: Colors.redAccent, fontSize: 8),
                                filled: isInputLocked,
                                fillColor:
                                    isInputLocked ? Colors.grey.shade200 : null,
                              ),
                              dropdownColor: Colors.white,
                              value: direction,
                              hint: Text(
                                '？',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isInputLocked ? Colors.grey : null,
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: isInputLocked
                                    ? Colors.grey
                                    : Colors.blueGrey,
                                size: 20,
                              ),
                              items: ["からの", "への"]
                                  .map<DropdownMenuItem<String>>(
                                      (String direction) {
                                return DropdownMenuItem<String>(
                                  value: direction,
                                  child: Text(
                                    direction,
                                    style: TextStyle(
                                        color: isInputLocked
                                            ? Colors.grey.shade600
                                            : Colors.black87,
                                        fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              onChanged: isInputLocked
                                  ? null
                                  : (newDirection) {
                                      setState(() {
                                        direction = newDirection!;
                                      });
                                    },
                            ),
                          ),
                        ),
                        // ボタンをRowに追加
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                minimumSize: const Size(0, 20),
                              ),
                              onPressed: _handleButtonPress,
                              child: _getButtonWidget(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 最終結果確認ボタン
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // もう少し淡いピンク色に変更
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          elevation: 5,
                        ),
                        child: const Text('最終結果を確認する'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('確認'),
                                content:
                                    const Text('最終結果を確認して良い？\n※全員の結果が見えてしまうよ'),
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
                                            builder: (context) =>
                                                const FinalPage()),
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
          ]),
        ),
      );
    });
  }

  Widget _getButtonWidget() {
    switch (currentPhase) {
      case 0:
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('気持ちを',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('確認する♡',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        );
      case 1:
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('結ばれたか',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('確認する',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        );
      case 2:
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('次の人を',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('確認する',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        );
      default:
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('気持ちを',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text('確認する♡',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        );
    }
  }

  // ボタン押下時の処理
  void _handleButtonPress() {
    if (currentPhase == 0) {
      _handleFeelingsCheck();
    } else if (currentPhase == 1) {
      _handleCoupleCheck();
    } else if (currentPhase == 2) {
      _resetAndStartNew();
    }
  }

  // 気持ち確認処理
  void _handleFeelingsCheck() {
    if (revealIndex != -1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('確認'),
            content:
                Text('${allMembers[revealIndex].name}$direction気持ちを確認しても良い？'),
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
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        isInputLocked = true; // 入力をロック
                        matchedLoves = allLoves
                            .where((Love love) => direction == "からの"
                                ? love.fromIndex == revealIndex
                                : love.toIndex == revealIndex)
                            .toList();
                        isOpened = true;
                        if (matchedLoves.isEmpty) {
                          currentPhase = 2; // 失敗時は次回リセット
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                icon: const Icon(
                                  Icons.sentiment_dissatisfied,
                                  color: Colors.orange,
                                  size: 48,
                                ),
                                title: const Text(
                                  '残念',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: const Text('気になる人はいなかったみたい...'),
                                backgroundColor: Colors.white,
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
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
                                    .findRenderObject() as RenderBox;
                            final RenderBox renderBoxTo =
                                globalKeys[love.toIndex]
                                    .currentContext!
                                    .findRenderObject() as RenderBox;
                            final RenderBox customPaintRenderBox =
                                _customPaintKey.currentContext!
                                    .findRenderObject() as RenderBox;

                            // CustomPaint領域でのグローバル座標を取得
                            final customPaintGlobalPosition =
                                customPaintRenderBox.localToGlobal(Offset.zero);

                            // 各要素のグローバル座標を取得
                            final fromGlobalPosition =
                                renderBoxFrom.localToGlobal(Offset.zero);
                            final toGlobalPosition =
                                renderBoxTo.localToGlobal(Offset.zero);

                            // CustomPaint内での相対座標に変換
                            final fromRelativePosition = Offset(
                              fromGlobalPosition.dx -
                                  customPaintGlobalPosition.dx,
                              fromGlobalPosition.dy -
                                  customPaintGlobalPosition.dy,
                            );
                            final toRelativePosition = Offset(
                              toGlobalPosition.dx -
                                  customPaintGlobalPosition.dx,
                              toGlobalPosition.dy -
                                  customPaintGlobalPosition.dy,
                            );

                            // 要素の中心点を計算
                            final centerPositionFrom =
                                fromRelativePosition.translate(
                              renderBoxFrom.size.width / 2,
                              renderBoxFrom.size.height / 2,
                            );
                            final centerPositionTo =
                                toRelativePosition.translate(
                              renderBoxTo.size.width / 2,
                              renderBoxTo.size.height / 2,
                            );

                            return Line(
                                startX: centerPositionFrom.dx,
                                startY: centerPositionFrom.dy,
                                endX: centerPositionTo.dx,
                                endY: centerPositionTo.dy);
                          }).toList();
                          _controller.forward(from: 0);
                          currentPhase = 1; // 次は結果確認フェーズ
                          Navigator.of(context).pop();
                        }
                      });
                    }
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
            icon: const Icon(
              Icons.warning,
              color: Colors.amber,
              size: 48,
            ),
            title: const Text(
              '選択してください',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text('誰の気持ちを確認するか決めてね！'),
            backgroundColor: Colors.white,
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
  }

  // カップル確認処理
  void _handleCoupleCheck() {
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
                var pickedMember = allMembers[matchedLoves[0].toIndex];
                var couple = getCouple(matchedLoves, pickedMember, allMembers);
                _showPopUp(context, couple);
                if (mounted) {
                  setState(() {
                    isOpened = false;
                    currentPhase = 2; // 次は「次の人を確認する」フェーズ
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  // リセットして新規開始
  void _resetAndStartNew() {
    setState(() {
      currentPhase = 0;
      revealIndex = -1;
      direction = "からの";
      isOpened = false;
      isInputLocked = false; // 入力ロックを解除
      lines.clear();
      matchedLoves.clear();
      _controller.reset(); // アニメーションもリセット
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
