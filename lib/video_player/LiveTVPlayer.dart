import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:newsextra/livestreamcomments/LivestreamsCommentsScreen.dart';
import 'package:newsextra/models/CommentsArguement.dart';
import 'package:newsextra/models/UserEvents.dart';
import 'package:newsextra/providers/events.dart';
import '../screens/Banneradmob.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';
import '../models/LiveStreams.dart';
import '../i18n/strings.g.dart';
import '../screens/EmptyListScreen.dart';
import '../utils/Utility.dart';
import '../video_player/LiveYoutubePlayer.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

class LiveTVPlayer extends StatefulWidget {
  static const routeName = "/livetvplayer";
  LiveTVPlayer({this.media, this.mediaList});
  final LiveStreams media;
  final List<LiveStreams> mediaList;

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerState();
  }
}

class _VideoPlayerState extends State<LiveTVPlayer> with TickerProviderStateMixin {
  List<LiveStreams> playlist = [];
  bool expand1 = false;
  BetterPlayerController _betterPlayerController;
  LiveStreams currentMedia;
  Future<BetterPlayerController> reloadController;

  @override
  void initState() {
    playlist = Utility.removeCurrentLiveStreamsFromList(widget.mediaList, widget.media);
    currentMedia = widget.media;
    reloadController = playVideoStream();
    eventBus.fire(OnVideoStarted());
    //playVideoStream();
    //print("play url = " + url);
    super.initState();
  }

  playVideoItem(LiveStreams media) {
    print(media.title);
    setState(() {
      playlist = Utility.removeCurrentLiveStreamsFromList(widget.mediaList, media);
      currentMedia = media;
      _betterPlayerController?.pause();
      if (currentMedia.type == "m3u8" || currentMedia.type == "rtmp") {
        reloadController = playVideoStream();
      }
    });
  }

  Future<BetterPlayerController> playVideoStream() async {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network, currentMedia.streamurl);
    _betterPlayerController = new BetterPlayerController(
        BetterPlayerConfiguration(
          fullScreenByDefault: true,
          // aspectRatio: 3 / 2,
          placeholder: CachedNetworkImage(
            imageUrl: currentMedia.coverphoto,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
            errorWidget: (context, url, error) => Center(
                child: Icon(
              Icons.error,
              color: Colors.grey,
            )),
          ),
          autoPlay: true,
          allowedScreenSleep: false,
        ),
        betterPlayerDataSource: betterPlayerDataSource);
    // _betterPlayerController.addEventsListener((event) {
    //print("Better player event: ${event.betterPlayerEventType}");
    // });
    return _betterPlayerController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(height: 270, child: buildVideoContainer(currentMedia)),
            //getInfoContainer(),
            (playlist.length == 0)
                ? Expanded(
                    child: Column(
                      children: <Widget>[
                        getInfoContainer(),
                        Expanded(
                          child: EmptyListScreen(
                            message: t.emptyplaylist,
                          ),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: playlist.length + 1,
                      separatorBuilder: (BuildContext context, int index) => Divider(height: 1, color: Colors.grey),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return getInfoContainer();
                        }
                        LiveStreams liveStreams = playlist[index - 1];
                        return Container(
                          height: 60,
                          child: InkWell(
                            child: ListTile(
                                //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(liveStreams.coverphoto),
                                ),
                                title: Text(
                                  liveStreams.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                trailing: Icon(Icons.keyboard_arrow_right, size: 30.0)),
                            onTap: () {
                              playVideoItem(liveStreams);
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildVideoContainer(LiveStreams currentMedia) {
    if (currentMedia.type == "m3u8" || currentMedia.type == "rtmp" || currentMedia.type == "mpd") {
      return FutureBuilder<BetterPlayerController>(
        future: reloadController,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                controller: snapshot.data,
              ),
            );
          }
        },
      );
    } else if (currentMedia.type == "youtube") {
      return LiveYoutubePlayer(media: currentMedia, key: UniqueKey());
    } else if (currentMedia.type == "embeded") {
      print("========its a live video from iframe=============");
      return Container(
        color: Colors.black,
        child: HtmlWidget(
          '<iframe src="' + currentMedia.streamurl + '"></iframe>',
          factoryBuilder: () => MyWidgetFactory(),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget getInfoContainer() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      // height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  //height: 50,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(currentMedia.title, maxLines: 3, style: TextStyles.headline(context).copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    LivestreamsCommentsScreen.routeName,
                    arguments: CommentsArguement(item: currentMedia, commentCount: 0),
                  );
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.insert_comment, color: MyColors.primaryDark, size: 26),
                  ],
                ),
              ),
              Container(
                width: 25,
              ),
              currentMedia.extra == ""
                  ? Container()
                  : InkWell(
                      onTap: () async {
                        await FlutterWebBrowser.openWebPage(
                          url: currentMedia.extra,
                          customTabsOptions: CustomTabsOptions(
                            colorScheme: CustomTabsColorScheme.dark,
                            toolbarColor: MyColors.primary,
                            secondaryToolbarColor: MyColors.primary,
                            navigationBarColor: MyColors.primary,
                            addDefaultShareMenuItem: true,
                            instantAppsEnabled: true,
                            showTitle: true,
                            urlBarHidingEnabled: true,
                          ),
                          safariVCOptions: SafariViewControllerOptions(
                            barCollapsingEnabled: true,
                            preferredBarTintColor: MyColors.primary,
                            preferredControlTintColor: MyColors.primary,
                            dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
                            modalPresentationCapturesStatusBarAppearance: true,
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.open_in_browser, color: Colors.blue, size: 26),
                        ],
                      ),
                    ),
              Container(
                width: 12,
              )
            ],
          ),
          Container(height: 15),
          Banneradmob(),
          Container(height: 15),
          Divider(),
          Container(height: 5),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(t.livetvPlaylists,
                maxLines: 1,
                style: TextStyles.subhead(context).copyWith(
                  fontSize: 15,
                  color: MyColors.grey_90,
                )),
          ),
          Container(height: 10),
          Divider(),
          Container(height: 5),
        ],
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with WebViewFactory {
  bool get webViewMediaPlaybackAlwaysAllow => true;
  String get webViewUserAgent => 'My app';
}
