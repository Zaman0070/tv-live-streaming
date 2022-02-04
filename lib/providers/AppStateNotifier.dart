import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:newsextra/models/Country.dart';
import 'package:newsextra/models/Radios.dart';
import 'package:newsextra/utils/Alerts.dart';
import 'package:newsextra/utils/ApiUrl.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import '../models/Userdata.dart';
import '../models/Categories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/SQLiteDbProvider.dart';
import '../utils/langs.dart';
import '../i18n/strings.g.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class AppStateNotifier with ChangeNotifier {
  bool isDarkModeOn = false;
  bool loadArticlesImages = true;
  bool loadSmallImages = true;
  bool isLoadingTheme = true;
  bool isRtlEnabled = false;
  bool isUserSeenOnboardingPage = false;
  bool isReceievePushNotifications = true;
  Userdata userdata;
  String currentCategory = "All Stories";
  List<int> selectedcats = [];
  List<Categories> dbcategories = [];
  int preferredLanguage = 0;
  final _langPreference = "language_preference";
  Country selectedCountry;
  bool loadFacebookAds = false;
  BuildContext context;

  AppStateNotifier() {
    loadAppTheme();
    getPreferedLanguage();
    getDatabaseCategories();
    getLoadArticlesImages();
    getLoadSmallImages();
    getRtlEnabled();
    getRecieveNotifications();
    getUserData();
    getSelectedCountry();
    getWhichAdNetworkToLoad();
    fetchAdNetwork();
  }

  setContext(BuildContext context) {
    this.context = context;
  }

  getWhichAdNetworkToLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("which_ad_network_to_load") != null) {
      loadFacebookAds = prefs.getBool("which_ad_network_to_load");
    }
  }

  setWhichAdNetworkToLoad(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loadFacebookAds = value;
    prefs.setBool("which_ad_network_to_load", value);
    notifyListeners();
  }

  getSelectedCountry() async {
    selectedCountry = await SQLiteDbProvider.db.getCountryData();
    print(" from app state = " + selectedCountry.toString());
  }

  Future<Country> getSelectedCountryFirebase() async {
    //Country country;
    var snapshot = await SQLiteDbProvider.db.getCountryData();
    return snapshot;
  }

  getUserSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("user_seen_onboarding_page") != null) {
      isUserSeenOnboardingPage = prefs.getBool("user_seen_onboarding_page");
    }
  }

  setUserSeenOnboardingPage(bool seen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("user_seen_onboarding_page", seen);
  }

  getDatabaseCategories() async {
    selectedcats = [];
    dbcategories = await SQLiteDbProvider.db.getAllCategories();
    for (var itm in dbcategories) {
      selectedcats.add(itm.id);
    }
    //notifyListeners();
  }

  chooseCategory(String val) {
    if (val != currentCategory) {
      currentCategory = val;
      notifyListeners();
    }
  }

  getPreferedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      //load app language
      preferredLanguage = prefs.getInt(_langPreference) ?? 0;
    } catch (e) {
      // quietly pass
    }
    LocaleSettings.setLocale(
        appLanguageData[AppLanguage.values[preferredLanguage]]['value']);
  }

  //app language setting
  setAppLanguage(int index) async {
    //AppLanguage _preferredLanguage = AppLanguage.values[index];
    preferredLanguage = index;
    LocaleSettings.setLocale(
        appLanguageData[AppLanguage.values[index]]['value']);
    // Here we notify listeners that theme changed
    // so UI have to be rebuild
    notifyListeners();
    // Save selected theme into SharedPreferences
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(_langPreference, preferredLanguage);
  }

  getUserData() async {
    userdata = await SQLiteDbProvider.db.getUserData();
    print("userdata " + userdata.toString());
    notifyListeners();
  }

  setUserData(Userdata _userdata) async {
    await SQLiteDbProvider.db.deleteUserData();
    await SQLiteDbProvider.db.insertUser(_userdata);
    this.userdata = _userdata;
    notifyListeners();
  }

  unsetUserData() async {
    await SQLiteDbProvider.db.deleteUserData();
    this.userdata = null;
    notifyListeners();
  }

  loadAppTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("app_theme") != null) {
      isDarkModeOn = prefs.getBool("app_theme");
    }
    isLoadingTheme = false;
    notifyListeners();
  }

  getAppTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("app_theme") != null) {
      isDarkModeOn = prefs.getBool("app_theme");
    }
    return isDarkModeOn;
  }

  setAppTheme(bool theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkModeOn = theme;
    prefs.setBool("app_theme", theme);
    notifyListeners();
  }

  getLoadArticlesImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("load_article_images") != null) {
      loadArticlesImages = prefs.getBool("load_article_images");
    }
    return loadArticlesImages;
  }

  setLoadArticlesImages(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loadArticlesImages = value;
    prefs.setBool("load_article_images", value);
    notifyListeners();
  }

  getLoadSmallImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("load_small_article_images") != null) {
      loadSmallImages = prefs.getBool("load_small_article_images");
    }
    return loadArticlesImages;
  }

  setLoadSmallImages(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loadSmallImages = value;
    prefs.setBool("load_small_article_images", value);
    notifyListeners();
  }

  getRtlEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("rtl_enabled") != null) {
      isRtlEnabled = prefs.getBool("rtl_enabled");
    }
    return isRtlEnabled;
  }

  setRtlEnabled(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isRtlEnabled = value;
    prefs.setBool("rtl_enabled", value);
    notifyListeners();
  }

  getRecieveNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("receieve_notifications") != null) {
      isReceievePushNotifications = prefs.getBool("receieve_notifications");
    }
    return isReceievePushNotifications;
  }

  setRecieveNotifications(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isReceievePushNotifications = value;
    prefs.setBool("receieve_notifications", value);
    notifyListeners();
  }

  Future<void> fetchAdNetwork() async {
    try {
      final response = await http.get(
        Uri.parse(ApiUrl.getAdNetwork),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        final res = jsonDecode(response.body);
        String adnetwork = res["ad_network"];
        if (adnetwork == "facebook") {
          setWhichAdNetworkToLoad(true);
        } else {
          setWhichAdNetworkToLoad(false);
        }
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  Future<void> reportComment(Radios radios, String reason) async {
    Alerts.showProgressDialog(context, StringsUtils.reportingRadio);
    try {
      var data = {
        "id": radios.id,
        "title": radios.title,
        "reason": reason,
      };
      print(data.toString());
      final response = await http.post(Uri.parse(ApiUrl.REPORTRADIO),
          body: jsonEncode({"data": data}));
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.body);
        print(res);
        String _status = res["status"];
        if (_status == "ok") {
          Alerts.showCupertinoAlert(
              context, t.success, StringsUtils.successReportingRadio);
        } else {
          processingErrorMessage(context, StringsUtils.errorReportingRadio);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        processingErrorMessage(context, StringsUtils.errorReportingRadio);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      processingErrorMessage(context, StringsUtils.errorReportingRadio);
    }
  }

  processingErrorMessage(BuildContext context, String msg) {
    Navigator.of(context).pop();
    Alerts.showCupertinoAlert(context, t.error, msg);
  }
}
