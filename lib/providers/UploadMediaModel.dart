import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newsextra/models/Categories.dart';
import 'package:newsextra/models/Country.dart';
import 'package:newsextra/models/SubCategories.dart';
import 'package:newsextra/utils/SQLiteDbProvider.dart';
import '../models/Userdata.dart';
import 'dart:convert';
import 'dart:async';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;

class UploadMediaModel with ChangeNotifier {
  Userdata userdata;
  List<Categories> categories = [];
  List<SubCategories> subcategories = [];
  Categories selectedCategory;
  SubCategories selectedsubCategory;
  Country selectedCountry;

  UploadMediaModel() {
    init();
  }

  init() async {
    await getUserData();
    fetchCategories();
  }

  getSelectedCountry() async {
    selectedCountry = await SQLiteDbProvider.db.getCountryData();
    print(" from app state = " + selectedCountry.toString());
  }

  getUserData() async {
    userdata = await SQLiteDbProvider.db.getUserData();
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        ApiUrl.AppCATEGORIES,
      );

      if (response.statusCode == 200) {
        dynamic res = jsonDecode(response.data);
        categories = parseCategories(res);
        subcategories = parseSubCategories(res);
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  Future<void> fetchSubCategories(int id) async {
    try {
      final dio = Dio();
      var data = {
        "category": id.toString(),
      };
      final response = await dio.post(ApiUrl.SUBCATEGORIES,
          data: jsonEncode({"data": data}));

      if (response.statusCode == 200) {
        dynamic res = jsonDecode(response.data);
        subcategories = parseSubCategories(res);
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  static List<Categories> parseCategories(dynamic res) {
    final parsed = res["categories"].cast<Map<String, dynamic>>();
    return parsed.map<Categories>((json) => Categories.fromJson(json)).toList();
  }

  static List<SubCategories> parseSubCategories(dynamic res) {
    final parsed = res["subcategories"].cast<Map<String, dynamic>>();
    return parsed
        .map<SubCategories>((json) => SubCategories.fromJson(json))
        .toList();
  }

  initEditMedia() {
    selectedCategory = null;
    selectedsubCategory = null;
    notifyListeners();
  }
}
