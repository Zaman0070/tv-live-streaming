import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsextra/utils/InterstitialAdsNetwork.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/AudioPlayerModel.dart';
import '../utils/TextStyles.dart';
import '../models/Media.dart';
import '../widgets/MediaPopupMenu.dart';
import '../models/ScreenArguements.dart';
import '../videoplayer/VideoPlayer.dart';
import '../audio_player/player_page.dart';
import '../providers/SubscriptionModel.dart';
import '../utils/Utility.dart';
import '../utils/Alerts.dart';

class MediaListView extends StatelessWidget {
  MediaListView(this.mediaList, this.header, this.subHeader);
  final List<Media> mediaList;
  final String header;
  final String subHeader;

  Widget _buildItems(BuildContext context, int index) {
    var media = mediaList[index];
    bool isSubscribed = Provider.of<SubscriptionModel>(context).isSubscribed;

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        child: Container(
          height: 200.0,
          width: 130.0,
          child: Column(
            children: <Widget>[
              Container(
                height: 130,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: media.coverPhoto,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Center(
                        child: Icon(
                      Icons.error,
                      color: Colors.grey,
                    )),
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            media.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            media.category,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              color: Colors.blueGrey[300],
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MediaPopupMenu(media, isSubscribed),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          if (Utility.isMediaRequireUserSubscription(media, isSubscribed)) {
            Alerts.showPlaySubscribeAlertDialog(context);
            return;
          }
          print(media.mediaType);
          InterstitialAdsNetwork().initAds();
          if (media.mediaType == "audio") {
            Provider.of<AudioPlayerModel>(context, listen: false).preparePlaylist(Utility.extractMediaByType(mediaList, media.mediaType), media);
            Navigator.of(context).pushNamed(PlayPage.routeName);
          } else {
            Navigator.pushNamed(context, VideoPlayer.routeName,
                arguments: ScreenArguements(
                  position: 0,
                  object: media,
                  items: Utility.extractMediaByType(mediaList, media.mediaType),
                ));
          }
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
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 2),
          child: Text(header,
              maxLines: 1,
              style: TextStyles.headline(context).copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: "serif",
                fontSize: 18,
              )),
        ),
        subHeader == ""
            ? Container()
            : Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(subHeader,
                    maxLines: 1,
                    style: TextStyles.subhead(context).copyWith(
                      fontSize: 16,
                      fontFamily: "serif",
                      color: Colors.grey[600],
                    )),
              ),
        // mediaList.length == 0
        mediaList == null || mediaList.isEmpty
            ? Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(StringsUtils.noitemstodisplay, textAlign: TextAlign.center, style: TextStyles.medium(context)),
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: 15.0, left: 20.0),
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  itemCount: mediaList.length,
                  itemBuilder: _buildItems,
                ),
              ),
      ],
    );
  }
}
