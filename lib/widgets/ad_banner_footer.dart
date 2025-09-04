import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';

class AdBannerFooter extends StatefulWidget {
  const AdBannerFooter({Key? key}) : super(key: key);

  @override
  State<AdBannerFooter> createState() => _AdBannerFooterState();
}

class _AdBannerFooterState extends State<AdBannerFooter> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = AdService.instance.createBannerAd(
      onAdLoaded: (ad) {
        setState(() {
          _isAdLoaded = true;
        });
      },
      onAdFailedToLoad: (ad, error) {
        debugPrint('Failed to load banner ad: $error');
        ad.dispose();
        setState(() {
          _isAdLoaded = false;
        });
      },
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double reservedHeight =
        (_bannerAd?.size.height.toDouble() ?? AdSize.banner.height.toDouble());
    final double reservedWidth =
        (_bannerAd?.size.width.toDouble() ?? AdSize.banner.width.toDouble());

    return SizedBox(
      height: reservedHeight,
      child: Center(
        child: _isAdLoaded && _bannerAd != null
            ? SizedBox(
                width: reservedWidth,
                height: reservedHeight,
                child: AdWidget(ad: _bannerAd!),
              )
            : SizedBox(
                width: reservedWidth,
                height: reservedHeight,
              ),
      ),
    );
  }
}
