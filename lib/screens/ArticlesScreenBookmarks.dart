import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../providers/BookmarksModel.dart';
import '../models/Articles.dart';
import '../utils/TextStyles.dart';
import '../i18n/strings.g.dart';
import '../utils/my_colors.dart';
import '../providers/AppStateNotifier.dart';
import '../viewholders/ArticlesListView.dart';
import 'package:provider/provider.dart';

class ArticlesScreenBookmarks extends StatelessWidget {
  ArticlesScreenBookmarks();

  @override
  Widget build(BuildContext context) {
    List<Articles> items = [];
    final appState = Provider.of<AppStateNotifier>(context);
    final bookmarksModel = Provider.of<BookmarksModel>(context);
    items = bookmarksModel.pinnedArticles;

    void onItemClick(int indx) {}

    return items.length == 0
        ? Center(
            child: Text(t.nobookmarkedarticles,
                textAlign: TextAlign.center,
                style: TextStyles.medium(context)
                    .copyWith(color: MyColors.grey_60)),
          )
        : buildBookmarkedArticlesListView(appState, items, onItemClick);
  }
}
