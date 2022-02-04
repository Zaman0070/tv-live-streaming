import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../utils/ApiUrl.dart';
import '../utils/Parsers.dart';
import '../models/Categories.dart';
import '../models/Sources.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import '../utils/SQLiteDbProvider.dart';

class SourcesModel with ChangeNotifier {
  List<Sources> _items = [];
  List<int> unfollowedFeedSources = [];
  List<int> unFollowedVideoSources = [];
  bool isLoading = true;

  String location = 'wo';
  List<String> selectedcats = [];

  SourcesModel() {
    init();
  }

  init() async {
    await getDatabaseCategories();
    await getUserLocation();
    getUnFOllowedSources();
    fetchSources();
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

  getDatabaseCategories() async {
    selectedcats = [];
    List<Categories> dbcategories =
        await SQLiteDbProvider.db.getAllCategories();
    for (var itm in dbcategories) {
      selectedcats.add(itm.title);
    }
  }

  getUnFOllowedSources() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("unfollowedfeedsources") != null) {
      unfollowedFeedSources =
          json.decode(prefs.getString("unfollowedfeedsources")).cast<int>();
    }
    if (prefs.getString("unfollowedvideosources") != null) {
      unFollowedVideoSources =
          json.decode(prefs.getString("unfollowedvideosources")).cast<int>();
    }
  }

  /// An unmodifiable view of the items.
  List<Sources> get items {
    return _items;
  }

  void setSources(List<Sources> item) {
    _items.addAll(item);
    _items.sort((a, b) {
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    isLoading = false;
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    //notifyListeners();
  }

  void setLoading() {
    isLoading = true;
    //notifyListeners();
  }

  void fetchData() {
    isLoading = true;
    notifyListeners();
    fetchSources();
  }

  bool isUnfollowedFeedsSourcesContain(int id) {
    if (unfollowedFeedSources.contains(id)) {
      return true;
    }
    return false;
  }

  bool isUnfollowedVideosSourcesContain(int id) {
    if (unFollowedVideoSources.contains(id)) {
      return true;
    }
    return false;
  }

  void selectUnselectCategory(Sources sources) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (sources.type == "feeds") {
      if (isUnfollowedFeedsSourcesContain(sources.id)) {
        unfollowedFeedSources.remove(sources.id);
      } else {
        unfollowedFeedSources.add(sources.id);
      }
      var s = json.encode(unfollowedFeedSources);
      prefs.setString("unfollowedfeedsources", s);
    } else {
      if (isUnfollowedVideosSourcesContain(sources.id)) {
        unFollowedVideoSources.remove(sources.id);
      } else {
        unFollowedVideoSources.add(sources.id);
      }
      var s = json.encode(unFollowedVideoSources);
      prefs.setString("unfollowedvideosources", s);
    }
    notifyListeners();
  }

  Future<void> fetchSources() async {
    try {
      var data = {
        "interests": selectedcats,
        "location": location.toLowerCase()
      };
      print(data);
      final response = await http.post(Uri.parse(ApiUrl.SOURCES),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        List<Sources> cats = await compute(Parsers.parseSources, response.body);
        setSources(cats);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        isLoading = false;
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      isLoading = false;
      notifyListeners();
    }
  }
}
