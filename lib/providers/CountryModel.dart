import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Categories.dart';
import '../utils/ApiUrl.dart';
import '../utils/Parsers.dart';
import '../models/Country.dart';
import '../models/Userdata.dart';
import '../utils/SQLiteDbProvider.dart';

class CountryModel with ChangeNotifier {
  List<Country> _items = [];
  Userdata userdata;
  Country selectedCountry;
  bool isLoading = true;
  bool isFirstimeLoad = false;
  List<String> selectedcats = [];

  CountryModel(bool isFirstimeLoad) {
    this.isFirstimeLoad = isFirstimeLoad;
    getUserData();
    getDatabaseCategories();
    getSelectedCountry();
    fetchCountries();
  }

  getUserData() async {
    userdata = await SQLiteDbProvider.db.getUserData();
    print("userdata " + userdata.toString());
    notifyListeners();
  }

  getDatabaseCategories() async {
    List<Categories> dbcategories =
        await SQLiteDbProvider.db.getAllCategories();
    for (var itm in dbcategories) {
      selectedcats.add(itm.title);
    }
  }

  getSelectedCountry() async {
    selectedCountry = await SQLiteDbProvider.db.getCountryData();
    print("country " + selectedCountry.toString());
  }

  /// An unmodifiable view of the items.
  List<Country> get items {
    return _items;
  }

  void setCountries(List<Country> item) {
    _items.clear();
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
    fetchCountries();
  }

  bool isContain(int id) {
    if (selectedCountry == null) return false;
    return selectedCountry.id == id;
  }

  void setSelectedCountry(Country country) async {
    if (selectedCountry != null && selectedCountry.id == country.id) return;
    await SQLiteDbProvider.db.deleteCountryData();
    await SQLiteDbProvider.db.insertCountry(country);
    selectedCountry = country;
    notifyListeners();
    if (userdata != null) {
      updateUserCountry();
    }
  }

  Future<void> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse(ApiUrl.COUNTRIES));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        List<Country> cats =
            await compute(Parsers.parseCountries, response.body);
        setCountries(cats);
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

  Future<void> updateUserCountry() async {}
}
