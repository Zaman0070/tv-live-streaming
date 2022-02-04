import 'package:flutter/material.dart';
import 'package:newsextra/providers/MediaBookmarksModel.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../utils/TextStyles.dart';
import '../models/Media.dart';
import '../viewholders/MediaItemTile.dart';

class MediaBookmarkScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<MediaBookmarkScreen> {
  MediaBookmarksModel mediaScreensModel;
  List<Media> items;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<MediaBookmarksModel>(context);
    items = mediaScreensModel.bookmarksList;
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Appbar(),
          Expanded(
            child: (items.length == 0)
                ? Center(
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(StringsUtils.noitemstodisplay,
                            textAlign: TextAlign.center,
                            style: TextStyles.medium(context)),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(3),
                    itemBuilder: (BuildContext context, int index) {
                      return ItemTile(
                        mediaList: items,
                        index: index,
                        object: items[index],
                      );
                    },
                  ),
          ),
          // MiniPlayer(),
        ],
      ),
    );
  }
}
