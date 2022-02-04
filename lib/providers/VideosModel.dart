import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../screens/VideoViewerScreen.dart';
import '../models/ScreenArguements.dart';
import '../utils/ApiUrl.dart';
import '../models/Videos.dart';
import '../utils/SQLiteDbProvider.dart';
import '../utils/TimUtil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../utils/Adverts.dart';

class VideosModel with ChangeNotifier {
  List<Videos> _items = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isError = false;
  String location = 'wo';
  String sortDate = '';
  String currentCategory = "All Stories";
  List<String> selectedcats = [];
  List<int> unfollowedFeedSources = [];
  bool isWidgetInit = false;
  AdmobInterstitial interstitialAd;
  bool isFacebookLoaded = false;
  bool isAdmobLoaded = false;
  bool isFacebookAds = false;

  VideosModel() {
    getDatabaseVideos();
    getUserLocation();
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

  setCategories(List<String> selectedcats) {
    this.selectedcats = selectedcats;
  }

  refreshPageOnCategorySelected(String val) {
    if (val != currentCategory && isWidgetInit) {
      currentCategory = val;
      refreshController.requestRefresh();
    }
  }

  Future<void> setLastRefreshTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("video_last_refresh_time", TimUtil.currentTimeInSeconds());
  }

  fetchOnFirstLoad(String currentCategory) async {
    int lastRefresh = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("video_last_refresh_time") != null) {
      lastRefresh = prefs.getInt("video_last_refresh_time");
    }
    if (this.currentCategory != currentCategory ||
        _items.length == 0 ||
        lastRefresh == 0 ||
        TimUtil.verifyIfScreenShouldReloadData(lastRefresh)) {
      print("Load data now");
      this.currentCategory = currentCategory;
      refreshController.requestRefresh();
      fetchArticles();
    }
  }

  getUserLocation() async {
    try {
      location = await FlutterSimCountryCode.simCountryCode;
      print("location= " + location);
    } catch (e) {
      location = 'wo';
      print("location= " + location);
    }
  }

  getDatabaseVideos() async {
    /*List<Videos> itms = await SQLiteDbProvider.db.getAllVideos();
    if (itms.length > 0) {
      _items = itms;
    }
    notifyListeners();*/
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

  void setVideos(List<Videos> item) {
    _items = item;
    //  SQLiteDbProvider.db.deleteAllVideos();
    //  SQLiteDbProvider.db.insertBatchVideos(item);
    refreshController.refreshCompleted();
    isError = false;
    setLastRefreshTime();
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

  Future<void> getUnfollowedSources() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("unfollowedvideosources") != null) {
      unfollowedFeedSources =
          json.decode(prefs.getString("unfollowedvideosources")).cast<int>();
    }
  }

  Future<void> fetchArticles() async {
    await getUnfollowedSources();

    try {
      var _data = {
        "interests":
            currentCategory == "All Stories" ? selectedcats : [currentCategory],
        "location": location.toLowerCase()
      };
      if (unfollowedFeedSources.length > 0) {
        _data = {
          "interests": currentCategory == "All Stories"
              ? selectedcats
              : [currentCategory],
          "sources": unfollowedFeedSources,
          "location": location.toLowerCase()
        };
      }
      var data = jsonEncode({"data": _data});
      print("video data = " + data.toString());
      final response = await http.post(Uri.parse(ApiUrl.VIDEOS), body: data);
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
    if (currentCategory != "All Stories") {
      _items = [];
      SQLiteDbProvider.db.deleteAllVideos();
    }
    refreshController.refreshFailed();
    isError = true;
    notifyListeners();
  }

  Future<void> fetchMoreArticles() async {
    await getUnfollowedSources();
    try {
      var _data = {
        "interests":
            currentCategory == "All Stories" ? selectedcats : [currentCategory],
        "location": location.toLowerCase(),
        "date": sortDate,
        "offset": items.length + 1
      };
      if (unfollowedFeedSources.length > 0) {
        _data = {
          "interests": currentCategory == "All Stories"
              ? selectedcats
              : [currentCategory],
          "sources": unfollowedFeedSources,
          "location": location.toLowerCase(),
          "date": sortDate,
          "offset": items.length + 1
        };
      }
      var data = jsonEncode({"data": _data});
      print("video data = " + data.toString());
      final response = await http.post(Uri.parse(ApiUrl.VIDEOS), body: data);
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
