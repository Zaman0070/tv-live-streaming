import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:newsextra/models/Categories.dart';
import 'package:newsextra/models/Country.dart';
import 'package:newsextra/models/Userdata.dart';
import 'package:newsextra/utils/my_colors.dart';
import '../screens/ArticleViewerScreen.dart';
import '../utils/TimUtil.dart';
import '../utils/ApiUrl.dart';
import '../models/Articles.dart';
import '../utils/SQLiteDbProvider.dart';
import '../models/ScreenArguements.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../utils/Adverts.dart';

class ArticlesModel with ChangeNotifier {
  List<Articles> _items = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  ScrollController scrollController = new ScrollController();
  bool isError = false;
  int country = 0;
  String sortDate = '';
  String currentCategory = "All Stories";
  List<int> selectedcats = [];
  List<int> unfollowedFeedSources = [];
  bool isWidgetInit = false;
  AdmobInterstitial interstitialAd;
  bool isFacebookLoaded = false;
  bool isAdmobLoaded = false;
  bool _isDisposed = false;
  Userdata userdata;
  bool isFacebookAds = false;

  ArticlesModel() {
    print("init articles mode;= ");
    getDatabaseArticles();
    getUserLocation();
    loadInterstitialAds();
    loadFacebookAds();
    getWhichAdNetworkToLoad();
    //fetchOnFirstLoad();
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

  getDatabaseCategories() async {
    selectedcats = [];
    List<Categories> dbcategories =
        await SQLiteDbProvider.db.getAllCategories();
    for (var itm in dbcategories) {
      selectedcats.add(itm.id);
    }
    //notifyListeners();
  }

  setCategories(List<int> selectedcats) {
    this.selectedcats = selectedcats;
  }

  refreshPageOnCategorySelected(String val) {
    print("currentCategory = " + currentCategory);
    print("val = " + val);
    if (val != currentCategory && isWidgetInit) {
      currentCategory = val;
      refreshController.requestRefresh();
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  loadArticleViewer(BuildContext context, int position) async {
    /*var count = await Navigator.pushNamed(
      context,
      ArticleViewerScreen.routeName,
      arguments: ScreenArguements(position: position, items: _items),
    );*/
    await FlutterWebBrowser.openWebPage(
      url: _items[position].link,
      customTabsOptions: CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        toolbarColor: MyColors.primary,
        secondaryToolbarColor: MyColors.primary,
        navigationBarColor: MyColors.primary,
        addDefaultShareMenuItem: true,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: MyColors.primary,
        preferredControlTintColor: MyColors.primary,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );

    //if (count == 0) {
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
    //}
  }

  Future<void> setLastRefreshTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("article_last_refresh_time", TimUtil.currentTimeInSeconds());
  }

  getUserData() async {
    userdata = await SQLiteDbProvider.db.getUserData();
  }

  fetchOnFirstLoad() async {
    await getUserData();
    await getUserLocation();
    await getDatabaseCategories();
    int lastRefresh = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("article_last_refresh_time") != null) {
      lastRefresh = prefs.getInt("article_last_refresh_time");
    }
    if (_items.length == 0 ||
        lastRefresh == 0 ||
        TimUtil.verifyIfScreenShouldReloadData(lastRefresh)) {
      refreshController.requestRefresh();
      fetchArticles();
    }
  }

  getUserLocation() async {
    Country _country = await SQLiteDbProvider.db.getCountryData();
    if (_country != null) {
      country = _country.id;
    }
  }

  getDatabaseArticles() async {
    /* List<Articles> itms = await SQLiteDbProvider.db.getAllArticles();
    if (itms.length > 0) {
      _items = itms;
    }
    notifyListeners();*/
  }

  List<Articles> get items {
    return _items;
  }

  void setArticles(List<Articles> item) {
    _items.clear();
    _items = item;
    // SQLiteDbProvider.db.deleteAllArticles();
    // SQLiteDbProvider.db.insertBatchArticles(item);
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

  Future<void> getUnfollowedSources() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("unfollowedfeedsources") != null) {
      unfollowedFeedSources =
          json.decode(prefs.getString("unfollowedfeedsources")).cast<int>();
    }
  }

  Future<void> fetchArticles() async {
    await getUnfollowedSources();
    print("cats size = " + selectedcats.length.toString());
    try {
      var data = {
        "interests":
            currentCategory == "All Stories" ? selectedcats : [currentCategory],
        "country": country,
      };
      if (unfollowedFeedSources.length > 0) {
        data = {
          "interests": currentCategory == "All Stories"
              ? selectedcats
              : [currentCategory],
          "country": country,
          "sources": unfollowedFeedSources,
        };
      }
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.ARTICLES),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
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
    if (currentCategory != "All Stories") {
      _items = [];
      SQLiteDbProvider.db.deleteAllArticles();
    }
    refreshController.refreshFailed();
    isError = true;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> fetchMoreArticles() async {
    await getUnfollowedSources();
    try {
      var data = {
        "interests":
            currentCategory == "All Stories" ? selectedcats : [currentCategory],
        "country": country,
        "date": sortDate,
        "offset": items.length + 1
      };
      if (unfollowedFeedSources.length > 0) {
        data = {
          "interests": currentCategory == "All Stories"
              ? selectedcats
              : [currentCategory],
          "sources": unfollowedFeedSources,
          "country": country,
          "date": sortDate,
          "offset": items.length + 1
        };
      }
      final response = await http.post(Uri.parse(ApiUrl.ARTICLES),
          body: jsonEncode({"data": data}));
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
        refreshController.loadFailed();
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
