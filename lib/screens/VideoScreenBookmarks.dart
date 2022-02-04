import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../providers/BookmarksModel.dart';
import '../models/Videos.dart';
import '../utils/TextStyles.dart';
import '../i18n/strings.g.dart';
import '../utils/my_colors.dart';
import '../providers/AppStateNotifier.dart';
import '../viewholders/VideosListView.dart';
import 'package:provider/provider.dart';

class VideoScreenBookmarks extends StatefulWidget {
  VideoScreenBookmarks();

  @override
  VideoScreenBookmarksRouteState createState() =>
      new VideoScreenBookmarksRouteState();
}

class VideoScreenBookmarksRouteState extends State<VideoScreenBookmarks> {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    List<Videos> items = [];
    final appState = Provider.of<AppStateNotifier>(context);
    final bookmarksModel = Provider.of<BookmarksModel>(context);
    items = bookmarksModel.pinnedVideos;

    void onItemClick(int indx) {}

    return items.length == 0
        ? Center(
            child: Text(t.nobookmarkedvideos,
                textAlign: TextAlign.center,
                style: TextStyles.medium(context)
                    .copyWith(color: MyColors.grey_60)),
          )
        : buildBookmarkedVideoListView(appState, items, onItemClick);
  }
}
