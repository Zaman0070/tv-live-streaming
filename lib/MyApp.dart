import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:newsextra/audio_player/RadioPlayerPage.dart';
import 'package:newsextra/audio_player/player_page.dart';
import 'package:newsextra/comments/MediaCommentsScreen.dart';
import 'package:newsextra/comments/MediaRepliesScreen.dart';
import 'package:newsextra/livestreamcomments/LiveStreamRepliesScreen.dart';
import 'package:newsextra/livestreamcomments/LivestreamsCommentsScreen.dart';
import 'package:newsextra/radiocomments/RadioCommentsScreen.dart';
import 'package:newsextra/radiocomments/RadioRepliesScreen.dart';
import 'package:newsextra/screens/CategoriesMediaScreen.dart';
import 'package:newsextra/screens/ComplaintsScreen.dart';
import 'package:newsextra/screens/CountryScreen.dart';
import 'package:newsextra/screens/CreateRadioScreen.dart';
import 'package:newsextra/screens/DownloadItemsScreen.dart';
import 'package:newsextra/screens/Downloader.dart';
import 'package:newsextra/screens/FavoritesScreen.dart';
import 'package:newsextra/screens/MediaCategoriesScreen.dart';
import 'package:newsextra/screens/RadioRecordingsScreen.dart';
import 'package:newsextra/screens/SubscriptionScreen.dart';
import 'package:newsextra/screens/UploadMediaScreen.dart';
import 'package:newsextra/videoplayer/VideoPlayer.dart';
import './screens/VideosSourceFeedScreen.dart';
import './utils/TextStyles.dart';
import './screens/ArticleViewerScreen.dart';
import './models/ScreenArguements.dart';
import './screens/VideoViewerScreen.dart';
import './screens/FeedSourcesScreen.dart';
import './screens/weather_screen.dart';
import './screens/LoginScreen.dart';
import './screens/OnboardingPage.dart';
import './screens/CommentsScreen.dart';
import './screens/RepliesScreen.dart';
import './i18n/strings.g.dart';
import './screens/ForgotPasswordScreen.dart';
import './screens/RegisterScreen.dart';
import './video_player/LiveTVPlayer.dart';
import './models/Articles.dart';
import './providers/AppStateNotifier.dart';
import './screens/HomePage.dart';
import './screens/CategoriesScreen.dart';
import './screens/SourcesScreen.dart';
import './screens/SearchScreen.dart';
import './models/CommentsArguement.dart';
import './models/Videos.dart';
import 'package:provider/provider.dart';
import './utils/Firebase.dart';
import './utils/AppTheme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:admob_flutter/admob_flutter.dart';
import './utils/Adverts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyApp extends StatefulWidget {
  const MyApp({
    Key key,
    @required Widget defaultHome,
  })  : _defaultHome = defaultHome,
        super(key: key);

  final Widget _defaultHome;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");
  BuildContext context;
  AdmobInterstitial interstitialAd;
  bool isAdmobLoaded = false;
  bool isFacebookLoaded = false;

  navigateArticle(List<Articles> artsList) async {
    var count = await navigatorKey.currentState.pushNamed(ArticleViewerScreen.routeName, arguments: ScreenArguements(position: 0, items: artsList));

    if (count == 0) {
      if (isAdmobLoaded) {
        interstitialAd.show();

        interstitialAd.load();
      }
    }
  }

  navigateVideo(List<Videos> vidsList) async {
    var count = await navigatorKey.currentState.pushNamed(VideoViewerScreen.routeName, arguments: ScreenArguements(position: 0, items: vidsList));

    if (count == 0) {
      if (Provider.of<AppStateNotifier>(context, listen: false).loadFacebookAds) {
        if (isFacebookLoaded) {
          FacebookInterstitialAd.showInterstitialAd(delay: 0);
          loadFacebookAds();
        }
      } else {
        if (isAdmobLoaded) {
          interstitialAd.show();
          interstitialAd.load();
        }
      }
    }
  }

  void loadFacebookAds() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: Adverts.getFacebookInterstitalAdUnit(),
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          isFacebookLoaded = true;
        }
      },
    );
  }

  void loadInterstitialAds() {
    interstitialAd = AdmobInterstitial(
      adUnitId: Adverts.getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        print("interstital event" + event.toString());
        if (event == AdmobAdEvent.loaded) isAdmobLoaded = true; //
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    interstitialAd.load();
  }

  initFirebasePushNotifications() async {
    Firebase(context, navigateArticle, navigateVideo).init();
  }

  @override
  void initState() {
    FacebookAudienceNetwork.init(
      testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
    );
    Future.delayed(const Duration(milliseconds: 1000), () {
      initFirebasePushNotifications();
      loadInterstitialAds();
      loadFacebookAds();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final appState = Provider.of<AppStateNotifier>(context);
    final platform = Theme.of(context).platform;

    return RefreshConfiguration(
      footerTriggerDistance: 15,
      dragSpeedRatio: 0.91,
      headerBuilder: () => MaterialClassicHeader(),
      footerBuilder: () => ClassicFooter(),
      enableLoadingWhenNoData: false,
      shouldFooterFollowWhenNotFull: (state) {
        // If you want load more with noMoreData state ,may be you should return false
        return false;
      },

      // autoLoad: true,
      child: Directionality(
        textDirection: appState.isRtlEnabled ? TextDirection.rtl : TextDirection.ltr,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'App',
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            Locale("fa", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
            Locale("en"),
          ],
          locale: appState.isRtlEnabled ? Locale("fa", "IR") : Locale("en"),
          home: appState.isLoadingTheme
              ? Container(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(height: 10),
                          Text(t.appname,
                              style: TextStyles.medium(context).copyWith(fontFamily: "serif", color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)),
                          Container(height: 12),
                          Text(t.loadingapp, style: TextStyles.body1(context).copyWith(color: Colors.grey[500])),
                          Container(height: 50),
                          CupertinoActivityIndicator(
                            radius: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : widget._defaultHome,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme, // ThemeData(primarySwatch: Colors.blue),
          darkTheme: AppTheme.darkTheme, // ThemeData(primarySwatch: Colors.blue),
          themeMode: appState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,

          onGenerateRoute: (settings) {
            if (settings.name == HomePage.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return HomePage();
                },
              );
            }
            if (settings.name == DownloadItemsScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return DownloadItemsScreen();
                },
              );
            }
            if (settings.name == CountryScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return CountryScreen(
                    isFirstLoad: false,
                  );
                },
              );
            }

            if (settings.name == VideoPlayer.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return VideoPlayer(
                    media: args.object,
                    mediaList: args.items,
                  );
                },
              );
            }

            if (settings.name == PlayPage.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return PlayPage();
                },
              );
            }

            if (settings.name == ComplaintsScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return ComplaintsScreen();
                },
              );
            }

            if (settings.name == CreateRadioScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return CreateRadioScreen();
                },
              );
            }

            if (settings.name == UploadMediaScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return UploadMediaScreen();
                },
              );
            }

            if (settings.name == RadioRecordingsScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return RadioRecordingsScreen();
                },
              );
            }

            if (settings.name == FavoritesScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return FavoritesScreen();
                },
              );
            }

            if (settings.name == RadioPlayerPage.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return RadioPlayerPage();
                },
              );
            }

            if (settings.name == Downloader.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return Downloader(downloads: args.object, platform: platform);
                },
              );
            }

            if (settings.name == SubscriptionScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return SubscriptionScreen();
                },
              );
            }

            if (settings.name == CategoriesMediaScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return CategoriesMediaScreen(
                    categories: args.object,
                  );
                },
              );
            }

            if (settings.name == MediaCategoriesScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return MediaCategoriesScreen();
                },
              );
            }

            if (settings.name == OnboardingPage.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return OnboardingPage();
                },
              );
            }
            if (settings.name == OnboardingPage.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return OnboardingPage();
                },
              );
            }

            if (settings.name == CategoriesScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return CategoriesScreen(
                    isFirstLoad: false,
                  );
                },
              );
            }
            if (settings.name == SourcesScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return SourcesScreen();
                },
              );
            }
            if (settings.name == SearchScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return SearchScreen();
                },
              );
            }
            // ArticleViewerScreen
            if (settings.name == ArticleViewerScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return ArticleViewerScreen(
                    position: args.position,
                    articlesList: args.items,
                  );
                },
              );
            }
            if (settings.name == FeedSourcesScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return FeedSourcesScreen(
                    article: args.object,
                  );
                },
              );
            }
            if (settings.name == VideosSourceFeedScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return VideosSourceFeedScreen(
                    videos: args.object,
                  );
                },
              );
            }
            if (settings.name == VideoViewerScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return VideoViewerScreen(
                    position: args.position,
                    videosList: args.items,
                  );
                },
              );
            }

            if (settings.name == CommentsScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final CommentsArguement args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return CommentsScreen(
                    type: args.type,
                    item: args.item,
                    commentCount: args.commentCount,
                  );
                },
              );
            }

            if (settings.name == RepliesScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final CommentsArguement args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return RepliesScreen(
                    item: args.item,
                    repliesCount: args.commentCount,
                  );
                },
              );
            }

            if (settings.name == MediaCommentsScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final CommentsArguement args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return MediaCommentsScreen(
                    item: args.item,
                    commentCount: args.commentCount,
                  );
                },
              );
            }

            if (settings.name == MediaRepliesScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final CommentsArguement args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return MediaRepliesScreen(
                    item: args.item,
                    repliesCount: args.commentCount,
                  );
                },
              );
            }

            if (settings.name == RadioCommentsScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final CommentsArguement args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return RadioCommentsScreen(
                    item: args.item,
                    commentCount: 0,
                  );
                },
              );
            }

            if (settings.name == RadioRepliesScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final CommentsArguement args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return RadioRepliesScreen(
                    item: args.item,
                    repliesCount: args.commentCount,
                  );
                },
              );
            }

            if (settings.name == LivestreamsCommentsScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final CommentsArguement args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return LivestreamsCommentsScreen(
                    item: args.item,
                    commentCount: args.commentCount,
                  );
                },
              );
            }

            if (settings.name == LiveStreamRepliesScreen.routeName) {
              // Cast the arguments to the correct type: ScreenArguments.
              final CommentsArguement args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return LiveStreamRepliesScreen(
                    item: args.item,
                    repliesCount: args.commentCount,
                  );
                },
              );
            }

            if (settings.name == WeatherScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return WeatherScreen();
                },
              );
            }

            if (settings.name == LoginScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              );
            }

            if (settings.name == RegisterScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return RegisterScreen();
                },
              );
            }

            if (settings.name == ForgotPasswordScreen.routeName) {
              return MaterialPageRoute(
                builder: (context) {
                  return ForgotPasswordScreen();
                },
              );
            }

            if (settings.name == LiveTVPlayer.routeName) {
              final ScreenArguements args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return LiveTVPlayer(
                    media: args.object,
                    mediaList: args.items,
                  );
                },
              );
            }

            return MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            );
          },
        ),
      ),
    );
  }
}
