import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../providers/FeedsSourcesModel.dart';
import '../models/Articles.dart';
import '../viewholders/ArticlesListView.dart';
import '../utils/TextStyles.dart';
import '../i18n/strings.g.dart';
import '../providers/AppStateNotifier.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

class FeedSourcesScreen extends StatelessWidget {
  FeedSourcesScreen({Key key, this.article});
  static String routeName = "/feedsviewerscreen";
  final Articles article;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeedsSourcesModel(),
      child: FeedSourcesListsScreen(
        article: this.article,
      ),
    );
  }
}

class FeedSourcesListsScreen extends StatefulWidget {
  FeedSourcesListsScreen({Key key, this.article});
  final Articles article;

  @override
  ArticlesScreenRouteState createState() => new ArticlesScreenRouteState();
}

class ArticlesScreenRouteState extends State<FeedSourcesListsScreen>
    with AutomaticKeepAliveClientMixin {
  BuildContext context;
  FeedsSourcesModel articlesModel;
  var appState;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<FeedsSourcesModel>(context, listen: false)
          .setWidgetsInit(true);
      Provider.of<FeedsSourcesModel>(context, listen: false)
          .fetchOnFirstLoad(widget.article.sourceID);
    });
  }

  void _onRefresh() async {
    articlesModel.fetchArticles();
  }

  void _onLoading() async {
    articlesModel.fetchMoreArticles();
  }

  @override
  void dispose() {
    articlesModel.setWidgetsInit(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    this.context = context;
    List<Articles> items = [];
    appState = Provider.of<AppStateNotifier>(context);
    articlesModel = Provider.of<FeedsSourcesModel>(context);
    items = articlesModel.items;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.source),
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
        controller: articlesModel.refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child:
            (articlesModel.isError == true && articlesModel.items.length == 0)
                ? Center(
                    child: Text(t.articlesloaderrormsg,
                        textAlign: TextAlign.center,
                        style: TextStyles.medium(context)),
                  )
                : buildSourceArticlesListView(appState, items),
      ),
    );
  }
}
