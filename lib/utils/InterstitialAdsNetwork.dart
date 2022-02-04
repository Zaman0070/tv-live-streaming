import 'package:shared_preferences/shared_preferences.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../utils/Adverts.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

class InterstitialAdsNetwork {
  AdmobInterstitial interstitialAd;

  InterstitialAdsNetwork() {
    //getWhichAdNetworkToLoad();
  }

  initAds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("number_of_items_to_load_ads") != null) {
      int count = prefs.getInt("number_of_items_to_load_ads");
      print("count is  = " + count.toString());
      if (count == 0 || count >= 5) {
        loadAds();
        incrementCount(count);
      } else {
        incrementCount(count);
      }
    } else {
      loadAds();
      incrementCount(0);
    }
  }

  void incrementCount(int count) async {
    count = count >= 5 ? 1 : (count + 1);
    print("new count is = " + count.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("number_of_items_to_load_ads", count);
  }

  void loadAds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("which_ad_network_to_load") != null) {
      bool isFacebookAds = prefs.getBool("which_ad_network_to_load");
      if (isFacebookAds) {
        loadFacebookAds();
      } else {
        loadInterstitialAds();
      }
    }
  }

  void loadInterstitialAds() {
    interstitialAd = AdmobInterstitial(
      adUnitId: Adverts.getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        print("interstital event" + event.toString());
        if (event == AdmobAdEvent.loaded) interstitialAd.show();
      },
    );
    interstitialAd.load();
  }

  void loadFacebookAds() {
    FacebookAudienceNetwork.loadInterstitialAd(
      placementId: Adverts.getFacebookInterstitalAdUnit(),
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          FacebookInterstitialAd.showInterstitialAd(delay: 0);
        }
      },
    );
  }
}
