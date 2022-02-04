import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/ScreenArguements.dart';
import '../providers/VideoSourceModel.dart';
import '../screens/VideosSourceFeedScreen.dart';
import '../providers/AppStateNotifier.dart';
import '../models/Videos.dart';
import '../utils/TextStyles.dart';
import '../utils/TimUtil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/BookmarksModel.dart';
import 'package:share/share.dart';
import '../providers/VideosModel.dart';

class ItemTile extends StatelessWidget {
  final Videos object;
  final int index;
  final bool isBookmarks;
  final bool isSource;

  const ItemTile({
    Key key,
    @required this.index,
    @required this.object,
    @required this.isBookmarks,
    @required this.isSource,
  })  : assert(index != null),
        assert(object != null),
        assert(isBookmarks != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Consumer<AppStateNotifier>(builder: (context, appState, child) {
                  if (appState.loadArticlesImages) {
                    return InkWell(
                        onTap: () {
                          if (isSource) {
                            Provider.of<VideoSourceModel>(context,
                                    listen: false)
                                .loadVideoViewer(context, index);
                          } else if (isBookmarks) {
                            Provider.of<BookmarksModel>(context, listen: false)
                                .loadBookmarkedVideoViewer(context, index);
                          } else {
                            Provider.of<VideosModel>(context, listen: false)
                                .loadVideoViewer(context, index);
                          }
                        },
                        child: Card(
                          margin: EdgeInsets.all(0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            height: 80,
                            width: 80,
                            child: CachedNetworkImage(
                              imageUrl: object.thumbnail,
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
                        ));
                  } else {
                    return Container();
                  }
                }),
                Container(width: 10),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              if (isSource) return;
                              Navigator.pushNamed(
                                context,
                                VideosSourceFeedScreen.routeName,
                                arguments: ScreenArguements(object: object),
                              );
                            },
                            child: Text(
                              object.source,
                              style: TextStyles.caption(context)
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          Text(TimUtil.timeAgoSinceDate(object.timeStamp),
                              style: TextStyles.caption(context)
                              //.copyWith(color: MyColors.grey_60),
                              ),
                        ],
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          if (isSource) {
                            Provider.of<VideoSourceModel>(context,
                                    listen: false)
                                .loadVideoViewer(context, index);
                          } else if (isBookmarks) {
                            Provider.of<BookmarksModel>(context, listen: false)
                                .loadBookmarkedVideoViewer(context, index);
                          } else {
                            Provider.of<VideosModel>(context, listen: false)
                                .loadVideoViewer(context, index);
                          }
                        },
                        child: Text(object.title,
                            maxLines: 3,
                            style: TextStyles.subhead(context).copyWith(
                                //color: MyColors.grey_80,
                                fontWeight: FontWeight.w500)),
                      ),
                      Spacer(),
                      Row(
                        children: <Widget>[
                          Text(object.interest.toUpperCase(),
                              style: TextStyles.caption(context)
                              //.copyWith(color: MyColors.grey_60),
                              ),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Consumer<BookmarksModel>(
                                builder: (context, bookmarksModel, child) {
                                  bool isBookmarked = bookmarksModel
                                      .isVideoBookmarked(object.id);
                                  return InkWell(
                                    child: Icon(Icons.bookmark,
                                        color: isBookmarked
                                            ? Colors.redAccent
                                            : Colors.grey,
                                        size: 20.0),
                                    onTap: () {
                                      if (isBookmarked)
                                        bookmarksModel
                                            .unBookmarkVideo(object.id);
                                      else
                                        bookmarksModel.bookmarkVideo(object);
                                    },
                                  );
                                },
                              ),
                              Container(width: 10),
                              InkWell(
                                child: Icon(Icons.share,
                                    color: Colors.lightBlue, size: 20.0),
                                onTap: () {
                                  Share.share(object.link,
                                      subject: object.title);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          Divider(
            height: 0.1,
            //color: Colors.grey.shade800,
          )
        ],
      ),
    );
  }
}
