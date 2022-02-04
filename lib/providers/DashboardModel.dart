import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:newsextra/models/Articles.dart';
import 'package:newsextra/models/Country.dart';
import 'package:newsextra/models/Radios.dart';
import '../utils/ApiUrl.dart';
import '../models/Userdata.dart';
import '../models/Media.dart';
import '../models/Categories.dart';
import '../models/LiveStreams.dart';
import '../utils/SQLiteDbProvider.dart';

class DashboardModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  Userdata userdata;
  bool isLoading = false;
  List<Categories> categories;
  List<LiveStreams> livestreams;
  List<Media> sliderMedias;
  List<Media> latestVideos;
  List<Media> latestAudios;
  List<Media> trendingVideos;
  List<Media> trendingAudios;
  List<Articles> articles;
  List<Radios> radios;
  int country = 0;

  DashboardModel() {
    loadItems();
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

  loadItems() async {
    await getUserLocation();
    isLoading = true;
    notifyListeners();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        ApiUrl.DISCOVER,
        data: jsonEncode({
          "data": {
            "email": userdata == null ? "null" : userdata.email,
            "country": country,
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        isLoading = false;
        isError = false;

        dynamic res = jsonDecode(response.data);
        categories = parseCategories(res);
        livestreams = parseLiveStreams(res);
        sliderMedias = parseSliderMedia(res);
        latestVideos = parseLatestVideos(res);
        latestAudios = parseLatestAudios(res);
        trendingVideos = parseTrendingVideos(res);
        trendingAudios = parseTrendingAudios(res);
        articles = parseArticles(res);
        radios = parseRadios(res);
        /*categories = await compute(parseCategories, response.data);
        livestreams = await compute(parseLiveStreams, response.data);
        sliderMedias = await compute(parseSliderMedia, response.data);
        latestVideos = await compute(parseLatestVideos, response.body);
        latestAudios = await compute(parseLatestAudios, response.body);
        trendingVideos = await compute(parseTrendingVideos, response.body);
        trendingAudios = await compute(parseTrendingAudios, response.body);*/
        print("sliderMedias" + sliderMedias.toString());
        print("LENGTH OF LLATEST VIDEOS ============ $latestAudios");
        notifyListeners();
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

  static List<Radios> parseRadios(dynamic res) {
    final parsed = res["radio"].cast<Map<String, dynamic>>();
    return parsed.map<Radios>((json) => Radios.fromJson(json)).toList();
  }

  static List<Articles> parseArticles(dynamic res) {
    final parsed = res["news"].cast<Map<String, dynamic>>();
    return parsed.map<Articles>((json) => Articles.fromJson(json)).toList();
  }

  static List<Categories> parseCategories(dynamic res) {
    final parsed = res["categories"].cast<Map<String, dynamic>>();
    return parsed.map<Categories>((json) => Categories.fromJson(json)).toList();
  }

  static List<LiveStreams> parseLiveStreams(dynamic res) {
    final parsed = res["livestreams"].cast<Map<String, dynamic>>();
    return parsed.map<LiveStreams>((json) => LiveStreams.fromJson(json)).toList();
  }

  static List<Media> parseSliderMedia(dynamic res) {
    final parsed = res["slider_media"].cast<Map<String, dynamic>>();
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  static List<Media> parseLatestVideos(dynamic res) {
    final parsed = res["latest_videos"].cast<Map<String, dynamic>>();
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  static List<Media> parseLatestAudios(dynamic res) {
    final parsed = res["latest_audios"].cast<Map<String, dynamic>>();
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  static List<Media> parseTrendingVideos(dynamic res) {
    final parsed = res["trending_videos"].cast<Map<String, dynamic>>();
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  static List<Media> parseTrendingAudios(dynamic res) {
    final parsed = res["trending_audios"].cast<Map<String, dynamic>>();
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  setFetchError() {
    isError = true;
    isLoading = false;
    notifyListeners();
  }
}
