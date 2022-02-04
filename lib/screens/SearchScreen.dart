import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsextra/audio_player/RadioPlayerPage.dart';
import 'package:newsextra/models/LiveStreams.dart';
import 'package:newsextra/models/Media.dart';
import 'package:newsextra/models/Radios.dart';
import 'package:newsextra/models/ScreenArguements.dart';
import 'package:newsextra/providers/AudioPlayerModel.dart';
import 'package:newsextra/providers/LivestreamsBookmarksModel.dart';
import 'package:newsextra/providers/RadioModel.dart';
import 'package:newsextra/utils/Adverts.dart';
import 'package:newsextra/utils/InterstitialAdsNetwork.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import 'package:newsextra/video_player/LiveTVPlayer.dart';
import 'package:newsextra/widgets/LiveStreamsPopupMenu.dart';
import 'package:newsextra/widgets/RadioPopupMenu.dart';
import '../utils/TextStyles.dart';
import '../i18n/strings.g.dart';
import '../models/Search.dart';
import '../providers/AppStateNotifier.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';
import '../providers/SearchModel.dart';
import '../viewholders/SearchListView.dart';
import '../viewholders/MediaItemTile.dart';

class SearchScreen extends StatelessWidget {
  static String routeName = "/search";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchModel()),
        ChangeNotifierProvider(create: (_) => AppStateNotifier()),
      ],
      child: SearchScreenBody(),
    );
  }
}

class SearchScreenBody extends StatefulWidget {
  SearchScreenBody();

  @override
  SearchScreenRouteState createState() => new SearchScreenRouteState();
}

class SearchScreenRouteState extends State<SearchScreenBody> {
  BuildContext context;
  bool finishLoading = true;
  bool showClear = false;
  final TextEditingController inputController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    List<Object> items = [];
    final appState = Provider.of<AppStateNotifier>(context);
    final searchModel = Provider.of<SearchModel>(context);
    items = searchModel.items;

    void _onLoading() async {
      searchModel.fetchMoreArticles();
    }

    void onItemClick(int indx) {}

    return new Scaffold(
      appBar: AppBar(
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: new TextStyle(fontSize: 18, color: Colors.white),
          keyboardType: TextInputType.text,
          onSubmitted: (query) {
            searchModel.searchArticles(query);
          },
          onChanged: (term) {
            setState(() {
              showClear = (term.length > 2);
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white70),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          showClear
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    inputController.clear();
                    showClear = false;
                    searchModel.cancelSearch();
                  },
                )
              : Container(),
        ],
      ),
      body: Column(children: [
        Container(
            height: 55,
            child: ListTile(
                title: Text("Searching for: " +
                    StringsUtils.searchoptions[searchModel.index]),
                trailing: IconButton(
                  onPressed: () async {
                    await showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return SearchOptionDialog(
                              selected: searchModel.index,
                              onclick: (_index) {
                                print(_index);
                                searchModel.setIndex(_index);
                              });
                        });
                  },
                  icon: Icon(Icons.edit),
                ))),
        Expanded(
          child: SmartRefresher(
              enablePullDown: false,
              enablePullUp:
                  false, //searchModel.items.length > 20 ? true : false,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text(t.pulluploadmore);
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text(t.loadfailedretry);
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text(t.releaseloadmore);
                  } else {
                    body = Text(t.nomoredata);
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: searchModel.refreshController,
              onLoading: _onLoading,
              child: buildContent(
                  context, searchModel, appState, items, onItemClick)),
        ),
      ]),
    );
  }

  Widget buildContent(BuildContext context, SearchModel searchModel,
      AppStateNotifier appState, List<Object> items, Function onItemClick) {
    if (searchModel.isLoading) {
      return Align(
        child: Container(
          height: 150,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CupertinoActivityIndicator(
                radius: 30,
              ),
              Container(height: 5),
              Text(
                "Searching for: " +
                    StringsUtils.searchoptions[searchModel.index],
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        alignment: Alignment.center,
      );
    } else if (searchModel.isError) {
      return Align(
        child: Container(
          width: 180,
          height: 100,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(t.nosearchresult,
                  style: TextStyles.caption(context)
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
              Container(height: 5),
              Text(t.nosearchresulthint,
                  textAlign: TextAlign.center,
                  style: TextStyles.medium(context).copyWith(fontSize: 13)),
            ],
          ),
        ),
        alignment: Alignment.center,
      );
    } else if (searchModel.isIdle) {
      return Align(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.search,
                size: 80,
              ),
              Container(height: 5),
            ],
          ),
        ),
        alignment: Alignment.center,
      );
    } else {
      if (searchModel.index == 2)
        return buildSearchListView(searchModel, appState, items);
      else if (searchModel.index == 1)
        return GridView.builder(
          itemCount: items.length,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1),
          itemBuilder: (BuildContext context, int index) {
            return LivestreamsTile(
              items: items,
              liveStreams: items[index],
            );
          },
        );
      else if (searchModel.index == 0)
        return ListView.separated(
          itemCount: items.length,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(3),
          itemBuilder: (BuildContext context, int index) {
            return RadioItems(
              items: items,
              radio: items[index],
            );
          },
          separatorBuilder: (context, position) {
            return Container(
                child: (position != 0 && position % 5 == 0)
                    ? Container(child: AdmobNativeAds())
                    : Container());
          },
        );
      else
        return ListView.separated(
          itemCount: items.length,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(3),
          itemBuilder: (BuildContext context, int index) {
            return ItemTile(
              mediaList: items,
              index: index,
              object: items[index],
            );
          },
          separatorBuilder: (context, position) {
            return Container(
                child: (position != 0 && position % 5 == 0)
                    ? Container(child: AdmobNativeAds())
                    : Container());
          },
        );
    }
  }
}

