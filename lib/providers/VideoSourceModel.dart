import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/VideoViewerScreen.dart';
import '../models/ScreenArguements.dart';
import '../utils/ApiUrl.dart';
import '../models/Videos.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../utils/Adverts.dart';

class VideoSourceModel with ChangeNotifier {
  List<Videos> _items = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isError = false;
  String sortDate = '';
  bool isWidgetInit = false;
  AdmobInterstitial interstitialAd;
  bool isFacebookAds = false;
  bool isAdmobLoaded = false;
  int source = 0;

  VideoSourceModel() {
    loadInterstitialAds();
    loadFacebookAds();
    getWhichAdNetworkToLoad();
  }

  getWhichAdNetworkToLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("which_ad_network_to_load") != null) {
      isFacebookAds = prefs.getBool("which_ad_network_to_load");
    }
  }

  void loadInterstitialAds() {
    interstitialAd = AdmobInterstitial(
      adUnitId: Adverts.getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        print("interstital event" + event.toString());
        if (event == AdmobAdEvent.loaded) isAdmobLoaded = true; //
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    interstitialAd.load();
  }

  void loadFacebookAds() {
    FacebookAudienceNetwork.loadInterstitialAd(
      placementId: Adverts.getFacebookInterstitalAdUnit(),
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          isFacebookAds = true;
        }
      },
    );
  }

  setWidgetsInit(bool status) {
    isWidgetInit = status;
  }

  fetchOnFirstLoad(int source) async {
    refreshController.requestRefresh();
    this.source = source;
    fetchArticles();
  }

  /// An unmodifiable view of the items in the cart.
  List<Videos> get items {
    return _items;
  }

  loadVideoViewer(BuildContext context, int position) async {
    var count = await Navigator.pushNamed(
      context,
      VideoViewerScreen.routeName,
      arguments: ScreenArguements(position: position, items: _items),
    );

    if (count == 0) {
      if (isFacebookAds) {
        if (isFacebookAds) {
          FacebookInterstitialAd.showInterstitialAd(delay: 0);
          loadFacebookAds();
        }
      } else {
        if (isAdmobLoaded) {
          interstitialAd.show();
          interstitialAd.load();
        }
      }
    }
  }

  void setVideos(List<Videos> item) {
    _items = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreVideos(List<Videos> item) {
    _items.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    //notifyListeners();
  }

  Future<void> fetchArticles() async {
    try {
      var data = jsonEncode({
        "data": {"source": source}
      });
      print("video data = " + data.toString());
      final response =
          await http.post(Uri.parse(ApiUrl.SOURCEVIDEOS), body: data);
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final res = jsonDecode(response.body);
        sortDate = res["date"];
        final parsed = res["videos"].cast<Map<String, dynamic>>();
        List<Videos> videos =
            parsed.map<Videos>((json) => Videos.fromJson(json)).toList();
        setVideos(videos);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setVideoFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setVideoFetchError();
    }
  }

  setVideoFetchError() {
    refreshController.refreshFailed();
    isError = true;
    notifyListeners();
  }

  Future<void> fetchMoreArticles() async {
    try {
      final response = await http.post(Uri.parse(ApiUrl.SOURCEVIDEOS),
          body: jsonEncode({
            "data": {
              "source": source,
              "date": sortDate,
              "offset": items.length + 1
            }
          }));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final res = jsonDecode(response.body);
        final parsed = res["videos"].cast<Map<String, dynamic>>();
        List<Videos> videos =
            parsed.map<Videos>((json) => Videos.fromJson(json)).toList();
        setMoreVideos(videos);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        refreshController.refreshFailed();
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      refreshController.loadFailed();
      notifyListeners();
    }
  }
}
