import 'package:flutter/material.dart';
import 'package:newsextra/i18n/strings.g.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/TextStyles.dart';
import '../models/Categories.dart';
import '../models/ScreenArguements.dart';
import '../providers/CategoriesModel.dart';
import '../screens/NoitemScreen.dart';
import '../screens/CategoriesMediaScreen.dart';

class MediaCategoriesScreen extends StatelessWidget {
  static const routeName = "/MediaCategoriesScreen";
  MediaCategoriesScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Zone Categories"),
      ),
      body: ChangeNotifierProvider(
        create: (context) => CategoriesModel(),
        child: MediaCategoriesScreenBody(),
      ),
    );
  }
}

class MediaCategoriesScreenBody extends StatefulWidget {
  MediaCategoriesScreenBody();

  @override
  CategoriesScreenRouteState createState() => new CategoriesScreenRouteState();
}

class CategoriesScreenRouteState extends State<MediaCategoriesScreenBody> {
  CategoriesModel categoriesModel;
  List<Categories> items;

  onRetryClick() {
    categoriesModel.loadItems();
  }

  @override
  Widget build(BuildContext context) {
    categoriesModel = Provider.of<CategoriesModel>(context);
    items = categoriesModel.categories;

    if (categoriesModel.isLoading) {
      return Center(
          child: CupertinoActivityIndicator(
        radius: 20,
      ));
    } else if (categoriesModel.isError) {
      return NoitemScreen(
          title: t.oops, message: t.dataloaderror, onClick: onRetryClick);
    } else
      return Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
              child: Text("E-Zone Categories",
                  style: TextStyles.headline(context).copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: categoriesModel.categories.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1),
              itemBuilder: (BuildContext context, int index) {
                return ItemTile(
                  index: index,
                  categories: items[index],
                );
              },
            ),
          ),
        ],
      );
  }
}

class ItemTile extends StatelessWidget {
  final Categories categories;
  final int index;

  const ItemTile({
    Key key,
    @required this.index,
    @required this.categories,
  })  : assert(index != null),
        assert(categories != null),
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
                height: 120,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: categories.thumbnailUrl,
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
              Container(
                alignment: Alignment.center,
                child: Text(
                  categories.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 3.0),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            CategoriesMediaScreen.routeName,
            arguments: ScreenArguements(position: 0, object: categories),
          );
        },
      ),
    );
  }
}
