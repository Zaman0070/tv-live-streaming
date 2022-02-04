import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../providers/ArticlesModel.dart';
import '../models/Articles.dart';
import '../viewholders/ArticlesListView.dart';
import '../utils/TextStyles.dart';
import '../i18n/strings.g.dart';
import '../providers/AppStateNotifier.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

class ArticlesScreen extends StatefulWidget {
  ArticlesScreen();

  @override
  ArticlesScreenRouteState createState() => new ArticlesScreenRouteState();
}

class ArticlesScreenRouteState extends State<ArticlesScreen>
    with AutomaticKeepAliveClientMixin {
  BuildContext context;
  var articlesModel;
  var appState;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<ArticlesModel>(context, listen: false).setWidgetsInit(true);
      Provider.of<ArticlesModel>(context, listen: false).fetchOnFirstLoad();
    });
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
    articlesModel = Provider.of<ArticlesModel>(context);
    articlesModel.setCategories(appState.selectedcats);
    items = articlesModel.items;

    void _onRefresh() async {
      articlesModel.fetchArticles();
    }

    void _onLoading() async {
      articlesModel.fetchMoreArticles();
    }

    return SmartRefresher(
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
      child: (articlesModel.isError == true || articlesModel.items.length == 0)
          ? Center(
              child: Text(t.articlesloaderrormsg,
                  textAlign: TextAlign.center,
                  style: TextStyles.medium(context)),
            )
          : buildArticlesListView(appState, items),
    );
  }
}
