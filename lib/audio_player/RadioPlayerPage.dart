import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsextra/models/CommentsArguement.dart';
import 'package:newsextra/models/Radios.dart';
import 'package:newsextra/providers/RadioBookmarksModel.dart';
import 'package:newsextra/providers/RadioRecordingsModel.dart';
import 'package:newsextra/radiocomments/RadioCommentsScreen.dart';
import 'package:newsextra/utils/Adverts.dart';
import 'package:newsextra/utils/my_colors.dart';
import 'package:newsextra/videoplayer/RadioLiveTVPlayer.dart';
import 'package:newsextra/widgets/RadioPopupMenu.dart';
import 'package:record/record.dart';
import 'package:toast/toast.dart';
import 'dart:ui';
import '../models/Userdata.dart';
import '../providers/AppStateNotifier.dart';
import '../providers/MediaPlayerModel.dart';
import '../models/Media.dart';
import '../widgets/MarqueeWidget.dart';
import '../utils/TextStyles.dart';
import '../providers/AudioPlayerModel.dart';
import 'package:provider/provider.dart';

class RadioPlayerPage extends StatefulWidget {
  static const routeName = "/RadioPlayerPage";
  RadioPlayerPage();

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<RadioPlayerPage>
    with TickerProviderStateMixin {
  AnimationController controllerPlayer;
  Animation<double> animationPlayer;
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  Userdata userdata;
  RadioBookmarksModel radioBookmarksModel;

  @override
  initState() {
    super.initState();
    userdata = Provider.of<AppStateNotifier>(context, listen: false).userdata;
    controllerPlayer = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationPlayer =
        new CurvedAnimation(parent: controllerPlayer, curve: Curves.linear);
    animationPlayer.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerPlayer.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerPlayer.forward();
      }
    });
  }

  @override
  void dispose() {
    controllerPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    AudioPlayerModel audioPlayerModel = Provider.of(context);
    radioBookmarksModel = Provider.of<RadioBookmarksModel>(context);
    /*if (audioPlayerModel.remoteAudioPlaying) {
      controllerPlayer.forward();
    } else {
      controllerPlayer.stop(canceled: false);
    }*/
    if (audioPlayerModel.currentMedia == null) {
      Navigator.of(context).pop();
    }
    return audioPlayerModel.currentMedia == null
        ? Container(
            color: Colors.black,
            child: Center(
              child: Text(
                "Audio Not Available",
                style: TextStyles.headline(context)
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          )
        : ChangeNotifierProvider(
            create: (context) =>
                MediaPlayerModel(userdata, audioPlayerModel.currentMedia),
            child: Scaffold(
              body: Stack(
                children: <Widget>[
                  _buildWidgetAlbumCoverBlur(mediaQuery, audioPlayerModel),
                  BuildPlayerBody(
                      userdata: userdata,
                      audioPlayerModel: audioPlayerModel,
                      commonTween: _commonTween,
                      controllerPlayer: controllerPlayer),
                ],
              ),
            ),
          );
  }

  Widget _buildWidgetAlbumCoverBlur(
      MediaQueryData mediaQuery, AudioPlayerModel audioPlayerModel) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(audioPlayerModel.currentMedia.coverPhoto),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.0),
          ),
        ),
      ),
    );
  }
}

class BuildPlayerBody extends StatefulWidget {
  const BuildPlayerBody({
    Key key,
    @required this.audioPlayerModel,
    @required Tween<double> commonTween,
    @required this.controllerPlayer,
    @required this.userdata,
  })  : _commonTween = commonTween,
        super(key: key);

  final AudioPlayerModel audioPlayerModel;
  final Tween<double> _commonTween;
  final AnimationController controllerPlayer;
  final Userdata userdata;

  @override
  _BuildPlayerBodyState createState() => _BuildPlayerBodyState();
}

