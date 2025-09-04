import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import './choosePage.dart';
import './couplingPage.dart';
import '../models/member.dart';
import '../services/ad_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../widgets/ad_banner_footer.dart';

class MatchGuidePage extends StatefulWidget {
  const MatchGuidePage({Key? key}) : super(key: key);

  @override
  State<MatchGuidePage> createState() => _MatchGuidePageState();
}

class _MatchGuidePageState extends State<MatchGuidePage> {
  bool _isLoadingAd = false;

  Future<void> _showInterstitialAdAndNavigate(BuildContext context) async {
    setState(() {
      _isLoadingAd = true;
    });

    try {
      // インターステイシャル広告を読み込み
      final InterstitialAd? interstitialAd =
          await AdService.loadInterstitialAd();

      if (mounted) {
        setState(() {
          _isLoadingAd = false;
        });

        // 広告を表示し、閉じられたらページ遷移
        await AdService.showInterstitialAd(
          interstitialAd,
          onAdClosed: () {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CouplingPage()),
              );
            }
          },
        );
      }
    } catch (error) {
      // 広告の読み込みに失敗した場合、直接遷移
      if (mounted) {
        setState(() {
          _isLoadingAd = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CouplingPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final deviceSize = MediaQuery.of(context).size;
      final int index = ref.watch(memberIndexProvider);
      final allMembers = ref.watch(membersProvider);

      Widget buildScaffold(Member chooser, String text, Function onPressed) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: deviceSize.width,
                          child: Text(
                            text,
                            style: const TextStyle(
                              fontFamily: 'Bebas Neue',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: chooser.image.startsWith('assets/')
                              ? Image.asset(chooser.image, fit: BoxFit.cover)
                              : Image.file(File(chooser.image),
                                  fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 30.0),
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
                          onPressed: onPressed as void Function()?,
                          child: const Text('次に進む'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoadingAd)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '広告を読み込み中...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: const AdBannerFooter(),
        );
      }

      if (index >= ref.watch(memberNumProvider)) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: deviceSize.width,
                          child: const Text(
                            '全員の登録が完了したよ！\n結果はどうかな〜♡',
                            style: TextStyle(
                              fontFamily: 'Bebas Neue',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30.0),
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
                          onPressed: _isLoadingAd
                              ? null
                              : () => _showInterstitialAdAndNavigate(context),
                          child: const Text('次に進む'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoadingAd)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '広告を読み込み中...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: const AdBannerFooter(),
        );
      } else {
        // 配列の範囲外アクセスを防ぐ
        if (allMembers.isEmpty || index >= allMembers.length || index < 0) {
          return const Scaffold(
            body: Center(
              child: Text('参加者データが見つかりません'),
            ),
            bottomNavigationBar: AdBannerFooter(),
          );
        }

        Member chooser = allMembers[index];
        final bool isTest = ref.watch(isTestModeProvider);
        if (isTest) {
          return buildScaffold(
            chooser,
            '${chooser.name}さん\n気になる相手を選んでね♡',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChoosePage(),
                ),
              );
            },
          );
        }
        return ref.watch(cameraProvider).when(
              data: (camera) {
                return buildScaffold(
                  chooser,
                  '${chooser.name}さん\n気になる相手を選んでね♡',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChoosePage(),
                      ),
                    );
                  },
                );
              },
              loading: () {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                  bottomNavigationBar: AdBannerFooter(),
                );
              },
              error: (err, stack) => const Scaffold(
                body: Center(child: Text('Error: カメラの初期化に失敗しました')),
                bottomNavigationBar: AdBannerFooter(),
              ),
            );
      }
    });
  }
}
