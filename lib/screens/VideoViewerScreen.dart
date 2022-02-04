import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../providers/BookmarksModel.dart';
import 'package:share/share.dart';
import '../screens/Banneradmob.dart';
import '../utils/TextStyles.dart';
import '../providers/AppStateNotifier.dart';
import '../utils/my_colors.dart';
import '../models/Userdata.dart';
import 'dart:convert';
import 'dart:async';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;
import '../models/Videos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../screens/CommentsScreen.dart';
import '../models/CommentsArguement.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoViewerScreen extends StatefulWidget {
  static String routeName = "/videoviewer";
  final List<Videos> videosList;
  final int position;

  VideoViewerScreen({Key key, this.videosList, this.position})
      : super(key: key);

  @override
  _VideoViewerScreenState createState() => _VideoViewerScreenState();
}

class _VideoViewerScreenState extends State<VideoViewerScreen> {
  PageController _pageController;
  int currentPage = 0;
  int commentsCount = 0;
  int likesCount = 0;
  int viewsCount = 0;
  bool isLiked = false;
  Userdata _userdata;

  Future<void> getArticleLikesCommentsViewsCount() async {
    try {
      var data = {
        "post_id": widget.videosList[currentPage].id,
        "feed_type": "video",
      };
      if (_userdata != null) {
        data = {
          "post_id": widget.videosList[currentPage].id,
          "feed_type": "video",
          "email": _userdata.email
        };
      }
      print("query articles data = " + data.toString());
      final response = await http.post(
          Uri.parse(ApiUrl.gettotallikesandcommentsviews),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        Map<String, dynamic> res = json.decode(response.body);
        setState(() {
          commentsCount = int.parse(res['total_comments'].toString());
          likesCount = int.parse(res['total_likes'].toString());
          viewsCount = int.parse(res['total_views'].toString());
          isLiked = res['isLiked'] as bool;
        });
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  Future<void> updateViewsCount() async {
    try {
      final response =
          await http.post(Uri.parse(ApiUrl.update_post_total_views),
              body: jsonEncode({
                "data": {
                  "post_id": widget.videosList[currentPage].id,
                  "feed_type": "video",
                }
              }));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  Future<void> likePost(String action) async {
    if (_userdata == null) {
      return;
    }
    setState(() {
      if (action == "like") {
        likesCount += 1;
        isLiked = true;
      } else {
        likesCount -= 1;
        isLiked = false;
      }
    });
    var data = {
      "post_id": widget.videosList[currentPage].id,
      "feed_type": "video",
      "email": _userdata.email,
      "action": action
    };
    print(data.toString());
    try {
      final response = await http.post(Uri.parse(ApiUrl.likeunlikepost),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  _navigatetoCommentsScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    var count = await Navigator.pushNamed(
      context,
      CommentsScreen.routeName,
      arguments: CommentsArguement(
          type: "video",
          item: widget.videosList[currentPage],
          commentCount: commentsCount),
    );
    setState(() {
      commentsCount = count;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.position,
      keepPage: false,
    );
    currentPage = widget.position;
    Future.delayed(const Duration(seconds: 0), () {
      getArticleLikesCommentsViewsCount();
    });
    Future.delayed(const Duration(seconds: 5), () {
      updateViewsCount();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildWidgetAlbumCoverBlur() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(widget.videosList[currentPage].thumbnail),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userdata = Provider.of<AppStateNotifier>(context).userdata;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 0);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(widget.videosList[currentPage].source),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.share,
                  ),
                  onPressed: () {
                    Share.share(widget.videosList[currentPage].link,
                        subject: widget.videosList[currentPage].title);
                  }),
              Consumer<BookmarksModel>(
                builder: (context, bookmarksModel, child) {
                  bool isBookmarked =
                      Provider.of<BookmarksModel>(context, listen: false)
                          .isVideoBookmarked(widget.videosList[currentPage].id);
                  return IconButton(
                      icon: Icon(Icons.bookmark_border,
                          color:
                              isBookmarked ? Colors.redAccent : Colors.white),
                      onPressed: () {
                        if (isBookmarked)
                          bookmarksModel.unBookmarkArticle(
                              widget.videosList[currentPage].id);
                        else
                          bookmarksModel
                              .bookmarkVideo(widget.videosList[currentPage]);
                      });
                },
              ),
            ]),
        body: Stack(
          children: <Widget>[
            _buildWidgetAlbumCoverBlur(),
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.5)
                ],
              )),
            ),
            Column(
              children: <Widget>[
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                        getArticleLikesCommentsViewsCount();
                        Future.delayed(const Duration(seconds: 2), () {
                          updateViewsCount();
                        });
                      });
                    },
                    //pageSnapping: false,
                    scrollDirection: Axis.horizontal,
                    //pageSnapping: true,
                    itemBuilder: (context, position) {
                      return Player(
                        video: widget.videosList[position],
                      );
                    },
                    itemCount: widget.videosList.length, // Can be null
                  ),
                ),
                Banneradmob(),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 0.3,
                        width: double.infinity,
                        color: MyColors.grey_10,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                likePost(isLiked ? "unlike" : "like");
                              },
                              child: Row(
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.thumbsUp,
                                    color: isLiked ? Colors.pink : Colors.white,
                                    size: 22,
                                  ),
                                  likesCount == 0
                                      ? Container()
                                      : Text(likesCount.toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          )),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _navigatetoCommentsScreen(context);
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.insert_comment,
                                      color: Colors.teal),
                                  commentsCount == 0
                                      ? Container()
                                      : Text(commentsCount.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          )),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.solidEye,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                viewsCount == 0
                                    ? Container()
                                    : Text(viewsCount.toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Player extends StatefulWidget {
  final Videos video;
  Player({Key key, @required this.video}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> with WidgetsBindingObserver {
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.content,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
    _idController = TextEditingController();
    _seekToController = TextEditingController();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _controller.dispose();
      _idController.dispose();
      _seekToController.dispose();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5)
              ],
            )),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(widget.video.date.toUpperCase(),
                      style: TextStyles.subhead(context)
                          .copyWith(color: MyColors.grey_10)),
                  Container(
                    height: 10,
                  ),
                  Text(widget.video.title,
                      maxLines: 2,
                      style: TextStyles.display1(context).copyWith(
                          fontSize: 25,
                          color: MyColors.grey_3,
                          fontFamily: "serif")),
                  Container(
                      width: 100,
                      height: 2,
                      color: MyColors.grey_10,
                      margin: EdgeInsets.symmetric(vertical: 10)),
                  Container(
                    height: 20,
                  ),
                  Text(
                    widget.video.interest,
                    style: TextStyles.subhead(context).copyWith(
                        color: MyColors.grey_20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 20,
                  ),
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                    topActions: <Widget>[
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          _controller.metadata.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        onPressed: () {},
                      ),
                    ],
                    onReady: () {
                      //_isPlayerReady = true;
                    },
                    onEnded: (data) {
                      /*_controller
                  .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);*/
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
