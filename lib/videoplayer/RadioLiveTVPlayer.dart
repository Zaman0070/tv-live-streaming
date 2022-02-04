import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

class RadioLiveTVPlayer extends StatefulWidget {
  RadioLiveTVPlayer({this.link});
  final String link;

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerState();
  }
}

class _VideoPlayerState extends State<RadioLiveTVPlayer>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 270,
        child: Container(
          color: Colors.black,
          child: HtmlWidget(
            '<iframe src="' + widget.link + '"></iframe>',
            factoryBuilder: () => MyWidgetFactory(),
          ),
        ));
  }
}

class MyWidgetFactory extends WidgetFactory with WebViewFactory {
  bool get webViewMediaPlaybackAlwaysAllow => true;
  String get webViewUserAgent => 'My app';
}
