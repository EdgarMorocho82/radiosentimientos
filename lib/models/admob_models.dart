import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:radioxr/constants/config.dart';

class AdmobService {
  static final _adUnit =
      Platform.isAndroid ? Config.admobAndroidAdUnit : Config.admobIosAdUnit;

  static Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  static final _listener = BannerAdListener(
    onAdLoaded: (Ad ad) => debugPrint('Ad loaded.'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      debugPrint('onAdFailedToLoad: ${error.message}');
      ad.dispose();
    },
    onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
    onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
  );

  static final _bannerAd = BannerAd(
      adUnitId: _adUnit,
      size: const AdSize(width: 320, height: 50),
      request: const AdRequest(nonPersonalizedAds: true),
      listener: _listener)
    ..load();

  static final banner = Container(
    alignment: Alignment.center,
    width: _bannerAd.size.width.toDouble(),
    height: _bannerAd.size.height.toDouble(),
    child: AdWidget(key: UniqueKey(), ad: _bannerAd),
  );
}
