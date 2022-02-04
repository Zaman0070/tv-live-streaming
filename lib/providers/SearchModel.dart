import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:newsextra/models/LiveStreams.dart';
import 'package:newsextra/models/Media.dart';
import 'package:newsextra/models/Radios.dart';
import 'package:newsextra/utils/Parsers.dart';
import '../screens/ArticleViewerScreen.dart';
import '../models/ScreenArguements.dart';
import '../utils/ApiUrl.dart';
import '../models/Search.dart';
import '../models/Articles.dart';
import '../models/Videos.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

class SearchModel with ChangeNotifier {
  List<Object> _items = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isError = false;
  bool isLoading = false;
  bool isIdle = true;
  static bool isFirstLoad = false;
  String location = 'wo';
  static String sortDate = '';
  String query = "";
  int index = 0;

  SearchModel() {
    getUserLocation();
    //fetchOnFirstLoad();
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

  List<Object> get items {
    return _items;
  }

  setIndex(int index) {
    this.index = index;
    _items = [];
    notifyListeners();
  }

  loadSearchViewer(BuildContext context, int position) {
    if (index == 0) {
      Search search = items[position];
      Navigator.pushNamed(
        context,
        ArticleViewerScreen.routeName,
        arguments: getArticlesList(search.id),
      );
    } else {}
  }

  ScreenArguements getArticlesList(int id) {
    List<Articles> itms = [];
    int position = 0;
    for (Search search in items) {
      if (search.type.toLowerCase() == "article") {
        Articles articles = Articles.fromSearch(search);
        itms.add(articles);
        if (search.id == id) {
          position = itms.indexOf(articles);
        }
      }
    }
    return ScreenArguements(position: position, items: itms);
  }

  ScreenArguements getVideosList(int id) {
    List<Videos> itms = [];
    int position = 0;
    for (Search search in items) {
      if (search.type.toLowerCase() == "article") {
        Videos videos = Videos.fromSearch(search);
        itms.add(videos);
        if (search.id == id) {
          position = itms.indexOf(videos);
        }
      }
    }
    return ScreenArguements(position: position, items: itms);
  }

  void cancelSearch() {
    isError = false;
    isLoading = false;
    isIdle = true;
    notifyListeners();
  }

  void setSearchResult(List<Object> item) {
    _items = item;
    refreshController.refreshCompleted();
    isError = false;
    isLoading = false;
    notifyListeners();
  }

  void setMoreSearchResults(List<Search> item) {
    _items.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> searchArticles(String query) async {
    try {
      this.query = query;
      isIdle = false;
      isFirstLoad = true;
      isLoading = true;
      _items = [];
      notifyListeners();
      final response = await http.post(Uri.parse(ApiUrl.SEARCH),
          body: jsonEncode({
            "data": {
              "offset": 0,
              "query": query,
              "searchfor": index,
              "location": location.toLowerCase()
            }
          }));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print("this is index = " + index.toString());
        print(response.body);

        if (index == 3) {
          List<Search> articles = await compute(parseArticles, response.body);
          setSearchResult(articles);
        }
        if (index == 1) {
          List<LiveStreams> medias =
              await compute(parseLiveStreams, response.body);
          setSearchResult(medias);
        }
        if (index == 0) {
          List<Radios> radios =
              await compute(Parsers.parseSearchRadios, response.body);
          setSearchResult(radios);
        }
        if (index == 2) {
          print("index is 3");
          List<Media> medias = await compute(parseMedia, response.body);
          setSearchResult(medias);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print(response.body);
        print("there is an error somwehere");
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
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreArticles() async {
    isFirstLoad = false;
    try {
      final response = await http.post(Uri.parse(ApiUrl.SEARCH),
          body: jsonEncode({
            "data": {
              "query": query,
              "location": location.toLowerCase(),
              "date": sortDate,
              "searchfor": index,
              "offset": items.length + 1
            }
          }));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        List<Search> articles = await compute(parseArticles, response.body);
        setMoreSearchResults(articles);
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

  static List<Search> parseArticles(String responseBody) {
    final res = jsonDecode(responseBody);
    if (isFirstLoad) {
      sortDate = res["date"];
    }
    final parsed = res["search"].cast<Map<String, dynamic>>();
    return parsed.map<Search>((json) => Search.fromJson(json)).toList();
  }

  static List<Media> parseMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["search"].cast<Map<String, dynamic>>();
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  static List<LiveStreams> parseLiveStreams(String responseBody) {
    //final res = jsonDecode(responseBody);
    final res = jsonDecode(responseBody);
    final parsed = res["search"].cast<Map<String, dynamic>>();
    print("parsed" + parsed.toString());
    return parsed
        .map<LiveStreams>((json) => LiveStreams.fromJson(json))
        .toList();
  }
}
