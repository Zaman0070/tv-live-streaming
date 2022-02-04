import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:newsextra/audio_player/miniPlayer.dart';
import 'package:newsextra/providers/AppStateNotifier.dart';
import 'package:newsextra/providers/DashboardModel.dart';
import 'package:newsextra/providers/MediaScreensModel.dart';
import 'package:newsextra/screens/Dashboard.dart';
import 'package:newsextra/screens/HomeCategoriesScreen.dart';
import 'package:newsextra/utils/Adverts.dart';
import 'package:rate_my_app/rate_my_app.dart';
import '../providers/BookmarksModel.dart';
import '../providers/LiveStreamsModel.dart';
import '../screens/DrawerScreen.dart';
import '../screens/SearchScreen.dart';
import '../screens/LiveStreamsScreen.dart';
import '../providers/RadioModel.dart';
import '../screens/ArticlesScreen.dart';
import '../screens/RadiosScreen.dart';
import '../i18n/strings.g.dart';
import '../utils/my_colors.dart';
import 'package:provider/provider.dart';
import 'package:admob_flutter/admob_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RadioModel(context)),
      ],
      child: HomePageItem(),
    );
  }
}

class HomePageItem extends StatefulWidget {
  HomePageItem({
    Key key,
  }) : super(key: key);

  final List<Widget> _widgetOptions = <Widget>[
    ChangeNotifierProvider(
      create: (context) => DashboardModel(),
      child: DashboardScreen(),
    ),
    ArticlesScreen(),
    ChangeNotifierProvider(
      create: (context) => LiveStreamsModel(),
      child: LiveStreamsScreen(),
    ),
    RadiosScreen(),
    ChangeNotifierProvider(
      create: (context) => MediaScreensModel(),
      child: HomeCategoriesScreen(),
    ),
    ArticlesScreen(),
  ];

  @override
  _HomePageItemState createState() => _HomePageItemState();
}

class _HomePageItemState extends State<HomePageItem> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;
  bool _headerVisibility = true;
  bool _mediaVisibility = false;
  ScrollController _controller;
  String pinNo = "";
  AdmobInterstitial interstitialAd;
  bool isAdmobLoaded = false;
  bool isFacebookLoaded = false;

  void loadInterstitialAds() {
    interstitialAd = AdmobInterstitial(
      adUnitId: Adverts.getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        print("interstital event" + event.toString());
        if (event == AdmobAdEvent.loaded) isAdmobLoaded = true;
      },
    );
    interstitialAd.load();
  }

  void loadFacebookAds() {
    FacebookAudienceNetwork.loadInterstitialAd(
      placementId: Adverts.getFacebookInterstitalAdUnit(),
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          isFacebookLoaded = true;
        }
      },
    );
  }

  rateApp() {
    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 3,
      minLaunches: 5,
      remindDays: 3,
      remindLaunches: 5,
      googlePlayIdentifier: 'streama.buzz.africa',
      appStoreIdentifier: '1491556149',
    );

    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(
          context,
          title: 'Rate this app', // The dialog title.
          message:
              'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
          rateButton: 'RATE', // The dialog "rate" button text.
          noButton: 'NO THANKS', // The dialog "no" button text.
          laterButton: 'MAYBE LATER', // The dialog "later" button text.
          listener: (button) {
            // The button click listener (useful if you want to cancel the click event).
            switch (button) {
              case RateMyAppDialogButton.rate:
                print('Clicked on "Rate".');
                break;
              case RateMyAppDialogButton.later:
                print('Clicked on "Later".');
                break;
              case RateMyAppDialogButton.no:
                print('Clicked on "No".');
                break;
            }

            return true; // Return false if you want to cancel the click event.
          },
          //ignoreNativeDialog: Platform
          //    .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
          dialogStyle: const DialogStyle(), // Custom dialog styles.
          onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
              .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
          // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
          // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    FacebookAudienceNetwork.init(
      testingId: "1088310f-6b33-4720-ba74-0c218bcc7a86", //optional
    );
    //loadInterstitialAds();
    //loadFacebookAds();
    rateApp();
    _controller = ScrollController();
    Future.delayed(const Duration(milliseconds: 500), () {
      Provider.of<AppStateNotifier>(context, listen: false).setContext(context);
    });
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      pageSnapping: false,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: widget._widgetOptions,
    );
  }

  void pageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookmarksModel = Provider.of<BookmarksModel>(context);
    int pinsSize = bookmarksModel.pinnedArticles.length +
        bookmarksModel.pinnedVideos.length;
    print("pinNo = " + pinsSize.toString());
    if (pinsSize != 0) {
      setState(() {
        pinNo = pinsSize > 9 ? "9+" : pinsSize.toString();
      });
    } else {
      pinNo = "";
      setState(() {});
    }

    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text("Close App"),
                content:
                    new Text("Already done? Do you want to close app now."),
                actions: <Widget>[
                  new TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text("Cancel"),
                  ),
                  new TextButton(
                    onPressed: () {
                      if (isAdmobLoaded) {
                        print("Admob loaded");
                        interstitialAd.show();
                      } else {
                        print("Admob not loaded");
                      }
                      Navigator.of(context).pop(true);
                    },
                    child: new Text("Ok"),
                  ),
                ],
              ),
            )) ??
            false;
        /*if (!isAdShown) {
          return (await showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: new Text("Rate Us"),
                  content: new Text(
                      "You like this app ? Then take a little bit of your time to leave a rating."),
                  actions: <Widget>[
                    new TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text("Close App"),
                    ),
                    new TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: new Text("Rate App"),
                    ),
                  ],
                ),
              )) ??
              false;
        } else {
          if (Provider.of<AppStateNotifier>(context, listen: false)
              .loadFacebookAds) {
            if (isFacebookLoaded) {
              isAdShown = true;
              FacebookInterstitialAd.showInterstitialAd(delay: 0);
              return false;
            }
            return true;
          } else {
            if (isAdmobLoaded) {
              interstitialAd.show();
              isAdShown = true;
              return false;
            } else {
              return true;
            }
          }
        }*/
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.appname),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: (() {
                  Navigator.pushNamed(context, SearchScreen.routeName);
                }))
          ],
        ),
        body: Column(
          children: <Widget>[
            /* Visibility(
                visible: false,
                maintainState: true,
                child: categoriesNavHeader(_controller)),*/
            Expanded(child: buildPageView()),
            Visibility(visible: true, child: MiniPlayer()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: MyColors.primary,
          unselectedItemColor: MyColors.grey_40,
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() {
              currentIndex = index;

              if (index == 2) {
                _headerVisibility = true;
              } else {
                _headerVisibility = false;
              }
              if (index == 3) {
                _mediaVisibility = true;
              } else {
                _mediaVisibility = false;
              }
            });
            pageController.jumpToPage(index);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chrome_reader_mode,
                ),
                label: t.articlesnav),
            BottomNavigationBarItem(
                icon: Icon(Icons.live_tv), label: t.livetvnav),
            BottomNavigationBarItem(icon: Icon(Icons.radio), label: t.radionav),
            BottomNavigationBarItem(
                icon: Icon(Icons.audiotrack), label: "E-Zone"),
          ].toList(),
        ),
        drawer: Container(
          color: MyColors.grey_95,
          width: 350,
          child: Drawer(
            key: scaffoldKey,
            child: DrawerScreen(),
          ),
        ),
      ),
    );
  }
}
