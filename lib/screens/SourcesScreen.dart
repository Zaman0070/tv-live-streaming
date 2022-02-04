import 'package:flutter/material.dart';
import '../providers/ArticlesModel.dart';
import 'package:newsextra/utils/my_colors.dart';
import 'package:provider/provider.dart';
import '../providers/SourcesModel.dart';
import '../providers/VideosModel.dart';
import '../models/Sources.dart';
import '../i18n/strings.g.dart';
import 'package:flutter/cupertino.dart';

class SourcesScreen extends StatelessWidget {
  static const routeName = "/SourcesScreen";
  SourcesScreen();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SourcesModel(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.backspace,
              color: Colors.white,
            ),
            onPressed: () {
              Provider.of<ArticlesModel>(context, listen: false)
                  .fetchArticles();
              Provider.of<VideosModel>(context, listen: false).fetchArticles();
              Navigator.of(context).pop();
            },
          ),
          title: Text(t.feedsources),
          actions: <Widget>[
            InkWell(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
                child: Icon(
                  Icons.done_all,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Provider.of<ArticlesModel>(context, listen: false)
                    .fetchArticles();
                Provider.of<VideosModel>(context, listen: false)
                    .fetchArticles();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: Container(
          // decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(0),
                child: CategoriesList(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Sources> items = [];
    final sourcesModel = Provider.of<SourcesModel>(context);
    items = sourcesModel.items;
    //print("i am called");

    if (sourcesModel.isLoading) {
      return Center(child: CupertinoActivityIndicator());
    } else if (sourcesModel.items.length == 0) {
      return Center(
          child: Container(
        height: 200,
        child: GestureDetector(
          onTap: () {
            sourcesModel.fetchData();
          },
          child: ListView(children: <Widget>[
            Icon(
              Icons.refresh,
              size: 50.0,
              color: Colors.red,
            ),
            Text(
              t.errorprocessingrequest,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            )
          ]),
        ),
      ));
    } else
      return ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        padding: const EdgeInsets.all(10.0),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          Sources cats = items[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(cats.title),
              subtitle: Text(cats.category),
              trailing: ((cats.type == "feeds" &&
                          sourcesModel
                              .isUnfollowedFeedsSourcesContain(cats.id)) ||
                      (cats.type == "videos" &&
                          sourcesModel
                              .isUnfollowedVideosSourcesContain(cats.id)))
                  ? TextButton(
                      child: Text(
                        t.follow,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: MyColors.primary,
                      ),
                      onPressed: () {
                        sourcesModel.selectUnselectCategory(cats);
                      },
                    )
                  : TextButton(
                      child: Text(
                        t.unfollow,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: () {
                        sourcesModel.selectUnselectCategory(cats);
                      },
                    ),
              onTap: () {},
            ),
          );
        },
      );
  }
}
