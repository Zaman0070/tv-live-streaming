import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../screens/VideoViewerScreen.dart';
import '../models/ScreenArguements.dart';
import '../screens/ArticleViewerScreen.dart';
import '../models/Search.dart';
import '../models/Videos.dart';
import '../models/Articles.dart';
import '../utils/SQLiteDbProvider.dart';

class BookmarksModel with ChangeNotifier {
  List<Articles> pinnedArticles = [];
  List<Videos> pinnedVideos = [];

  BookmarksModel() {
    getPinnedData();
  }

  loadBookmarkedVideoViewer(BuildContext context, int position){
     Navigator.pushNamed(
      context,
      VideoViewerScreen.routeName,
      arguments: ScreenArguements(position: position, items: pinnedVideos),
    );
  }

  loadBookmarkedArticleViewer(BuildContext context, int position){
    Navigator.pushNamed(
      context,
      ArticleViewerScreen.routeName,
      arguments: ScreenArguements(position: position, items: pinnedArticles),
    );
  }

  bool isArticleBookMarked(int id) {
    Articles itm =
        pinnedArticles.firstWhere((itm) => itm.id == id, orElse: () => null);
    return itm != null;
  }

  bookmarkSearchedArticle(Search search) {
    Articles article = Articles.fromSearch(search);
    pinnedArticles.insert(0, article);
    SQLiteDbProvider.db.bookmarkArticle(article);
    notifyListeners();
  }

  bookmarkArticle(Articles article) {
    pinnedArticles.insert(0, article);
    SQLiteDbProvider.db.bookmarkArticle(article);
    notifyListeners();
  }

  unBookmarkArticle(int id) {
    Articles itm = pinnedArticles.firstWhere((itm) => itm.id == id,
        orElse: () => null);
    if (itm != null) {
      pinnedArticles.remove(itm);
      SQLiteDbProvider.db.deleteArticleBookmark(itm.id);
    }
    notifyListeners();
  }

  bool isVideoBookmarked(int id) {
    Videos itm =
        pinnedVideos.firstWhere((itm) => itm.id == id, orElse: () => null);
    return itm != null;
  }

  bookmarkSearchedVideo(Search search) {
     Videos videos = Videos.fromSearch(search);
    pinnedVideos.insert(0,videos);
    SQLiteDbProvider.db.bookmarkVideo(videos);
    notifyListeners();
  }

  bookmarkVideo(Videos videos) {
    pinnedVideos.insert(0,videos);
    SQLiteDbProvider.db.bookmarkVideo(videos);
    notifyListeners();
  }

  unBookmarkVideo(int id) {
    Videos itm = pinnedVideos.firstWhere((itm) => itm.id == id,
        orElse: () => null);
    if (itm != null) {
      pinnedVideos.remove(itm);
      SQLiteDbProvider.db.deleteVideoBookmark(itm.id);
    }
    notifyListeners();
  }

  getPinnedData() async {
    pinnedArticles = await SQLiteDbProvider.db.getAllBookmarkedArticles();
    pinnedVideos = await SQLiteDbProvider.db.getAllBookmarkedVideos();
    notifyListeners();
  }


}
