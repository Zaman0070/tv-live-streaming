import 'dart:async';
import 'package:newsextra/models/Country.dart';
import 'package:newsextra/models/Downloads.dart';
import 'package:newsextra/models/LiveStreams.dart';
import 'package:newsextra/models/Media.dart';

import '../models/Categories.dart';
import '../models/Articles.dart';
import '../models/Videos.dart';
import '../models/Radios.dart';
import '../models/Userdata.dart';
import '../utils/TimUtil.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();
  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(
        join(await getDatabasesPath(), 'news_database.db'),
        version: 1,
        onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ${Media.BOOKMARKS_TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "category TEXT,"
          "title TEXT,"
          "coverPhoto TEXT,"
          "mediaType TEXT,"
          "videoType TEXT,"
          "description TEXT,"
          "downloadUrl TEXT,"
          "canPreview INTEGER,"
          "canDownload INTEGER,"
          "isFree INTEGER,"
          "userLiked INTEGER,"
          "http INTEGER,"
          "duration INTEGER,"
          "commentsCount INTEGER,"
          "likesCount INTEGER,"
          "previewDuration INTEGER,"
          "streamUrl TEXT,"
          "viewsCount INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Media.PLAYLISTS_TABLE} ("
          "id INTEGER,"
          "playlistId INTEGER,"
          "category TEXT,"
          "title TEXT,"
          "coverPhoto TEXT,"
          "mediaType TEXT,"
          "videoType TEXT,"
          "description TEXT,"
          "downloadUrl TEXT,"
          "canPreview INTEGER,"
          "canDownload INTEGER,"
          "isFree INTEGER,"
          "userLiked INTEGER,"
          "http INTEGER,"
          "duration INTEGER,"
          "commentsCount INTEGER,"
          "likesCount INTEGER,"
          "previewDuration INTEGER,"
          "streamUrl TEXT,"
          "viewsCount INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Downloads.Downloads_TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "category TEXT,"
          "title TEXT,"
          "coverPhoto TEXT,"
          "mediaType TEXT,"
          "videoType TEXT,"
          "description TEXT,"
          "downloadUrl TEXT,"
          "canPreview INTEGER,"
          "canDownload INTEGER,"
          "isFree INTEGER,"
          "userLiked INTEGER,"
          "http INTEGER,"
          "duration INTEGER,"
          "timeStamp INTEGER,"
          "progress INTEGER,"
          "taskId TEXT,"
          "commentsCount INTEGER,"
          "likesCount INTEGER,"
          "previewDuration INTEGER,"
          "streamUrl TEXT,"
          "viewsCount INTEGER"
          ")");
      await db.execute("CREATE TABLE ${Articles.TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "sourceID INTEGER,"
          "source TEXT,"
          "link TEXT,"
          "title TEXT,"
          "thumbnail TEXT,"
          "content TEXT,"
          "location TEXT,"
          "lang TEXT,"
          "date TEXT,"
          "interest TEXT,"
          "type TEXT,"
          "timeStamp INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Articles.BOOKMARKTABLE} ("
          "id INTEGER PRIMARY KEY,"
          "sourceID INTEGER,"
          "source TEXT,"
          "link TEXT,"
          "title TEXT,"
          "thumbnail TEXT,"
          "content TEXT,"
          "location TEXT,"
          "lang TEXT,"
          "date TEXT,"
          "interest TEXT,"
          "type TEXT,"
          "timeStamp INTEGER,"
          "addedTimeStamp INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Videos.TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "sourceID INTEGER,"
          "source TEXT,"
          "link TEXT,"
          "title TEXT,"
          "thumbnail TEXT,"
          "content TEXT,"
          "location TEXT,"
          "lang TEXT,"
          "date TEXT,"
          "interest TEXT,"
          "type TEXT,"
          "timeStamp INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Videos.BOOKMARKTABLE} ("
          "id INTEGER PRIMARY KEY,"
          "sourceID INTEGER,"
          "source TEXT,"
          "link TEXT,"
          "title TEXT,"
          "thumbnail TEXT,"
          "content TEXT,"
          "location TEXT,"
          "lang TEXT,"
          "date TEXT,"
          "interest TEXT,"
          "type TEXT,"
          "timeStamp INTEGER,"
          "addedTimeStamp INTEGER"
          ")");

      await db.execute("CREATE TABLE ${Categories.TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "thumbnailUrl TEXT"
          ")");

      await db.execute("CREATE TABLE ${Radios.TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "thumbnail TEXT,"
          "link TEXT,"
          "tv TEXT,"
          "interest TEXT,"
          "extra TEXT"
          ")");

      await db.execute("CREATE TABLE ${Radios.RECORD_TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "thumbnail TEXT,"
          "link TEXT,"
          "tv TEXT,"
          "interest TEXT,"
          "extra TEXT"
          ")");

      await db.execute("CREATE TABLE ${LiveStreams.TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "coverphoto TEXT,"
          "type TEXT,"
          "description TEXT,"
          "isfree TEXT,"
          "streamurl TEXT,"
          "extra TEXT"
          ")");

      await db.execute("CREATE TABLE ${Userdata.TABLE} ("
          "email TEXT,"
          "name TEXT"
          ")");

      await db.execute("CREATE TABLE ${Country.TABLE} ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "thumbnailUrl TEXT"
          ")");
    });
  }

  //country crud
  Future<Country> getCountryData() async {
    final db = await database;
    List<Map> results = await db.query(
      "${Country.TABLE}",
      columns: Country.columns,
    );
    print(results.toString());
    List<Country> datalist = new List();
    results.forEach((result) {
      Country country = Country.fromMap(result);
      datalist.add(country);
    });
    //print(categories.length);
    return datalist.length > 0 ? datalist[0] : null;
  }

  insertCountry(Country country) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT Into ${Country.TABLE} (id, title, thumbnailUrl)"
        " VALUES (?, ?, ?)",
        [country.id, country.title, country.thumbnailUrl]);
    return result;
  }

  deleteCountryData() async {
    final db = await database;
    db.rawDelete("DELETE FROM ${Country.TABLE}");
  }

  //userdata crud
  Future<Userdata> getUserData() async {
    final db = await database;
    List<Map> results = await db.query(
      "${Userdata.TABLE}",
      columns: Userdata.columns,
    );
    print(results.toString());
    List<Userdata> userdatalist = [];
    results.forEach((result) {
      Userdata userdata = Userdata.fromMap(result);
      userdatalist.add(userdata);
    });
    //print(categories.length);
    return userdatalist.length > 0 ? userdatalist[0] : null;
  }

  insertUser(Userdata userdata) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT Into ${Userdata.TABLE} (email, name)"
        " VALUES (?, ?)",
        [userdata.email, userdata.name]);
    return result;
  }

  deleteUserData() async {
    final db = await database;
    db.rawDelete("DELETE FROM ${Userdata.TABLE}");
  }

  //categories crud
  Future<List<Categories>> getAllCategories() async {
    final db = await database;
    List<Map> results = await db.query("${Categories.TABLE}",
        columns: Categories.columns, orderBy: "id ASC");
    List<Categories> categories = [];
    results.forEach((result) {
      Categories category = Categories.fromMap(result);
      categories.add(category);
    });
    //print(categories.length);
    return categories;
  }

  insertCategory(Categories categories) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Categories.TABLE} (id, title, thumbnailUrl)"
        " VALUES (?, ?, ?)",
        [categories.id, categories.title, categories.thumbnailUrl]);
    return result;
  }

  deleteCategory(int id) async {
    final db = await database;
    db.delete("${Categories.TABLE}", where: "id = ?", whereArgs: [id]);
  }

  //articles crud
  Future<List<Articles>> getAllArticles() async {
    final db = await database;
    List<Map> results = await db.query("${Articles.TABLE}",
        columns: Articles.columns, orderBy: "timeStamp DESC");
    List<Articles> articles = [];
    results.forEach((result) {
      Articles article = Articles.fromMap(result);
      articles.add(article);
    });
    //print(categories.length);
    return articles;
  }

  insertArticle(Articles articles) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT Into ${Articles.TABLE} (id,sourceID,source,link,title,thumbnail,content,location,lang,date,interest,type,timeStamp)"
        " VALUES (?, ?, ?, ?,?, ?, ?, ?,?, ?, ?, ?, ?)",
        [
          articles.id,
          articles.sourceID,
          articles.source,
          articles.link,
          articles.title,
          articles.thumbnail,
          articles.content,
          articles.location,
          articles.lang,
          articles.date,
          articles.interest,
          articles.type,
          articles.timeStamp
        ]);
    return result;
  }

  insertBatchArticles(List<Articles> articleList) async {
    try {
      final db = await database;
      Batch batch = db.batch();
      for (int i = 0; i < articleList.length; i++) {
        Articles articles = articleList[i];
        batch.rawInsert(
            "INSERT Into ${Articles.TABLE} (id,sourceID,source,link,title,thumbnail,content,location,lang,date,interest,type,timeStamp)"
            " VALUES (?, ?, ?, ?,?, ?, ?, ?,?, ?, ?, ?, ?)",
            [
              articles.id,
              articles.sourceID,
              articles.source,
              articles.link,
              articles.title,
              articles.thumbnail,
              articles.content,
              articles.location,
              articles.lang,
              articles.date,
              articles.interest,
              articles.type,
              articles.timeStamp
            ]);
      }
      batch.commit(noResult: true);
    } catch (e) {
      print("database error");
      print(e);
    }
    //return null;
  }

  deleteArticle(int id) async {
    final db = await database;
    db.delete("${Articles.TABLE}", where: "id = ?", whereArgs: [id]);
  }

  deleteAllArticles() async {
    final db = await database;
    db.rawDelete("DELETE FROM ${Articles.TABLE}");
  }

  //articles bookmarks crud
  Future<List<Articles>> getAllBookmarkedArticles() async {
    final db = await database;
    List<Map> results = await db.query("${Articles.BOOKMARKTABLE}",
        columns: Articles.columns, orderBy: "addedTimeStamp DESC");
    List<Articles> articles = [];
    results.forEach((result) {
      Articles article = Articles.fromMap(result);
      articles.add(article);
    });
    //print(categories.length);
    return articles;
  }

  bookmarkArticle(Articles articles) async {
    try {
      final db = await database;
      await db.rawInsert(
          "INSERT Into ${Articles.BOOKMARKTABLE} (id,sourceID,source,link,title,thumbnail,content,location,lang,date,interest,type,timeStamp, addedTimeStamp)"
          " VALUES (?, ?, ?, ?,?, ?, ?, ?,?, ?, ?, ?, ?, ?)",
          [
            articles.id,
            articles.sourceID,
            articles.source,
            articles.link,
            articles.title,
            articles.thumbnail,
            articles.content,
            articles.location,
            articles.lang,
            articles.date,
            articles.interest,
            articles.type,
            articles.timeStamp,
            TimUtil.currentTimeInSeconds()
          ]);
    } catch (e) {
      print("bookmark article error");
      print(e);
    }
  }

  deleteArticleBookmark(int id) async {
    final db = await database;
    db.delete("${Articles.BOOKMARKTABLE}", where: "id = ?", whereArgs: [id]);
  }

  deleteAllArticlesBookmarks() async {
    final db = await database;
    Batch batch = db.batch();
    //db.delete("Articles");
    batch.delete("${Articles.BOOKMARKTABLE}");
  }

  //videos crud
  Future<List<Videos>> getAllVideos() async {
    final db = await database;
    List<Map> results = await db.query("${Videos.TABLE}",
        columns: Articles.columns, orderBy: "timeStamp DESC");
    List<Videos> videos = [];
    results.forEach((result) {
      Videos video = Videos.fromMap(result);
      videos.add(video);
    });
    return videos;
  }

  insertBatchVideos(List<Videos> videoList) async {
    try {
      final db = await database;
      Batch batch = db.batch();
      for (int i = 0; i < videoList.length; i++) {
        Videos videos = videoList[i];
        batch.rawInsert(
            "INSERT Into ${Videos.TABLE} (id,sourceID,source,link,title,thumbnail,content,location,lang,date,interest,type,timeStamp)"
            " VALUES (?, ?, ?, ?,?, ?, ?, ?,?, ?, ?, ?, ?)",
            [
              videos.id,
              videos.sourceID,
              videos.source,
              videos.link,
              videos.title,
              videos.thumbnail,
              videos.content,
              videos.location,
              videos.lang,
              videos.date,
              videos.interest,
              videos.type,
              videos.timeStamp
            ]);
      }
      batch.commit(noResult: true);
    } catch (e) {
      print("database error");
      print(e);
    }
    //return null;
  }

  deleteVideo(int id) async {
    final db = await database;
    db.delete("${Videos.TABLE}", where: "id = ?", whereArgs: [id]);
  }

  deleteAllVideos() async {
    final db = await database;
    db.rawDelete("DELETE FROM ${Videos.TABLE}");
  }

  //articles bookmarks crud
  Future<List<Videos>> getAllBookmarkedVideos() async {
    final db = await database;
    List<Map> results = await db.query("${Videos.BOOKMARKTABLE}",
        columns: Videos.columns, orderBy: "addedTimeStamp DESC");
    List<Videos> videos = [];
    results.forEach((result) {
      Videos video = Videos.fromMap(result);
      videos.add(video);
    });
    return videos;
  }

  bookmarkVideo(Videos videos) async {
    try {
      final db = await database;
      await db.rawInsert(
          "INSERT Into ${Videos.BOOKMARKTABLE} (id,sourceID,source,link,title,thumbnail,content,location,lang,date,interest,type,timeStamp, addedTimeStamp)"
          " VALUES (?, ?, ?, ?,?, ?, ?, ?,?, ?, ?, ?, ?, ?)",
          [
            videos.id,
            videos.sourceID,
            videos.source,
            videos.link,
            videos.title,
            videos.thumbnail,
            videos.content,
            videos.location,
            videos.lang,
            videos.date,
            videos.interest,
            videos.type,
            videos.timeStamp,
            TimUtil.currentTimeInSeconds()
          ]);
    } catch (e) {
      print("bookmark article error");
      print(e);
    }
  }

  deleteVideoBookmark(int id) async {
    final db = await database;
    db.delete("${Videos.BOOKMARKTABLE}", where: "id = ?", whereArgs: [id]);
  }

  deleteAllVideosBookmarks() async {
    final db = await database;
    Batch batch = db.batch();
    //db.delete("Articles");
    batch.delete("${Videos.BOOKMARKTABLE}");
  }

  //categories crud
  Future<List<Radios>> getAllRadio() async {
    final db = await database;
    List<Map> results = await db.query("${Radios.TABLE}",
        columns: Radios.columns, orderBy: "id ASC");
    List<Radios> radioList = [];
    results.forEach((result) {
      Radios radio = Radios.fromMap(result);
      radioList.add(radio);
    });
    //print(categories.length);
    return radioList;
  }

  insertBatchRadio(List<Radios> radioList) async {
    try {
      final db = await database;
      Batch batch = db.batch();
      for (int i = 0; i < radioList.length; i++) {
        Radios radio = radioList[i];
        batch.rawInsert(
            "INSERT OR REPLACE Into ${Radios.TABLE} (id,title,thumbnail,link, tv,interest, extra)"
            " VALUES (?, ?, ?, ?,?,?, ?)",
            [
              radio.id,
              radio.title,
              radio.thumbnail,
              radio.link,
              radio.tv,
              radio.interest,
              radio.extra
            ]);
      }
      batch.commit(noResult: true);
    } catch (e) {
      print("database error");
      print(e);
    }
    //return null;
  }

  deleteAllRadio() async {
    final db = await database;
    db.rawDelete("DELETE FROM ${Radios.TABLE}");
  }

  //media bookmarks crud
  Future<List<Media>> getAllMediaBookmarks() async {
    final db = await database;
    List<Map> results = await db.query("${Media.BOOKMARKS_TABLE}",
        columns: Media.bookmarkscolumns);
    List<Media> medialist = new List();
    results.forEach((result) {
      Media media = Media.fromMap(result);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist;
  }

  bookmarkMedia(Media media) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Media.BOOKMARKS_TABLE} (id,category,title,coverPhoto,mediaType,videoType,description,downloadUrl,canPreview,canDownload,isFree,userLiked,http, duration,commentsCount,likesCount,previewDuration,streamUrl,viewsCount)"
        " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
          media.id,
          media.category,
          media.title,
          media.coverPhoto,
          media.mediaType,
          media.videoType,
          media.description,
          media.downloadUrl,
          media.canPreview == true ? 0 : 1,
          media.canDownload == true ? 0 : 1,
          media.isFree == true ? 0 : 1,
          media.userLiked == true ? 0 : 1,
          media.http == true ? 0 : 1,
          media.duration,
          media.commentsCount,
          media.likesCount,
          media.previewDuration,
          media.streamUrl,
          media.viewsCount
        ]);
    return result;
  }

  //userdata crud
  Future<bool> isMediaBookmarked(Media media) async {
    final db = await database;
    List<Map> results = await db.query("${Media.BOOKMARKS_TABLE}",
        columns: Media.bookmarkscolumns,
        where: "id = ?",
        whereArgs: [media.id]);
    return results.length > 0;
  }

  deleteBookmarkedMedia(int id) async {
    final db = await database;
    db.delete("${Media.BOOKMARKS_TABLE}", where: "id = ?", whereArgs: [id]);
  }

  //downloads list crud
  Future<List<Downloads>> getAllDownloads() async {
    final db = await database;
    List<Map> results = await db.query("${Downloads.Downloads_TABLE}",
        columns: Downloads.downloadscolumns, orderBy: "timeStamp Desc");
    List<Downloads> medialist = new List();
    results.forEach((result) {
      Downloads media = Downloads.fromMap(result);
      medialist.add(media);
    });
    //print(categories.length);
    return medialist;
  }

  addNewDownloadItem(Downloads media) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR IGNORE Into ${Downloads.Downloads_TABLE} (id,category,title,coverPhoto,mediaType,videoType,description,downloadUrl,canPreview,canDownload,isFree,userLiked,http, duration,timeStamp,progress,taskId,commentsCount,likesCount,previewDuration,streamUrl,viewsCount)"
        " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
          media.id,
          media.category,
          media.title,
          media.coverPhoto,
          media.mediaType,
          media.videoType,
          media.description,
          media.downloadUrl,
          media.canPreview == true ? 0 : 1,
          media.canDownload == true ? 0 : 1,
          media.isFree == true ? 0 : 1,
          media.userLiked == true ? 0 : 1,
          media.http == true ? 0 : 1,
          media.duration,
          media.timeStamp,
          media.progress,
          media.taskId,
          media.commentsCount,
          media.likesCount,
          media.previewDuration,
          media.streamUrl,
          media.viewsCount
        ]);
    return result;
  }

  deleteDownloadMedia(int id) async {
    final db = await database;
    db.delete("${Downloads.Downloads_TABLE}", where: "id = ?", whereArgs: [id]);
  }

  bookmarkRadio(Radios media) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Radios.TABLE} (id,title, link, tv,thumbnail,interest, extra)"
        " VALUES (?, ?, ?, ?, ?, ?, ?)",
        [
          media.id,
          media.title,
          media.link,
          media.tv,
          media.thumbnail,
          media.interest,
          media.extra
        ]);
    return result;
  }

  //userdata crud
  Future<bool> isRadioBookmarked(Radios media) async {
    final db = await database;
    List<Map> results = await db.query("${Radios.TABLE}",
        columns: Radios.columns, where: "id = ?", whereArgs: [media.id]);
    return results.length > 0;
  }

  deleteBookmarkedRadio(int id) async {
    final db = await database;
    db.delete("${Radios.TABLE}", where: "id = ?", whereArgs: [id]);
  }

  //recordings
  Future<List<Radios>> getAllRecordedRadio() async {
    final db = await database;
    List<Map> results = await db.query("${Radios.RECORD_TABLE}",
        columns: Radios.columns, orderBy: "id ASC");
    List<Radios> radioList = [];
    results.forEach((result) {
      Radios radio = Radios.fromMap(result);
      radioList.add(radio);
    });
    //print(categories.length);
    return radioList;
  }

  saveRecrodedRadio(Radios media) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${Radios.RECORD_TABLE} (id,title, link, tv,thumbnail,interest)"
        " VALUES (?, ?, ?, ?, ?, ?)",
        [
          media.id,
          media.title,
          media.link,
          media.tv,
          media.thumbnail,
          media.interest
        ]);
    return result;
  }

  deleteRecordedRadio(int id) async {
    final db = await database;
    db.delete("${Radios.RECORD_TABLE}", where: "id = ?", whereArgs: [id]);
  }

  //livestreams
  Future<List<LiveStreams>> getAllLiveStreams() async {
    final db = await database;
    List<Map> results = await db.query("${LiveStreams.TABLE}",
        columns: LiveStreams.columns, orderBy: "id ASC");
    List<LiveStreams> radioList = [];
    results.forEach((result) {
      LiveStreams radio = LiveStreams.fromMap(result);
      print(radio.coverphoto);
      radioList.add(radio);
    });
    //print(categories.length);
    return radioList;
  }

  bookmarkLivestream(LiveStreams media) async {
    final db = await database;
    var result = await db.rawInsert(
        "INSERT OR REPLACE Into ${LiveStreams.TABLE} (id,title,coverphoto,type,description,isfree,streamurl, extra)"
        " VALUES (?, ?, ?, ?, ?, ?,?, ?)",
        [
          media.id,
          media.title,
          media.coverphoto,
          media.type,
          media.description,
          media.isfree,
          media.streamurl,
          media.extra
        ]);
    return result;
  }

  deleteBookMarkedLivestream(int id) async {
    final db = await database;
    db.delete("${LiveStreams.TABLE}", where: "id = ?", whereArgs: [id]);
  }
}
