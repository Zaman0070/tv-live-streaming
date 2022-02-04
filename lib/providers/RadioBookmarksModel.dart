import 'package:flutter/foundation.dart';
import '../models/Radios.dart';
import '../utils/SQLiteDbProvider.dart';

class RadioBookmarksModel with ChangeNotifier {
  List<Radios> bookmarksList = [];

  RadioBookmarksModel() {
    getDatabaseRadio();
    //fetchRadio();
  }

  getDatabaseRadio() async {
    bookmarksList = await SQLiteDbProvider.db.getAllRadio();
    notifyListeners();
  }

  bookmarkMedia(Radios media) async {
    await SQLiteDbProvider.db.bookmarkRadio(media);
    getDatabaseRadio();
  }

  unBookmarkMedia(Radios media) async {
    await SQLiteDbProvider.db.deleteBookmarkedRadio(media.id);
    getDatabaseRadio();
  }

  bool isMediaBookmarked(Radios media) {
    Radios itm = bookmarksList.firstWhere((itm) => itm.id == media.id,
        orElse: () => null);
    return itm != null;
  }
}
