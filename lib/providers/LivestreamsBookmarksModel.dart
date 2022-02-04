import 'package:flutter/foundation.dart';
import 'package:newsextra/models/LiveStreams.dart';
import '../utils/SQLiteDbProvider.dart';

class LivestreamsBookmarksModel with ChangeNotifier {
  List<LiveStreams> bookmarksList = [];

  LivestreamsBookmarksModel() {
    getDatabaseRadio();
    //fetchRadio();
  }

  getDatabaseRadio() async {
    bookmarksList = await SQLiteDbProvider.db.getAllLiveStreams();
    notifyListeners();
  }

  bookmarkMedia(LiveStreams media) async {
    await SQLiteDbProvider.db.bookmarkLivestream(media);
    getDatabaseRadio();
  }

  unBookmarkMedia(LiveStreams media) async {
    await SQLiteDbProvider.db.deleteBookMarkedLivestream(media.id);
    getDatabaseRadio();
  }

  bool isMediaBookmarked(LiveStreams media) {
    LiveStreams itm = bookmarksList.firstWhere((itm) => itm.id == media.id,
        orElse: () => null);
    return itm != null;
  }
}
