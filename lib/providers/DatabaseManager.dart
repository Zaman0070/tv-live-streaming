import 'package:flutter/material.dart';
import 'package:newsextra/models/Categories.dart';
import 'package:newsextra/utils/Parsers.dart';
import '../utils/SQLiteDbProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/ApiUrl.dart';

class DatabaseManager with ChangeNotifier {
  String title = "Processing";
  String message = "";
  bool isLoading = true;
  bool isError = false;
  bool downloadDone = false;

  DatabaseManager();

  fetchData() {
    title = "Processing";
    message = "setting up the app, please wait a moment.";
    isLoading = true;
    isError = false;
    downloadDone = false;
    notifyListeners();
    fetchDatabaseItems();
  }

  setError() {
    title = "Error";
    message =
        "We could not setup the app at the moment, please click the button below to retry";
    isLoading = false;
    downloadDone = false;
    isError = true;
    notifyListeners();
  }

  doneProcessing() async {
    title = "Success";
    message = "App Setup completed succesfully.";
    isLoading = false;
    downloadDone = true;
    isError = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("database_downloaded", true);
    notifyListeners();
  }

  Future<void> fetchDatabaseItems() async {
    try {
      final response = await http.get(Uri.parse(ApiUrl.CATEGORIES));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        List<Categories> cats =
            await compute(Parsers.parseCategories, response.body);
        setCategories(cats);
        doneProcessing();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setError();
    }
  }

  void setCategories(List<Categories> item) {
    for (var itm in item) {
      SQLiteDbProvider.db.insertCategory(itm);
    }
  }
}
