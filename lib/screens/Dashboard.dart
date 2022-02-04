import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsextra/i18n/strings.g.dart';
import 'package:newsextra/screens/RadioListView.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import 'package:provider/provider.dart';
import '../providers/DashboardModel.dart';
import '../providers/BookmarksModel.dart';
import '../screens/HomeSlider.dart';
import '../utils/TextStyles.dart';
import '../screens/CategoryListView.dart';
import '../screens/LiveTvListView.dart';
import '../screens/MediaListView.dart';
import '../screens/SubscriptionScreen.dart';
import '../providers/SubscriptionModel.dart';
import '../utils/my_colors.dart';
import '../screens/NoitemScreen.dart';
import '../models/Media.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen();

  @override
  DashboardScreenRouteState createState() => new DashboardScreenRouteState();
}

class DashboardScreenRouteState extends State<DashboardScreen> {
  DashboardModel dashboardModel;
  bool isSubscribed = false;

  onRetryClick() {
    dashboardModel.loadItems();
  }

  @override
  void initState() {
    //Provider.of<DashboardModel>(context, listen: false).fetchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dashboardModel = Provider.of<DashboardModel>(context);
    isSubscribed = Provider.of<SubscriptionModel>(context).isSubscribed;
    if (dashboardModel.isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: ListView.builder(
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48.0,
                          height: 48.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  itemCount: 12,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (dashboardModel.isError) {
      return NoitemScreen(title: t.oops, message: t.dataloaderror, onClick: onRetryClick);
    } else
      return Container(
        //color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Visibility(
                visible: isSubscribed == false,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SubscriptionScreen.routeName);
                  },
                  child: Container(
                    //shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(0),),
                    //clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.all(0),
                    //elevation: 0.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(StringsUtils.start_subscription,
                                style: TextStyles.headline(context).copyWith(
                                  //color: MyColors.grey_90,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                )),
                          ),
                          Container(height: 4),
                          Text(StringsUtils.start_subscription_hint,
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 14,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                  child: Text(
                    "Latest News",
                    style: TextStyles.headline(context).copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: "serif",
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              HomeSlider(dashboardModel.articles == null ? [] : dashboardModel.articles),
              Container(height: 15),
              Card(
                //shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(0),),
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: CategoryListView(dashboardModel.categories == null ? [] : dashboardModel.categories),
                ),
              ),
              Container(height: 15),
              Card(
                //shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(0),),
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: dashboardModel.livestreams == null ? Container() : LiveTvListView(dashboardModel.livestreams),
                ),
              ),
              //Container(height: 15),
              Card(
                //shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(0),),
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: dashboardModel.radios == null ? Container() : RadioListView(dashboardModel.radios, "Suggested Radio Stations", ""),
                ),
              ),
              Container(height: 15),
              Card(
                //shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(0),),
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: MediaListView(dashboardModel.latestVideos, StringsUtils.videotracks, StringsUtils.newvideoshint),
                ),
              ),
              Container(height: 15),
              Card(
                //shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(0),),
                //clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: MediaListView(dashboardModel.latestAudios, StringsUtils.audiotracks, StringsUtils.newaudioshint),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
