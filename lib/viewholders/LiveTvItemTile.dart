import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsextra/utils/InterstitialAdsNetwork.dart';
import '../utils/TextStyles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/LiveStreams.dart';

class LiveTvItemTile extends StatelessWidget {
  final LiveStreams object;
  final Function onclick;

  const LiveTvItemTile({
    Key key,
    @required this.onclick,
    @required this.object,
  })  : assert(onclick != null),
        assert(object != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // final articlesModel = Provider.of<ArticlesModel>(context);
    return InkWell(
      onTap: () {
        onclick(object);
        InterstitialAdsNetwork().initAds();
      },
      child: Container(
        height: 80,
        margin: EdgeInsets.fromLTRB(2, 2, 2, 0),
        child: Stack(
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: object.coverphoto,
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 40,
                padding: EdgeInsets.all(10),
                width: double.infinity,
                color: Colors.black45,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(object.title,
                          style: TextStyles.subhead(context).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
