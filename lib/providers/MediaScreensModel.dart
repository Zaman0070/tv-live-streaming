import 'package:flutter/foundation.dart';
import 'package:newsextra/models/Country.dart';
import 'package:newsextra/utils/SQLiteDbProvider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:dio/dio.dart';
import '../utils/ApiUrl.dart';
import '../models/Userdata.dart';
import '../models/Media.dart';

class MediaScreensModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  Userdata userdata;
  List<Media> mediaList = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;
  int country = 0;

  MediaScreensModel() {
    this.mediaList = [];
    getUserData();
    //notifyListeners();
  }

  getUserData() async {
    userdata = await SQLiteDbProvider.db.getUserData();
    print("userdata " + userdata.toString());
    notifyListeners();
  }

  getUserLocation() async {
    Country _country = await SQLiteDbProvider.db.getCountryData();
    if (_country != null) {
      country = _country.id;
    }
  }

  loadItems() {
    page = 0;
    refreshController.requestRefresh();
    notifyListeners();
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Media> item) {
    mediaList.clear();
    mediaList = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Media> item) {
    mediaList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    await getUserData();
    await getUserLocation();
    try {
      final dio = Dio();

      final response = await dio.post(
        ApiUrl.FETCH_MEDIA,
        data: jsonEncode({
          "data": {
            "email": userdata == null ? "null" : userdata.email,
            "version": "v2",
            "page": page.toString(),
            "country": country
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        dynamic res = jsonDecode(response.data);
        List<Media> mediaList = parseSliderMedia(res);
        if (page == 0) {
          setItems(mediaList);
        } else {
          setMoreItems(mediaList);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setFetchError();
    }
  }

  static List<Media> parseSliderMedia(dynamic res) {
    //final res = jsonDecode(responseBody);
    final parsed = res["media"].cast<Map<String, dynamic>>();
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  setFetchError() {
    if (page == 0) {
      isError = true;
      refreshController.refreshFailed();
      notifyListeners();
    } else {
      refreshController.loadFailed();
      notifyListeners();
    }
  }
}
