import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newsextra/utils/InterstitialAdsNetwork.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import '../utils/TextStyles.dart';
import '../models/ScreenArguements.dart';
import '../video_player/LiveTVPlayer.dart';
import '../models/LiveStreams.dart';

class LiveTvListView extends StatelessWidget {
  LiveTvListView(this.livestreams);
  final List<LiveStreams> livestreams;

  Widget _buildItems(BuildContext context, int index) {
    var livetv = livestreams[index];
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        child: Container(
          height: 200.0,
          width: 130.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 120,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: livetv.coverphoto,
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
                  livetv.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          InterstitialAdsNetwork().initAds();
          Navigator.pushNamed(
            context,
            LiveTVPlayer.routeName,
            arguments: ScreenArguements(
              position: 0,
              object: livetv,
              items: livestreams,
            ),
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
          child: Text(StringsUtils.livetvchannels,
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
            itemCount: livestreams.length,
            itemBuilder: _buildItems,
          ),
        ),
      ],
    );
  }
}
