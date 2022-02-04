import 'package:flutter/foundation.dart';
import '../models/Radios.dart';
import '../utils/SQLiteDbProvider.dart';

class RadioRecordingsModel with ChangeNotifier {
  List<Radios> bookmarksList = [];

  RadioRecordingsModel() {
    getDatabaseRadio();
    //fetchRadio();
  }

  getDatabaseRadio() async {
    bookmarksList = await SQLiteDbProvider.db.getAllRecordedRadio();
    notifyListeners();
  }

  saveRecordedRadio(Radios media) async {
    await SQLiteDbProvider.db.saveRecrodedRadio(media);
    getDatabaseRadio();
  }

  deleteRecordedRadio(Radios media) async {
    await SQLiteDbProvider.db.deleteRecordedRadio(media.id);
    getDatabaseRadio();
  }
}
