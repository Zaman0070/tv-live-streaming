import 'package:flutter/material.dart';
import 'package:newsextra/providers/AppStateNotifier.dart';
import 'package:newsextra/screens/HomePage.dart';
import 'package:newsextra/utils/my_colors.dart';
import 'package:provider/provider.dart';
import '../providers/CategoryModel.dart';
import '../models/Categories.dart';
import '../i18n/strings.g.dart';
import '../utils/Alerts.dart';
import 'package:flutter/cupertino.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = "/categories";
  final bool isFirstLoad;
  CategoriesScreen({this.isFirstLoad});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoryModel(isFirstLoad),
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.choosecategories),
          actions: <Widget>[
            Consumer<CategoryModel>(
              builder: (context, cats, child) {
                return InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
                    child: Icon(
                      Icons.done_all,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    if (cats.isLoading || cats.selectedcats.length == 0) {
                      Alerts.show(context, t.error, t.selectcategorieshint);
                    } else {
                      Provider.of<AppStateNotifier>(context, listen: false)
                          .getDatabaseCategories();
                      if (isFirstLoad) {
                        Navigator.pushReplacementNamed(
                          context,
                          HomePage.routeName,
                          // arguments: cats.dbcategories,
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                );
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
    List<Categories> categories = [];
    final categoryModel = Provider.of<CategoryModel>(context);
    categories = categoryModel.items;
    //print("i am called");

    if (categoryModel.isLoading) {
      return Center(child: CupertinoActivityIndicator());
    } else if (categoryModel.items.length == 0) {
      return Center(
          child: Container(
        height: 200,
        child: GestureDetector(
          onTap: () {
            categoryModel.fetchData();
          },
          child: ListView(children: <Widget>[
            Icon(
              Icons.refresh,
              size: 50.0,
              color: Colors.red,
            ),
            Text(
              t.errorfetchingcategories,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            )
          ]),
        ),
      ));
    } else
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 25.0),
        padding: const EdgeInsets.all(10.0),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          Categories cats = categories[index];
          return new GridTile(
            footer: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Flexible(
                    child: new SizedBox(
                      height: 16.0,
                      width: 100.0,
                      child: new Text(
                        cats.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ]),
            child: new Container(
              height: 500.0,
              padding: const EdgeInsets.only(bottom: 5.0),
              child: new GestureDetector(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: new Row(
                        children: <Widget>[
                          new Stack(
                            children: <Widget>[
                              new SizedBox(
                                child: new Container(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(cats.thumbnailUrl),
                                    radius: 40.0,
                                  ),
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 12.0, right: 10.0),
                                ),
                              ),
                              new Positioned(
                                right: 0.0,
                                child: new GestureDetector(
                                  child: categoryModel.isContain(cats.id)
                                      ? new Icon(
                                          Icons.check_circle,
                                          color: MyColors.primary,
                                        )
                                      : new Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.grey[500],
                                        ),
                                  onTap: () {
                                    categoryModel.selectUnselectCategory(cats);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  categoryModel.selectUnselectCategory(cats);
                },
              ),
            ),
          );
        },
      );
  }
}
