import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsextra/models/ScreenArguements.dart';
import 'package:newsextra/screens/ArticleViewerScreen.dart';
import '../models/Articles.dart';

class HomeSlider extends StatelessWidget {
  final List<Articles> articles;
  HomeSlider(this.articles);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10.0, left: 10.0),
          height: 270.0,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            primary: false,
            itemCount: (articles == null || articles.length == 0)
                ? 0
                : articles.length,
            itemBuilder: (BuildContext context, int index) {
              Articles curObj = articles[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  child: Container(
                    height: 250.0,
                    width: 140.0,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 180.0,
                            width: 140.0,
                            child: CachedNetworkImage(
                              imageUrl: curObj.thumbnail,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                            curObj.title,
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                            maxLines: 4,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      ArticleViewerScreen.routeName,
                      arguments:
                          ScreenArguements(position: index, items: articles),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
