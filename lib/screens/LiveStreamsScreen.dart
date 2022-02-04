import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsextra/providers/LivestreamsBookmarksModel.dart';
import 'package:newsextra/utils/InterstitialAdsNetwork.dart';
import 'package:newsextra/utils/TextStyles.dart';
import 'package:newsextra/widgets/LiveStreamsPopupMenu.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/LiveStreams.dart';
import '../i18n/strings.g.dart';
import '../providers/LiveStreamsModel.dart';
import '../screens/NoitemScreen.dart';
import '../models/ScreenArguements.dart';
import '../video_player/LiveTVPlayer.dart';

class LiveStreamsScreen extends StatefulWidget {
  LiveStreamsScreen();

  @override
  LiveStreamsScreenRouteState createState() => new LiveStreamsScreenRouteState();
}

class LiveStreamsScreenRouteState extends State<LiveStreamsScreen> {
  LiveStreamsModel liveStreamsModel;
  List<LiveStreams> items;

  onRetryClick() {
    liveStreamsModel.loadItems();
  }

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
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<LiveStreamsModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    liveStreamsModel = Provider.of<LiveStreamsModel>(context);
    items = liveStreamsModel.items;

    void _onRefresh() async {
      liveStreamsModel.loadItems();
    }

    void _onLoading() async {
      liveStreamsModel.loadMoreItems();
    }

    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        controller: liveStreamsModel.refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: (liveStreamsModel.isError == true || items.length == 0)
            ? Center(
                child: Text(t.articlesloaderrormsg, textAlign: TextAlign.center, style: TextStyles.medium(context)),
              )
            : GridView.builder(
                itemCount: liveStreamsModel.items.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0, childAspectRatio: 1.0),
                itemBuilder: (BuildContext context, int index) {
                  return ItemTile(
                    itemClick: onItemClick,
                    index: index,
                    liveStreams: items[index],
                  );
                },
              ));
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
          height: 150.0,
          width: 100.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 120,
                width: 130,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
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
                    placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Center(
                        child: Icon(
                      Icons.error,
                      color: Colors.grey,
                    )),
                  ),
                ),
              ),
              SizedBox(height: 0.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    margin: EdgeInsets.only(left: 15, right: 0),
                    child: Text(
                      liveStreams.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      maxLines: 1,
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
          InterstitialAdsNetwork().initAds();
          itemClick(liveStreams);
        },
      ),
    );
  }
}
// /onItemClick(liveStreams);