import 'dart:io';
import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdService {
  static AdService? _instance;
  static AdService get instance => _instance ??= AdService._internal();

  AdService._internal();

  // バナー広告ID
  String get bannerAdUnitId {
    if (kDebugMode) {
      // テスト用広告ID
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    } else {
      // 本番用広告ID
      return 'ca-app-pub-6257323478670896/6388328573';
    }
  }

  // インターステイシャル広告ID
  String get interstitialAdUnitId {
    if (kDebugMode) {
      // テスト用広告ID
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
    } else {
      // 本番用広告ID
      return 'ca-app-pub-6257323478670896/1136001897';
    }
  }

  // AdMobの初期化
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // バナー広告の作成
  BannerAd createBannerAd({
    required Function(Ad ad) onAdLoaded,
    required Function(Ad ad, LoadAdError error) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (Ad ad) => debugPrint('$ad opened.'),
        onAdClosed: (Ad ad) => debugPrint('$ad closed.'),
        onAdImpression: (Ad ad) => debugPrint('$ad impression.'),
      ),
    );
  }

  // インターステイシャル広告のロード
  static Future<InterstitialAd?> loadInterstitialAd() async {
    final Completer<InterstitialAd?> completer = Completer<InterstitialAd?>();

    InterstitialAd.load(
      adUnitId: AdService.instance.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('InterstitialAd loaded.');
          if (!completer.isCompleted) completer.complete(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );

    // タイムアウト保護
    try {
      return await completer.future
          .timeout(const Duration(seconds: 10), onTimeout: () => null);
    } catch (_) {
      return null;
    }
  }

  // インターステイシャル広告の表示
  static Future<void> showInterstitialAd(
    InterstitialAd? ad, {
    Function()? onAdClosed,
  }) async {
    if (ad == null) {
      debugPrint('Attempted to show interstitial ad but it was null.');
      onAdClosed?.call();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        debugPrint('Interstitial ad showed full screen content.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('Interstitial ad dismissed full screen content.');
        ad.dispose();
        onAdClosed?.call();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint(
            'Interstitial ad failed to show full screen content: $error');
        ad.dispose();
        onAdClosed?.call();
      },
    );

    await ad.show();
  }
}
