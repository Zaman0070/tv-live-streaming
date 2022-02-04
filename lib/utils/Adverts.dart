import 'dart:io';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:newsextra/providers/AppStateNotifier.dart';
import 'package:provider/provider.dart';

class Adverts {
  static String getFacebookInterstitalAdUnit() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return '1727952084060294_1738130529709116';
    }
    return null;
  }

  static String getFacebookBannerAdUnit() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return '1727952084060294_1738129999709169';
    }
    return null;
  }

  static String getFacebookNativeAdUnit() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return '1727952084060294_1738131336375702';
    }
    return null;
  }

  static String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-7089062487706875/5194460359';
    }
    return null;
  }

  static String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-7089062487706875/9731992233';
    }
    return null;
  }

  static String getAdmobNativeAds() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2247696110';
    } else {
      return 'ca-app-pub-7089062487706875/5465923097';
    }
  }
}

class AdmobNativeAds extends StatefulWidget {
  AdmobNativeAds({Key key}) : super(key: key);

  @override
  _AdmobNativeAdsState createState() => _AdmobNativeAdsState();
}

class _AdmobNativeAdsState extends State<AdmobNativeAds> {
  final _nativeAdController = NativeAdmobController();
  double _height = 0;
  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    if (_nativeAdController != null) _nativeAdController.dispose();
    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = 250;
        });
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Provider.of<AppStateNotifier>(context, listen: false).loadFacebookAds
          ? FacebookNativeAd(
              placementId: Adverts.getFacebookNativeAdUnit(),
              adType: NativeAdType.NATIVE_AD,
              width: double.infinity,
              height: 250,
              backgroundColor: Colors.white,
              titleColor: Colors.white,
              descriptionColor: Colors.white,
              buttonColor: Colors.deepPurple,
              buttonTitleColor: Colors.white,
              buttonBorderColor: Colors.white,
              keepAlive:
                  true, //set true if you do not want adview to refresh on widget rebuild
              keepExpandedWhileLoading:
                  false, // set false if you want to collapse the native ad view when the ad is loading
              expandAnimationDuraion:
                  250, //in milliseconds. Expands the adview with animation when ad is loaded
              listener: (result, value) {
                print("Native Ad: $result --> $value");
              },
            )
          : Container(
              height: _height,
              color: Colors.white,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 0.0, top: 15),
              child: NativeAdmob(
                adUnitID: Adverts.getAdmobNativeAds(),
                controller: _nativeAdController,
                loading: Container(),
                type: NativeAdmobType.full,
              ),
            ),
      Divider()
    ]);
  }
}
