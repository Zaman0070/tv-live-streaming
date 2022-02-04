import 'package:flutter/material.dart';
import '../viewholders/VideosItemHeader.dart';
import '../viewholders/VideosItemTile.dart';
import '../models/Videos.dart';
import '../providers/AppStateNotifier.dart';
import '../utils/Adverts.dart';

ListView buildVideosListView(
  AppStateNotifier appState,
  List<Videos> items,
) {
  return ListView.separated(
    itemBuilder: (c, i) =>
        (appState.loadArticlesImages && !appState.loadSmallImages
            ? ItemHeaderTile(
                index: i,
                object: items[i],
                isSource: false,
                isBookmarks: false,
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

ListView buildVideosSourceListView(
  AppStateNotifier appState,
  List<Videos> items,
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

ListView buildBookmarkedVideoListView(
    AppStateNotifier appState, List<Videos> items, void onItemClick(int indx)) {
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
