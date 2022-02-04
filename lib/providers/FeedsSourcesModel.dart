import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../screens/ArticleViewerScreen.dart';
import '../utils/TimUtil.dart';
import '../utils/ApiUrl.dart';
import '../models/Articles.dart';
import '../models/ScreenArguements.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../utils/Adverts.dart';

class FeedsSourcesModel with ChangeNotifier {
  List<Articles> _items = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  ScrollController scrollController = new ScrollController();
  bool isError = false;
  String sortDate = '';
  bool isWidgetInit = false;
  AdmobInterstitial interstitialAd;
  bool isFacebookAds = false;
  bool isFacebookLoaded = false;
  bool isAdmobLoaded = false;
  bool _isDisposed = false;
  int source = 0;

  FeedsSourcesModel() {
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
          isFacebookLoaded = true;
        }
      },
    );
  }

  setWidgetsInit(bool status) {
    isWidgetInit = status;
  }

  loadArticleViewer(BuildContext context, int position) async {
    var count = await Navigator.pushNamed(
      context,
      ArticleViewerScreen.routeName,
      arguments: ScreenArguements(position: position, items: _items),
    );

    if (count == 0) {
      if (isFacebookAds) {
        if (isFacebookLoaded) {
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

  Future<void> setLastRefreshTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("article_last_refresh_time", TimUtil.currentTimeInSeconds());
  }

  fetchOnFirstLoad(int source) async {
    _items.clear();
    sortDate = "";
    notifyListeners();
    refreshController.requestRefresh();
    this.source = source;
    fetchArticles();
  }

  List<Articles> get items {
    return _items;
  }

  void setArticles(List<Articles> item) {
    _items.clear();
    _items = item;
    refreshController.refreshCompleted();
    isError = false;
    setLastRefreshTime();
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void setMoreArticles(List<Articles> item) {
    _items.addAll(item);
    refreshController.loadComplete();
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    //notifyListeners();
  }

  Future<void> fetchArticles() async {
    try {
      final response = await http.post(Uri.parse(ApiUrl.SOURCEARTICLES),
          body: jsonEncode({
            "data": {"source": source}
          }));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final res = jsonDecode(response.body);
        sortDate = res["date"];
        final parsed = res["feeds"].cast<Map<String, dynamic>>();
        List<Articles> articles =
            parsed.map<Articles>((json) => Articles.fromJson(json)).toList();
        setArticles(articles);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setArticleFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setArticleFetchError();
    }
  }

  setArticleFetchError() {
    _items = [];
    refreshController.refreshFailed();
    isError = true;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> fetchMoreArticles() async {
    try {
      final response = await http.post(Uri.parse(ApiUrl.SOURCEARTICLES),
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
        final parsed = res["feeds"].cast<Map<String, dynamic>>();
        List<Articles> articles =
            parsed.map<Articles>((json) => Articles.fromJson(json)).toList();
        setMoreArticles(articles);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        refreshController.refreshFailed();
        if (!_isDisposed) {
          notifyListeners();
        }
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      refreshController.loadFailed();
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }
}
