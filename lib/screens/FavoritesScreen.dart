import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsextra/screens/ArticlesScreenBookmarks.dart';
import 'package:newsextra/screens/LiveStreamsBookmarksScreen.dart';
import 'package:newsextra/screens/MediaBookmarkScreen.dart';
import 'package:newsextra/screens/RadioBookmarksScreen.dart';
import 'package:newsextra/utils/my_colors.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = "/FavoritesScreen";
  FavoritesScreen();

  @override
  _SermonsScreenState createState() => _SermonsScreenState();
}

class _SermonsScreenState extends State<FavoritesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: DefaultTabController(
        length: 4, // length of tabs
        initialIndex: 0,
        child: Container(
            // decoration: BoxDecoration(color: Colors.white),
            height: double.infinity,
            child: Column(
              children: [
                Container(
                  height: 20,
                ),
                Container(
                  child: TabBar(
                    indicatorColor: MyColors.primary,
                    labelColor: MyColors.primary,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(text: "E-Zone"),
                      Tab(text: "LiveTv"),
                      Tab(text: "Radio"),
                      Tab(text: "Articles"),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(0),
                    child: TabBarView(children: [
                      MediaBookmarkScreen(),
                      LiveStreamsBookmarksScreen(),
                      RadioBookmarksScreen(),
                      ArticlesScreenBookmarks(),
                    ]),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
