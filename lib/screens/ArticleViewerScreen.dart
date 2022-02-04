import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsextra/models/ScreenArguements.dart';
import 'package:newsextra/utils/Adverts.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;
import '../providers/BookmarksModel.dart';
import '../providers/AppStateNotifier.dart';
import '../models/Articles.dart';
import '../screens/CommentsScreen.dart';
import '../models/CommentsArguement.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';
import '../models/Userdata.dart';
import '../i18n/strings.g.dart';
import '../screens/Banneradmob.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

class ArticleViewerScreen extends StatefulWidget {
  static String routeName = "/articleviewer";
  final List<Articles> articlesList;
  final int position;

  ArticleViewerScreen({Key key, this.articlesList, this.position})
      : super(key: key);

  @override
  _ArticleViewerScreenState createState() => _ArticleViewerScreenState();
}

class _ArticleViewerScreenState extends State<ArticleViewerScreen> {
  Userdata _userdata;
  PageController _pageController;
  int currentPage = 0;
  int commentsCount = 0;
  int likesCount = 0;
  int viewsCount = 0;
  bool isLiked = false;

  Future<void> getArticleLikesCommentsViewsCount() async {
    try {
      var data = {
        "post_id": widget.articlesList[currentPage].id,
        "feed_type": "article",
      };
      if (_userdata != null) {
        data = {
          "post_id": widget.articlesList[currentPage].id,
          "feed_type": "article",
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
    var data = {
      "post_id": widget.articlesList[currentPage].id,
      "feed_type": "article",
    };
    print(data.toString());
    try {
      final response = await http.post(
          Uri.parse(ApiUrl.update_post_total_views),
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
      "post_id": widget.articlesList[currentPage].id,
      "feed_type": "article",
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

  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(
      url: widget.articlesList[currentPage].link,
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
  }

  _navigatetoCommentsScreen(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    var count = await Navigator.pushNamed(
      context,
      CommentsScreen.routeName,
      arguments: CommentsArguement(
          type: "article",
          item: widget.articlesList[currentPage],
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
            title: Text(widget.articlesList[currentPage].source),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.share,
                  ),
                  onPressed: () {
                    Share.share(
                        widget.articlesList[currentPage].link +
                            "Download App: https://play.google.com/store/apps/details?id=streama.buzz.africa",
                        subject: widget.articlesList[currentPage].title);
                  }),
              Consumer<BookmarksModel>(
                builder: (context, bookmarksModel, child) {
                  bool isBookmarked = Provider.of<BookmarksModel>(context,
                          listen: false)
                      .isArticleBookMarked(widget.articlesList[currentPage].id);
                  return IconButton(
                      icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white),
                      onPressed: () {
                        if (isBookmarked)
                          bookmarksModel.unBookmarkArticle(
                              widget.articlesList[currentPage].id);
                        else
                          bookmarksModel.bookmarkArticle(
                              widget.articlesList[currentPage]);
                      });
                },
              ),
              Container(
                width: 10,
              )
            ]),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    pageSnapping: true,
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                      getArticleLikesCommentsViewsCount();
                      Future.delayed(const Duration(seconds: 2), () {
                        updateViewsCount();
                      });
                    },
                    itemBuilder: (context, position) {
                      return ArticleItem(
                          article: widget.articlesList[position],
                          position: position);
                    },
                    itemCount: widget.articlesList.length, // Can be null
                  ),
                ),
              ]),
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
                                color: isLiked ? Colors.pink : Colors.grey[700],
                                size: 22,
                              ),
                              likesCount == 0
                                  ? Container()
                                  : Text(likesCount.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
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
                              Icon(Icons.insert_comment, color: Colors.teal),
                              commentsCount == 0
                                  ? Container()
                                  : Text(commentsCount.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                      )),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            FaIcon(
                              FontAwesomeIcons.solidEye,
                              color: Colors.grey[700],
                              size: 22,
                            ),
                            viewsCount == 0
                                ? Container()
                                : Text(viewsCount.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    )),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            openBrowserTab();
                          },
                          child: FaIcon(
                            FontAwesomeIcons.chrome,
                            color: Colors.grey[700],
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleItem extends StatefulWidget {
  const ArticleItem({
    Key key,
    @required this.article,
    @required this.position,
  }) : super(key: key);

  final Articles article;
  final int position;

  @override
  _ArticleItemState createState() => _ArticleItemState();
}

class _ArticleItemState extends State<ArticleItem> {
  bool isLoadingContent = false;
  bool isFailedToLoadContent = false;
  String content = "";
  List<Articles> relatedPosts = [];

  Future<void> fetchRelatedArticles() async {
    relatedPosts = [];
    try {
      var data = {"interest": widget.article.interest, "id": widget.article.id};

      final response = await http.post(Uri.parse(ApiUrl.RelatedARTICLES),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final res = jsonDecode(response.body);
        final parsed = res["feeds"].cast<Map<String, dynamic>>();
        relatedPosts =
            parsed.map<Articles>((json) => Articles.fromJson(json)).toList();
        setState(() {});
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  fetchContent() async {
    try {
      var data = {"id": widget.article.id};
      final response = await http.post(Uri.parse(ApiUrl.getArticleContent),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        Map<String, dynamic> res = json.decode(response.body);
        setState(() {
          isLoadingContent = false;
          isFailedToLoadContent = false;
          content = res['content'];
        });
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setState(() {
        isLoadingContent = false;
        isFailedToLoadContent = true;
      });
    }
  }

  @override
  void initState() {
    content = widget.article.content;
    if (content == "") {
      setState(() {
        isLoadingContent = true;
      });
      fetchContent();
    }
    relatedPosts = [];
    fetchRelatedArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(widget.article.title,
                        style: TextStyles.display1(context).copyWith(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                  ),
                  Container(height: 5),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(widget.article.date,
                        style: TextStyles.subhead(context)),
                  ),
                  Container(height: 20),
                  Consumer<AppStateNotifier>(
                      builder: (context, appState, child) {
                    if (appState.loadArticlesImages) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: InteractiveViewer(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.article.thumbnail,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black12, BlendMode.darken)),
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
                          ),
                        ),
                        width: double.infinity,
                        height: 250,
                      );
                    } else {
                      return Container();
                    }
                  }),
                  Container(height: 15),
                  Container(height: 10),
                  buildArticleContent(context),
                  Container(height: 10),
                  AdmobNativeAds(),
                  Container(height: 20),
                  relatedPosts.length == 0
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(t.relatedposts,
                                  style: TextStyles.headline(context).copyWith(
                                      fontFamily: "serif",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                width: 100,
                                height: 2,
                                color: MyColors.primary,
                              )
                            ],
                          ),
                        ),
                  Container(height: 10),
                  relatedPosts.length == 0
                      ? Container()
                      : Container(
                          height: 180,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: ListView.builder(
                              itemCount: relatedPosts.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext ctxt, int i) {
                                return ItemRelatedTile(
                                  index: i,
                                  object: relatedPosts[i],
                                  articles: relatedPosts,
                                );
                              }),
                        ),
                  Container(height: 30),
                ],
              ),
            );
          }, childCount: 1),
        )
      ],
    );
  }

  Widget buildArticleContent(BuildContext context) {
    if (isLoadingContent) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    } else if (isFailedToLoadContent) {
      return Center(
          child: Container(
        height: 200,
        child: GestureDetector(
          onTap: () {
            setState(() {
              isLoadingContent = true;
            });
            fetchContent();
          },
          child: ListView(children: <Widget>[
            Icon(
              Icons.refresh,
              size: 50.0,
              color: Colors.red,
            ),
            Text(
              t.errorloadingarticlecontent,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            )
          ]),
        ),
      ));
    } else
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Text(content,
            // textAlign: TextAlign.center,
            style: TextStyles.medium(context)),
      );
  }
}

class ItemRelatedTile extends StatelessWidget {
  final Articles object;
  final int index;
  final List<Articles> articles;

  const ItemRelatedTile({
    Key key,
    @required this.index,
    @required this.object,
    @required this.articles,
  })  : assert(index != null),
        assert(object != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          ArticleViewerScreen.routeName,
          arguments: ScreenArguements(position: index, items: articles),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(0),
          ),
          child: Container(
            height: 180,
            width: 150,
            child: Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: object.thumbnail,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black12, BlendMode.darken)),
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
                Container(
                    color: Colors.black.withOpacity(0.2),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Spacer(),
                        Text(object.title,
                            maxLines: 3,
                            style: TextStyles.medium(context).copyWith(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        Container(height: 10),
                        Container(height: 5),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
