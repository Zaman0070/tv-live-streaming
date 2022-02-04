import 'package:flutter/material.dart';
import '../viewholders/NewsItemHeader.dart';
import '../viewholders/NewsItemTile.dart';
import '../models/Articles.dart';
import '../providers/AppStateNotifier.dart';
import '../utils/Adverts.dart';

ListView buildArticlesListView(
  AppStateNotifier appState,
  List<Articles> items,
) {
  return ListView.separated(
    itemBuilder: (c, i) =>
        (appState.loadArticlesImages && !appState.loadSmallImages
            ? ItemHeaderTile(
                index: i,
                object: items[i],
                isBookmarks: false,
                isSource: false,
              )
            : (i == 0
                ? (appState.loadArticlesImages
                    ? Column(
                        children: <Widget>[
                          ItemHeaderTile(
                            index: i,
                            object: items[i],
                            isBookmarks: false,
                            isSource: false,
                          ),
                          Container(height: 20)
                        ],
                      )
                    : ItemTile(
                        index: i,
                        object: items[i],
                        isBookmarks: false,
                        isSource: false,
                      ))
                : ItemTile(
                    index: i,
                    object: items[i],
                    isBookmarks: false,
                    isSource: false,
                  ))),
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

ListView buildSourceArticlesListView(
  AppStateNotifier appState,
  List<Articles> items,
) {
  return ListView.separated(
    itemBuilder: (c, i) =>
        (appState.loadArticlesImages && !appState.loadSmallImages
            ? ItemHeaderTile(
                index: i,
                object: items[i],
                isBookmarks: false,
                isSource: true,
              )
            : (i == 0
                ? (appState.loadArticlesImages
                    ? Column(
                        children: <Widget>[
                          ItemHeaderTile(
                            index: i,
                            object: items[i],
                            isBookmarks: false,
                            isSource: true,
                          ),
                          Container(height: 20)
                        ],
                      )
                    : ItemTile(
                        index: i,
                        object: items[i],
                        isBookmarks: false,
                        isSource: true,
                      ))
                : ItemTile(
                    index: i,
                    object: items[i],
                    isBookmarks: false,
                    isSource: true,
                  ))),
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

ListView buildBookmarkedArticlesListView(AppStateNotifier appState,
    List<Articles> items, void onItemClick(int indx)) {
  return ListView.builder(
    itemBuilder: (c, i) =>
        (appState.loadArticlesImages && !appState.loadSmallImages
            ? ItemHeaderTile(
                index: i,
                object: items[i],
                isBookmarks: true,
                isSource: false,
              )
            : ItemTile(
                index: i,
                object: items[i],
                isBookmarks: true,
                isSource: false,
              )),
    //itemExtent: 130.0,
    itemCount: items.length,
  );
}
