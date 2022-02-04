import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../providers/BookmarksModel.dart';
import '../models/ScreenArguements.dart';
import '../screens/VideosSourceFeedScreen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import '../models/Videos.dart';
import '../utils/TextStyles.dart';
import '../utils/TimUtil.dart';
import '../utils/my_colors.dart';
import '../providers/VideosModel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemHeaderTile extends StatelessWidget {
  final Videos object;
  final int index;
  final bool isBookmarks;
  final bool isSource;

  const ItemHeaderTile({
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
    return InkWell(
      onTap: () {
        if (isBookmarks) {
          Provider.of<BookmarksModel>(context, listen: false)
              .loadBookmarkedVideoViewer(context, index);
        } else {
          Provider.of<VideosModel>(context, listen: false)
              .loadVideoViewer(context, index);
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          child: Container(
            height: 230,
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
                        Row(
                          children: <Widget>[
                            Text(TimUtil.timeAgoSinceDate(object.timeStamp),
                                style: TextStyles.body1(context)
                                    .copyWith(color: MyColors.grey_10)),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(2)),
                              child: Text(object.interest,
                                  style: TextStyles.body1(context)
                                      .copyWith(color: MyColors.grey_10)),
                            ),
                          ],
                        ),
                        Container(height: 10),
                        Text(object.title,
                            maxLines: 3,
                            style: TextStyles.medium(context).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                        Container(height: 10),
                        //Spacer(),
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
                                style: TextStyles.caption(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.grey_10),
                              ),
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
                                              : Colors.white70,
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
