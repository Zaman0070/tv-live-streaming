import 'package:flutter/material.dart';
import 'package:newsextra/i18n/strings.g.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:package_info/package_info.dart';
import '../screens/SubscriptionScreen.dart';
import '../providers/MediaBookmarksModel.dart';
import '../providers/DownloadsModel.dart';
import '../models/ScreenArguements.dart';
import '../models/Downloads.dart';
import '../screens/Downloader.dart';
import '../models/Media.dart';

class MediaPopupMenu extends StatelessWidget {
  MediaPopupMenu(this.media, this.isSubscribed, {this.isDownloads});
  final Media media;
  final isDownloads;
  final bool isSubscribed;

  @override
  Widget build(BuildContext context) {
    MediaBookmarksModel bookmarksModel =
        Provider.of<MediaBookmarksModel>(context);
    DownloadsModel downloadsModel = Provider.of<DownloadsModel>(context);

    return PopupMenuButton(
      elevation: 3.2,
      //initialValue: choices[1],
      itemBuilder: (BuildContext context) {
        bool isBookmarked = bookmarksModel.isMediaBookmarked(media);
        List<String> choices = [];
        if (media.canDownload && media.videoType == "mp4_video") {
          choices.add(StringsUtils.download);
        }
        if (isDownloads != null &&
            downloadsModel.isMediaInDownloads(media.id).status ==
                DownloadTaskStatus.complete) {
          choices.add(StringsUtils.deletemedia);
        }
        choices.add(StringsUtils.addplaylist);
        if (isBookmarked) {
          choices.add(StringsUtils.unbookmark);
        } else {
          choices.add(StringsUtils.bookmark);
        }
        choices.add(StringsUtils.share);
        return choices.map((itm) {
          return PopupMenuItem(
            value: itm,
            child: Text(itm),
          );
        }).toList();
      },
      //initialValue: 2,
      onCanceled: () {
        print("You have canceled the menu.");
      },
      onSelected: (value) {
        print(value);
        switch (value) {
          case StringsUtils.download:
            downloadFIle(context, media);
            break;
          case StringsUtils.deletemedia:
            downloadsModel.removeDownloadedMedia(context, media.id);
            break;
          case StringsUtils.bookmark:
            bookmarksModel.bookmarkMedia(media);
            break;
          case StringsUtils.unbookmark:
            bookmarksModel.unBookmarkMedia(media);
            break;
          case StringsUtils.share:
            Share.shareFile(media);
            break;
          default:
        }
      },
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey[500],
      ),
    );
  }

  downloadFIle(BuildContext context, Media media) {
    if (isSubscribed) {
      Downloads downloads = Downloads.mapCurrentDownloadMedia(media);
      Navigator.pushNamed(context, Downloader.routeName,
          arguments: ScreenArguements(
            position: 0,
            object: downloads,
          ));
    } else {
      showPreviewSubscribeAlertDialog(context);
    }
  }

  showPreviewSubscribeAlertDialog(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(StringsUtils.subscribehint),
          content: const Text(StringsUtils.start_subscription_hint),
          actions: <Widget>[
            FlatButton(
              child: Text(t.cancel.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text(StringsUtils.subscribe),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, SubscriptionScreen.routeName);
              },
            )
          ],
        );
      },
    );
  }
}

class Share {
  static shareFile(Media media) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    if (media.http) {
      await FlutterShare.share(
          title: StringsUtils.share_file_title + media.title,
          text: StringsUtils.share_file_title +
              media.title +
              "\n" +
              StringsUtils.share_file_body +
              " http://play.google.com/store/apps/details?id=" +
              packageName,
          linkUrl: "");
    } else {
      await FlutterShare.shareFile(
        title: StringsUtils.share_file_title + media.title,
        text: StringsUtils.share_file_body +
            " http://play.google.com/store/apps/details?id=" +
            packageName,
        filePath: media.streamUrl,
      );
    }
  }
}
