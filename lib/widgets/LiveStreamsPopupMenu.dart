import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:newsextra/models/LiveStreams.dart';
import 'package:newsextra/providers/LivestreamsBookmarksModel.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import 'package:newsextra/utils/my_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter/cupertino.dart';

class LiveStreamsPopupMenu extends StatelessWidget {
  LiveStreamsPopupMenu(this.media);
  final LiveStreams media;

  openBrowserTab(String url) async {
    await FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        toolbarColor: MyColors.primary,
        secondaryToolbarColor: MyColors.primary,
        navigationBarColor: MyColors.primary,
        addDefaultShareMenuItem: true,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: MyColors.primary,
        preferredControlTintColor: MyColors.primary,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LivestreamsBookmarksModel bookmarksModel =
        Provider.of<LivestreamsBookmarksModel>(context);

    return PopupMenuButton(
      elevation: 3.2,
      //initialValue: choices[1],
      itemBuilder: (BuildContext context) {
        bool isBookmarked = bookmarksModel.isMediaBookmarked(media);
        List<String> choices = [];
        if (isBookmarked) {
          choices.add(StringsUtils.unbookmark);
        } else {
          choices.add(StringsUtils.bookmark);
        }
        choices.add(StringsUtils.share);
        if (media.extra != "") {
          choices.add("Visit Radio Link");
        }
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
      onSelected: (value) async {
        print(value);
        switch (value) {
          case StringsUtils.bookmark:
            bookmarksModel.bookmarkMedia(media);
            break;
          case StringsUtils.unbookmark:
            bookmarksModel.unBookmarkMedia(media);
            break;
          case StringsUtils.share:
            Share.shareFile(media);
            break;

          case "Visit LiveTv Link":
            openBrowserTab(media.extra);
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
}

class Share {
  static shareFile(LiveStreams media) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    await FlutterShare.share(
        title: StringsUtils.share_file_title + media.title,
        text: StringsUtils.share_file_title +
            media.title +
            "\n" +
            StringsUtils.share_file_body +
            " http://play.google.com/store/apps/details?id=" +
            packageName,
        linkUrl: "");
  }
}
