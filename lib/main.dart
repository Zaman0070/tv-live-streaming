import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:newsextra/models/Country.dart';
import 'package:newsextra/providers/DatabaseManager.dart';
import 'package:newsextra/providers/DownloadsModel.dart';
import 'package:newsextra/providers/LivestreamsBookmarksModel.dart';
import 'package:newsextra/providers/MediaBookmarksModel.dart';
import 'package:newsextra/providers/RadioBookmarksModel.dart';
import 'package:newsextra/providers/RadioRecordingsModel.dart';
import 'package:newsextra/providers/SubscriptionModel.dart';
import 'package:newsextra/providers/UploadMediaModel.dart';
import 'package:newsextra/screens/CountryScreen.dart';
import 'package:newsextra/screens/DownloadItemsScreen.dart';
import '../providers/AudioPlayerModel.dart';
import 'package:newsextra/utils/my_colors.dart';
import './screens/OnboardingPage.dart';
import 'MyApp.dart';
import './providers/AppStateNotifier.dart';
import './screens/HomePage.dart';
import './providers/BookmarksModel.dart';
import './models/Categories.dart';
import 'package:provider/provider.dart';
import './utils/SQLiteDbProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admob_flutter/admob_flutter.dart';
import './providers/ArticlesModel.dart';
import './providers/VideosModel.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //InAppPurchaseConnection.enablePendingPurchases();
  //if (defaultTargetPlatform == TargetPlatform.android) {
  // For play billing library 2.0 on Android, it is mandatory to call
  // [enablePendingPurchases](https://developer.android.com/reference/com/android/billingclient/api/BillingClient.Builder.html#enablependingpurchases)
  // as part of initializing the app.
  InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  // }
  await Firebase.initializeApp();
  Admob.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: MyColors.primary,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Future<Widget> getFirstScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("user_seen_onboarding") == null || prefs.getBool("user_seen_onboarding") != true) {
      prefs.setBool("user_seen_onboarding", true);
      return OnboardingPage();
    } else if (prefs.getBool("database_downloaded") == null || prefs.getBool("database_downloaded") == false) {
      return new DownloadItemsScreen();
    } else {
      Country _country = await SQLiteDbProvider.db.getCountryData();
      //List<States> _states = await SQLiteDbProvider.db.getSelectedStates();
      List<Categories> _itms = await SQLiteDbProvider.db.getAllCategories();
      if (_country == null) {
        return new CountryScreen(
          isFirstLoad: true,
        );
      } else {
        return HomePage();
      }
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateNotifier()),
        ChangeNotifierProvider(create: (_) => BookmarksModel()),
        ChangeNotifierProvider(create: (_) => ArticlesModel()),
        ChangeNotifierProvider(create: (_) => VideosModel()),
        ChangeNotifierProvider(create: (_) => SubscriptionModel()),
        ChangeNotifierProvider(create: (_) => MediaBookmarksModel()),
        ChangeNotifierProvider(create: (_) => DownloadsModel()),
        ChangeNotifierProvider(create: (_) => DatabaseManager()),
        ChangeNotifierProvider(create: (_) => AudioPlayerModel()),
        ChangeNotifierProvider(create: (_) => RadioBookmarksModel()),
        ChangeNotifierProvider(create: (_) => RadioRecordingsModel()),
        ChangeNotifierProvider(create: (_) => LivestreamsBookmarksModel()),
        ChangeNotifierProvider(create: (_) => UploadMediaModel()),
      ],
      child: FutureBuilder<Widget>(
          future: getFirstScreen(), //returns bool
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MyApp(defaultHome: snapshot.data);
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          }),
    ),
  );
}