class SearchOptionDialog extends StatefulWidget {
  final int selected;
  final Function onclick;
  SearchOptionDialog({Key key, this.selected, this.onclick}) : super(key: key);

  @override
  _ReportRadioDialogState createState() => _ReportRadioDialogState();
}

class _ReportRadioDialogState extends State<SearchOptionDialog> {
  List<String> reportOptions = StringsUtils.searchoptions;
  int _selected = 0;

  @override
  void initState() {
    _selected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Search for: ",
        style: TextStyles.subhead(context),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      actions: <Widget>[
        FlatButton(
          child: Text(t.cancel),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(t.ok),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            widget.onclick(_selected);
            Navigator.of(context).pop();
          },
        ),
      ],
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: reportOptions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RadioListTile(
                        title: Text(reportOptions[index]),
                        value: index,
                        groupValue: _selected,
                        onChanged: (value) {
                          setState(() {
                            _selected = value;
                          });
                        });
                  },
                  separatorBuilder: (context, position) {
                    return Container(
                        child: (position != 0 && position % 5 == 0)
                            ? Container(child: AdmobNativeAds())
                            : Container());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RadioItems extends StatefulWidget {
  const RadioItems({
    Key key,
    @required this.radio,
    @required this.items,
  }) : super(key: key);

  final Radios radio;
  final List<Radios> items;

  @override
  _RadioItemsState createState() => _RadioItemsState();
}

class _RadioItemsState extends State<RadioItems> {
  @override
  Widget build(BuildContext context) {
    //print("i am called here");
    return InkWell(
      child: ListTile(
        //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.radio.thumbnail),
        ),
        title: Text(
          widget.radio.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Text(
          widget.radio.interest,
        ),
        trailing: Container(
            height: 50, width: 50, child: RadioPopupMenu(widget.radio)),
      ),
      onTap: () {
        InterstitialAdsNetwork().initAds();
        Media media = new Media(
            id: widget.radio.id,
            title: widget.radio.title,
            description: widget.radio.interest,
            coverPhoto: widget.radio.thumbnail,
            downloadUrl: widget.radio.tv,
            streamUrl: widget.radio.link);
        Provider.of<AudioPlayerModel>(context, listen: false)
            .prepareradioplayer(media);
        Navigator.of(context).pushNamed(RadioPlayerPage.routeName);
      },
    );
  }
}

class LivestreamsTile extends StatelessWidget {
  final LiveStreams liveStreams;
  final List<LiveStreams> items;

  const LivestreamsTile({
    Key key,
    @required this.items,
    @required this.liveStreams,
  })  : assert(items != null),
        assert(liveStreams != null),
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
                height: 140,
                //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: liveStreams.coverphoto,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 120,
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      liveStreams.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  LiveStreamsPopupMenu(liveStreams)
                ],
              )
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
              object: liveStreams,
              items: items,
            ),
          );
        },
      ),
    );
  }
}
