import 'package:flutter/material.dart';
import 'package:newsextra/i18n/strings.g.dart';
import 'package:newsextra/utils/Adverts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../utils/TextStyles.dart';
import '../models/Media.dart';
import '../providers/MediaScreensModel.dart';
import '../screens/NoitemScreen.dart';
import '../viewholders/MediaItemTile.dart';

class MediaScreen extends StatefulWidget {
  MediaScreen();

  @override
  MediaScreenRouteState createState() => new MediaScreenRouteState();
}

class MediaScreenRouteState extends State<MediaScreen> {
  MediaScreensModel mediaScreensModel;
  List<Media> items;

  void _onRefresh() async {
    mediaScreensModel.loadItems();
  }

  void _onLoading() async {
    mediaScreensModel.loadMoreItems();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<MediaScreensModel>(context, listen: false).loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<MediaScreensModel>(context);
    items = mediaScreensModel.mediaList;

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
      controller: mediaScreensModel.refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (mediaScreensModel.isError == true && items.length == 0)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : ListView.separated(
              itemCount: items.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              itemBuilder: (BuildContext context, int index) {
                int _indx = index;
                return ItemTile(
                  mediaList: items,
                  index: _indx,
                  object: items[_indx],
                );
              },
              separatorBuilder: (context, position) {
                return Container(
                    child: (position != 0 && position % 5 == 0)
                        ? Container(child: AdmobNativeAds())
                        : Container());
              },
            ),
    );
  }
}
