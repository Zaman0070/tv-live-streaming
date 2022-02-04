import 'package:flutter/material.dart';
import '../viewholders/SearchItemTile.dart';
import '../providers/SearchModel.dart';
import '../models/Search.dart';
import '../providers/AppStateNotifier.dart';
import '../utils/Adverts.dart';

ListView buildSearchListView(
  SearchModel articlesModel,
  AppStateNotifier appState,
  List<Search> items,
) {
  return ListView.separated(
    itemBuilder: (c, i) => ItemTile(
      index: i,
      object: items[i],
    ),
    //itemExtent: 130.0,
    separatorBuilder: (context, position) {
      return Container(
          child: (position != 0 && position % 5 == 0)
              ? Container(child: AdmobNativeAds())
              : Container());
    },
    itemCount: items.length,
  );
}
