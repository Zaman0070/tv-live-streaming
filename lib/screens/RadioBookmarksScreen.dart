import 'package:flutter/material.dart';
import 'package:newsextra/audio_player/RadioPlayerPage.dart';
import 'package:newsextra/models/Media.dart';
import 'package:newsextra/providers/RadioBookmarksModel.dart';
import 'package:newsextra/utils/InterstitialAdsNetwork.dart';
import 'package:newsextra/widgets/RadioPopupMenu.dart';
import '../providers/AudioPlayerModel.dart';
import 'package:provider/provider.dart';
import '../models/Radios.dart';
import '../i18n/strings.g.dart';
import '../utils/TextStyles.dart';
import 'package:flutter/cupertino.dart';

class RadioBookmarksScreen extends StatefulWidget {
  RadioBookmarksScreen();

  @override
  RadiosScreenRouteState createState() => new RadiosScreenRouteState();
}

class RadiosScreenRouteState extends State<RadioBookmarksScreen> {
  //with AutomaticKeepAliveClientMixin {
  BuildContext context;

  //@override
  //bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    this.context = context;
    List<Radios> items = [];
    RadioBookmarksModel radioModel = Provider.of<RadioBookmarksModel>(context);
    items = radioModel.bookmarksList;

    return Container(
      height: double.infinity,
      child: (items.length == 0)
          ? Center(
              child: Text(t.articlesloaderrormsg,
                  textAlign: TextAlign.center,
                  style: TextStyles.medium(context)),
            )
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              itemCount: items.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 1, color: Colors.grey),
              itemBuilder: (context, index) {
                return Container(
                    height: 70,
                    child: RadioItems(
                      radio: items[index],
                      items: items,
                    ));
              },
            ),
    );
  }
}

class RadioItems extends StatelessWidget {
  const RadioItems({
    Key key,
    @required this.radio,
    @required this.items,
  }) : super(key: key);

  final Radios radio;
  final List<Radios> items;

  @override
  Widget build(BuildContext context) {
    //print("i am called here");
    return InkWell(
      child: ListTile(
        //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(radio.thumbnail),
        ),
        title: Text(
          radio.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Text(
          radio.interest,
        ),
        trailing:
            Container(height: 50, width: 50, child: RadioPopupMenu(radio)),
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
      },
    );
  }
}
