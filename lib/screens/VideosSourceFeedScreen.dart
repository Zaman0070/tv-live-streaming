import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../providers/VideoSourceModel.dart';
import '../models/Videos.dart';
import '../viewholders/VideosListView.dart';
import '../utils/TextStyles.dart';
import '../i18n/strings.g.dart';
import '../providers/AppStateNotifier.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

class VideosSourceFeedScreen extends StatelessWidget {
  VideosSourceFeedScreen({Key key, this.videos});
  static String routeName = "/videosSourceFeedScreen";
  final Videos videos;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VideoSourceModel(),
      child: VideosSourceFeedListScreen(
        videos: this.videos,
      ),
    );
  }
}

class VideosSourceFeedListScreen extends StatefulWidget {
  VideosSourceFeedListScreen({Key key, this.videos});
  final Videos videos;

  @override
  VideosScreenRouteState createState() => new VideosScreenRouteState();
}

class VideosScreenRouteState extends State<VideosSourceFeedListScreen>
    with AutomaticKeepAliveClientMixin {
  BuildContext context;
  VideoSourceModel videosModel;
  var appState;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      //print("app state"+appState.toString());
      Provider.of<VideoSourceModel>(context, listen: false)
          .setWidgetsInit(true);
      Provider.of<VideoSourceModel>(context, listen: false)
          .fetchOnFirstLoad(widget.videos.sourceID);
    });
  }

  @override
  void dispose() {
    videosModel.setWidgetsInit(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    this.context = context;
    List<Videos> items = [];
    appState = Provider.of<AppStateNotifier>(context);
    videosModel = Provider.of<VideoSourceModel>(context);
    items = videosModel.items;

    void _onRefresh() async {
      videosModel.fetchArticles();
    }

    void _onLoading() async {
      videosModel.fetchMoreArticles();
    }

    Future.delayed(const Duration(milliseconds: 0), () {
      /* _scrollController.jumpTo(
          index: articlesModel.selectedcats
                          .indexOf(articlesModel.currentCategory),);*/
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videos.source),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text(t.pulluploadmore);
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text(t.loadfailedretry);
            } else if (mode == LoadStatus.canLoading) {
              body = Text(t.releaseloadmore);
            } else {
              body = Text(t.nomoredata);
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: videosModel.refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: (videosModel.isError == true && videosModel.items.length == 0)
            ? Center(
                child: Text(t.articlesloaderrormsg,
                    textAlign: TextAlign.center,
                    style: TextStyles.medium(context)),
              )
            : buildVideosSourceListView(appState, items),
      ),
    );
  }
}
