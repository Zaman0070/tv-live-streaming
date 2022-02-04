import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import '../utils/Adverts.dart';
import '../providers/AudioPlayerModel.dart';
import 'package:provider/provider.dart';

class RotatePlayer extends AnimatedWidget {
  RotatePlayer({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    //final Animation<double> animation = listenable;
    AudioPlayerModel audioPlayerModel = Provider.of(context);
    return Container(
      margin: EdgeInsets.all(4),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context)
          .size
          .width, //MediaQuery.of(context).size.height * 0.50,
      decoration: BoxDecoration(
        //shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: CachedNetworkImageProvider(
              audioPlayerModel.currentMedia.coverPhoto),
        ),
      ),
    );
  }
}
