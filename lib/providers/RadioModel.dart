import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsextra/i18n/strings.g.dart';
import 'package:newsextra/models/Country.dart';
import 'package:newsextra/utils/Alerts.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import '../utils/ApiUrl.dart';
import '../utils/Parsers.dart';
import '../models/Radios.dart';
import '../utils/TimUtil.dart';
import '../utils/SQLiteDbProvider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RadioModel with ChangeNotifier {
  List<Radios> _items = [];
  bool isError = false;
  int country = 0;
  int page = 1;
  BuildContext context;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  RadioModel(BuildContext context) {
    this.context = context;
    //getDatabaseRadio();
    //fetchRadio();
    getUserLocation();
  }

  getUserLocation() async {
    Country _country = await SQLiteDbProvider.db.getCountryData();
    if (_country != null) {
      country = _country.id;
    }
  }

//fetch radio, display list
  Future<void> setLastRefreshTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("radio_last_refresh_time", TimUtil.currentTimeInSeconds());
  }

  fetchOnFirstLoad() async {
    page = 0;
    refreshController.requestRefresh();
    notifyListeners();
    fetchRadio();
  }

  loadMoreItems() {
    page = page + 1;
    fetchRadio();
  }

  getDatabaseRadio() async {
    _items = await SQLiteDbProvider.db.getAllRadio();
    notifyListeners();
  }

  /// An unmodifiable view of the items.
  List<Radios> get items {
    return _items;
  }

  void setRadios(List<Radios> item) {
    _items = item;
    //SQLiteDbProvider.db.deleteAllRadio();
    //SQLiteDbProvider.db.insertBatchRadio(item);
    refreshController.refreshCompleted();
    isError = false;
    setLastRefreshTime();
    _items.sort((a, b) {
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    notifyListeners();
  }

  Future<void> fetchRadio() async {
    try {
      final response = await http.post(Uri.parse(ApiUrl.RADIO),
          body: jsonEncode({
            "data": {"country": country, "page": page}
          }));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        List<Radios> cats = await compute(Parsers.parseRadios, response.body);
        print(cats.toString());
        if (page == 0) {
          setRadios(cats);
        } else {
          setMoreItems(cats);
        }
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

  void setMoreItems(List<Radios> item) {
    _items.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  setArticleFetchError() {
    if (page == 0) {
      if (_items.length == 0) {
        refreshController.refreshFailed();
        isError = true;
      }
    } else {
      refreshController.loadFailed();
      notifyListeners();
    }
  }
}
