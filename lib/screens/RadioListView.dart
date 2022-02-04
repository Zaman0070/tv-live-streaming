import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsextra/audio_player/RadioPlayerPage.dart';
import 'package:newsextra/models/Media.dart';
import 'package:newsextra/models/Radios.dart';
import 'package:newsextra/providers/AudioPlayerModel.dart';
import 'package:newsextra/utils/InterstitialAdsNetwork.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../utils/TextStyles.dart';

class RadioListView extends StatelessWidget {
  RadioListView(this.mediaList, this.header, this.subHeader);
  final List<Radios> mediaList;
  final String header;
  final String subHeader;

  Widget _buildItems(BuildContext context, int index) {
    Radios radio = mediaList[index];

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
                    imageUrl: radio.thumbnail,
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
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            radio.title,
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
                            radio.interest,
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
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          InterstitialAdsNetwork().initAds();
          Media media = new Media(
              id: radio.id,
              title: radio.title,
              description: radio.interest,
              coverPhoto: radio.thumbnail,
              downloadUrl: radio.tv,
              streamUrl: radio.link);
          Provider.of<AudioPlayerModel>(context, listen: false)
              .prepareradioplayer(media);
          Navigator.of(context).pushNamed(RadioPlayerPage.routeName);
          /*  if (media.mediaType == "audio") {
            Provider.of<AudioPlayerModel>(context, listen: false)
                .preparePlaylist(
                    Utility.extractMediaByType(mediaList, media.mediaType),
                    media);
            Navigator.of(context).pushNamed(PlayPage.routeName);
          } else {
            Navigator.pushNamed(context, VideoPlayer.routeName,
                arguments: ScreenArguements(
                  position: 0,
                  object: media,
                  items: Utility.extractMediaByType(mediaList, media.mediaType),
                ));
          }*/
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
        mediaList.length == 0
            ? Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(StringsUtils.noitemstodisplay,
                      textAlign: TextAlign.center,
                      style: TextStyles.medium(context)),
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