class _BuildPlayerBodyState extends State<BuildPlayerBody> {
  bool tvState = false;
  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  Timer _timer;
  Timer _ampTimer;
  final _audioRecorder = Record();

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.primaryDark,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 25.0,
                        color: Colors.white,
                      ),
                      onPressed: () => {
                        Navigator.pop(context),
                      },
                    ),
                    Spacer(),
                    widget.audioPlayerModel.isRecorded
                        ? Container()
                        : _buildRecordStopControl(),
                    const SizedBox(width: 10),
                    widget.audioPlayerModel.isRecorded
                        ? Container()
                        : _buildPauseResumeControl(),
                    const SizedBox(width: 10),
                    widget.audioPlayerModel.isRecorded
                        ? Container()
                        : _buildText(),
                    const SizedBox(width: 10),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 0),
                    Stack(children: [
                      Container(
                        margin: EdgeInsets.all(4),
                        width: 200,
                        height:
                            200, //MediaQuery.of(context).size.height * 0.50,
                        decoration: BoxDecoration(
                          //shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(widget
                                .audioPlayerModel.currentMedia.coverPhoto),
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        width: 200,
                        color: Colors.transparent,
                        child: Center(
                          child: ClipOval(
                              child: Container(
                            color: MyColors.primary,
                            width: 70.0,
                            height: 70.0,
                            child: IconButton(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              onPressed: () {
                                widget.audioPlayerModel.onPressed();
                              },
                              icon: widget.audioPlayerModel.icon(),
                            ),
                          )),
                        ),
                      )
                    ]),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: MarqueeWidget(
                        direction: Axis.horizontal,
                        child: Text(
                          widget.audioPlayerModel.currentMedia.title,
                          maxLines: 1,
                          style: TextStyles.subhead(context)
                              .copyWith(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: MarqueeWidget(
                        direction: Axis.horizontal,
                        child: Text(
                          widget.audioPlayerModel.currentMedia.description,
                          maxLines: 1,
                          style: TextStyles.subhead(context)
                              .copyWith(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    widget.audioPlayerModel.isRecorded
                        ? Container()
                        : Container(
                            margin: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.share,
                                    size: 25.0,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Media _media =
                                        widget.audioPlayerModel.currentMedia;

                                    Radios radios = Radios(
                                      id: _media.id,
                                      title: _media.title,
                                      interest: _media.description,
                                      thumbnail: _media.coverPhoto,
                                      link: _media.streamUrl,
                                      tv: _media.downloadUrl,
                                    );
                                    Share.shareFile(radios);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.report,
                                    size: 25.0,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    Media _media =
                                        widget.audioPlayerModel.currentMedia;
                                    Radios radios = Radios(
                                      id: _media.id,
                                      title: _media.title,
                                      interest: _media.description,
                                      thumbnail: _media.coverPhoto,
                                      link: _media.streamUrl,
                                      tv: _media.downloadUrl,
                                    );
                                    await showDialog<void>(
                                        context: context,
                                        barrierDismissible:
                                            false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return ReportRadioDialog(
                                            radios: radios,
                                          );
                                        });
                                  },
                                ),
                                widget.audioPlayerModel.isRecorded
                                    ? Container()
                                    : InkWell(
                                        onTap: () {
                                          Media _media = widget
                                              .audioPlayerModel.currentMedia;
                                          Radios radios = Radios(
                                            id: _media.id,
                                            title: _media.title,
                                            interest: _media.description,
                                            thumbnail: _media.coverPhoto,
                                            link: _media.streamUrl,
                                            tv: _media.downloadUrl,
                                          );
                                          Navigator.pushNamed(
                                            context,
                                            RadioCommentsScreen.routeName,
                                            arguments: CommentsArguement(
                                                item: radios, commentCount: 0),
                                          );
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.insert_comment,
                                                size: 26, color: Colors.white),
                                          ],
                                        ),
                                      ),
                                IconButton(
                                  icon: Icon(
                                    Icons.live_tv,
                                    size: 25.0,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    Media _media =
                                        widget.audioPlayerModel.currentMedia;

                                    Radios radios = Radios(
                                      id: _media.id,
                                      title: _media.title,
                                      interest: _media.description,
                                      thumbnail: _media.coverPhoto,
                                      link: _media.streamUrl,
                                      tv: _media.downloadUrl,
                                    );
                                    if (radios.tv == "") {
                                      Toast.show(
                                          "Live TV not available for this radio.",
                                          context);
                                    } else {
                                      setState(() {
                                        tvState = !tvState;
                                        if (widget.audioPlayerModel
                                            .remoteAudioPlaying) {
                                          widget.audioPlayerModel
                                              .radioPauseBackgroundAudio();
                                        }
                                      });
                                    }
                                    /*setState(() {
                                      tvState = !tvState;
                                      if (widget.audioPlayerModel
                                          .remoteAudioPlaying) {
                                        widget.audioPlayerModel
                                            .radioPauseBackgroundAudio();
                                      }
                                    });*/
                                  },
                                ),
                                Consumer<RadioBookmarksModel>(
                                  builder:
                                      (context, radioBookmarksModel, child) {
                                    Media _media =
                                        widget.audioPlayerModel.currentMedia;
                                    Radios radios = Radios(
                                      id: _media.id,
                                      title: _media.title,
                                      interest: _media.description,
                                      thumbnail: _media.coverPhoto,
                                      link: _media.streamUrl,
                                      tv: _media.downloadUrl,
                                    );
                                    return IconButton(
                                      icon: Icon(
                                        radioBookmarksModel
                                                .isMediaBookmarked(radios)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 25.0,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (radioBookmarksModel
                                            .isMediaBookmarked(radios)) {
                                          radioBookmarksModel
                                              .unBookmarkMedia(radios);
                                        } else {
                                          radioBookmarksModel
                                              .bookmarkMedia(radios);
                                        }
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                  ],
                )
              ],
            ),
          ),
          // Player(),

          !tvState
              ? Container(child: AdmobNativeAds())
              : Container(
                  margin: EdgeInsets.all(15),
                  child: RadioLiveTVPlayer(
                    link: widget.audioPlayerModel.currentMedia.downloadUrl,
                  ),
                )
        ],
      ),
    );
  }

  Widget _buildRecordStopControl() {
    Icon icon;
    Color color;

    if (_isRecording || _isPaused) {
      icon = Icon(Icons.stop, color: Colors.white, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: Colors.white, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isRecording ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (!_isRecording && !_isPaused) {
      return const SizedBox.shrink();
    }

    Icon icon;
    Color color;

    if (!_isPaused) {
      icon = Icon(Icons.pause, color: Colors.white, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: Colors.white, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isPaused ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_isRecording || _isPaused) {
      return _buildTimer();
    }

    return Text("");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: TextStyle(color: Colors.white),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isRecording = isRecording;
          _recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    final path = await _audioRecorder.stop();
    print(path);
    if (path != null) {
      Radios _radio = Radios(
          id: DateTime.now().millisecondsSinceEpoch,
          title: "Recording on " +
              DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()),
          link: path,
          interest: widget.audioPlayerModel.currentMedia.title,
          thumbnail: widget.audioPlayerModel.currentMedia.coverPhoto,
          tv: "");
      Provider.of<RadioRecordingsModel>(context, listen: false)
          .saveRecordedRadio(_radio);
    }

    setState(() => _isRecording = false);
  }

  Future<void> _pause() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    await _audioRecorder.pause();

    setState(() => _isPaused = true);
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();

    setState(() => _isPaused = false);
  }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }
}
