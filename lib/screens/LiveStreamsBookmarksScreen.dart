import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsextra/providers/LivestreamsBookmarksModel.dart';
import 'package:newsextra/utils/TextStyles.dart';
import 'package:newsextra/widgets/LiveStreamsPopupMenu.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../models/LiveStreams.dart';
import '../i18n/strings.g.dart';
import '../models/ScreenArguements.dart';
import '../video_player/LiveTVPlayer.dart';

class LiveStreamsBookmarksScreen extends StatefulWidget {
  LiveStreamsBookmarksScreen();

  @override
  LiveStreamsScreenRouteState createState() =>
      new LiveStreamsScreenRouteState();
}

class LiveStreamsScreenRouteState extends State<LiveStreamsBookmarksScreen> {
  LivestreamsBookmarksModel liveStreamsModel;
  List<LiveStreams> items;

  onItemClick(LiveStreams liveStreams) {
    Navigator.pushNamed(
      context,
      LiveTVPlayer.routeName,
      arguments: ScreenArguements(
        position: 0,
        object: liveStreams,
        items: items,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    liveStreamsModel = Provider.of<LivestreamsBookmarksModel>(context);
    items = liveStreamsModel.bookmarksList;

    if (items.length == 0) {
      return Center(
        child: Text(t.articlesloaderrormsg,
            textAlign: TextAlign.center, style: TextStyles.medium(context)),
      );
    } else
      return Container(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: GridView.builder(
          itemCount: items.length,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(3),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1),
          itemBuilder: (BuildContext context, int index) {
            return ItemTile(
              itemClick: onItemClick,
              index: index,
              liveStreams: items[index],
            );
          },
        ),
      );
  }
}

class ItemTile extends StatelessWidget {
  final LiveStreams liveStreams;
  final int index;
  final Function itemClick;

  const ItemTile({
    Key key,
    @required this.index,
    @required this.liveStreams,
    @required this.itemClick,
  })  : assert(index != null),
        assert(liveStreams != null),
        assert(itemClick != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0.0),
      child: InkWell(
        child: Container(
          height: 200.0,
          width: 120.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 140,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: liveStreams.coverphoto,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
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
              SizedBox(height: 7.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 120,
                    margin: EdgeInsets.only(left: 15, right: 0),
                    child: Text(
                      liveStreams.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  LiveStreamsPopupMenu(liveStreams)
                ],
              )
            ],
          ),
        ),
        onTap: () {
          itemClick(liveStreams);
        },
      ),
    );
  }
}
// /onItemClick(liveStreams);