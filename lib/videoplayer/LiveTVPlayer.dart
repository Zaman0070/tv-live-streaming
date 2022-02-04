import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:better_player/better_player.dart';
import 'package:newsextra/models/UserEvents.dart';
import 'package:newsextra/providers/events.dart';
import 'package:newsextra/screens/Banneradmob.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import 'package:newsextra/viewholders/LiveTvItemTile.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';
import '../models/LiveStreams.dart';
import '../screens/EmptyListScreen.dart';
import '../utils/Utility.dart';
import '../video_player/LiveYoutubePlayer.dart';

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

class _VideoPlayerState extends State<LiveTVPlayer>
    with TickerProviderStateMixin {
  List<LiveStreams> playlist = [];
  bool expand1 = false;
  BetterPlayerController _betterPlayerController;
  LiveStreams currentMedia;
  Future<BetterPlayerController> reloadController;

  @override
  void initState() {
    eventBus.fire(OnVideoStarted());
    playlist = Utility.removeCurrentLiveStreamsFromList(
        widget.mediaList, widget.media);
    currentMedia = widget.media;
    reloadController = playVideoStream();
    //playVideoStream();
    //print("play url = " + url);
    super.initState();
  }

  playVideoItem(LiveStreams media) {
    setState(() {
      playlist =
          Utility.removeCurrentLiveStreamsFromList(widget.mediaList, media);
      currentMedia = media;
      _betterPlayerController?.pause();
      if (currentMedia.type == "m3u8" || currentMedia.type == "rtmp") {
        reloadController = playVideoStream();
      }
    });
  }

  Future<BetterPlayerController> playVideoStream() async {
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, currentMedia.streamurl);
    _betterPlayerController = new BetterPlayerController(
        BetterPlayerConfiguration(
          aspectRatio: 3 / 2,
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
            placeholder: (context, url) =>
                Center(child: CupertinoActivityIndicator()),
            errorWidget: (context, url, error) => Center(
                child: Icon(
              Icons.error,
              color: Colors.grey,
            )),
          ),
          autoPlay: true,
          allowedScreenSleep: false,
          //showControlsOnInitialize: true,
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
            getInfoContainer(),
            (playlist.length == 0)
                ? Expanded(
                    child: Expanded(
                      child: EmptyListScreen(
                        message: "No Playlist",
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                      itemCount: playlist.length,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(3),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 1.2),
                      itemBuilder: (BuildContext context, int index) {
                        return LiveTvItemTile(
                          onclick: playVideoItem,
                          object: playlist[index],
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
    if (currentMedia.type == "m3u8" || currentMedia.type == "rtmp") {
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
          Container(
            alignment: Alignment.centerLeft,
            //height: 50,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(currentMedia.title,
                    maxLines: 3,
                    style: TextStyles.headline(context)
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ),
          Container(height: 15),
          Banneradmob(),
          Container(height: 15),
          Divider(),
          Container(height: 5),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("LiveTV Playlists",
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
