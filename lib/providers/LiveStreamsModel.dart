import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:newsextra/models/Country.dart';
import 'package:newsextra/utils/SQLiteDbProvider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../utils/ApiUrl.dart';
import '../models/LiveStreams.dart';

class LiveStreamsModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  List<LiveStreams> _items = [];
  int page = 1;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  LiveStreamsModel() {
    //loadItems();
  }

  List<LiveStreams> get items {
    return _items;
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

  Future<void> fetchItems() async {
    Country selectedCountry = await SQLiteDbProvider.db.getCountryData();
    try {
      final dio = Dio();

      final response = await dio.post(
        ApiUrl.LIVESTREAMS,
        data: jsonEncode({
          "data": {
            "country": selectedCountry == null ? 0 : selectedCountry.id,
            "page": page
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.data);
        dynamic res = jsonDecode(response.data);
        List<LiveStreams> _livestreams = parseLiveStreams(res);
        if (page == 0) {
          setItems(_livestreams);
        } else {
          setMoreItems(_livestreams);
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

  static List<LiveStreams> parseLiveStreams(dynamic res) {
    //final res = jsonDecode(responseBody);
    final parsed = res["livestreams"].cast<Map<String, dynamic>>();
    return parsed
        .map<LiveStreams>((json) => LiveStreams.fromJson(json))
        .toList();
  }

  void setItems(List<LiveStreams> item) {
    _items = item;
    //SQLiteDbProvider.db.deleteAllRadio();
    //SQLiteDbProvider.db.insertBatchRadio(item);
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<LiveStreams> item) {
    _items.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  setFetchError() {
    isError = true;
    notifyListeners();
  }
}
