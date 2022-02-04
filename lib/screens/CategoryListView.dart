import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newsextra/i18n/strings.g.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import '../utils/TextStyles.dart';
import '../screens/CategoriesMediaScreen.dart';
import '../models/Categories.dart';
import '../models/ScreenArguements.dart';

class CategoryListView extends StatelessWidget {
  CategoryListView(this.categories);
  final List<Categories> categories;

  Widget _buildItems(BuildContext context, int index) {
    var cats = categories[index];

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        child: Container(
          height: 200.0,
          width: 130.0,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 120,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: cats.thumbnailUrl,
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
                alignment: Alignment.centerLeft,
                child: Text(
                  cats.title,
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
            arguments: ScreenArguements(position: 0, object: cats),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
          child: Text("E-Zone Categories",
              style: TextStyles.headline(context).copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: "serif",
                fontSize: 18,
              )),
        ),
        Container(
          padding: EdgeInsets.only(top: 10.0, left: 20.0),
          height: 200.0,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            primary: false,
            itemCount: categories.length,
            itemBuilder: _buildItems,
          ),
        ),
      ],
    );
  }
}
