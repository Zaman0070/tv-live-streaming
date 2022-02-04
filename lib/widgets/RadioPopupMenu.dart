import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:newsextra/providers/AppStateNotifier.dart';
import 'package:newsextra/providers/RadioModel.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import 'package:newsextra/utils/TextStyles.dart';
import 'package:newsextra/utils/my_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:package_info/package_info.dart';
import '../providers/RadioBookmarksModel.dart';
import '../models/Radios.dart';
import 'package:flutter/cupertino.dart';
import '../utils/Alerts.dart';
import '../i18n/strings.g.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../utils/ApiUrl.dart';

class RadioPopupMenu extends StatefulWidget {
  RadioPopupMenu(this.media);
  final Radios media;

  @override
  _RadioPopupMenuState createState() => _RadioPopupMenuState();
}

class _RadioPopupMenuState extends State<RadioPopupMenu> {
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
    RadioBookmarksModel bookmarksModel =
        Provider.of<RadioBookmarksModel>(context);

    return PopupMenuButton(
      elevation: 3.2,
      //initialValue: choices[1],
      itemBuilder: (BuildContext context) {
        bool isBookmarked = bookmarksModel.isMediaBookmarked(widget.media);
        List<String> choices = [];
        if (isBookmarked) {
          choices.add(StringsUtils.unbookmark);
        } else {
          choices.add(StringsUtils.bookmark);
        }
        choices.add(StringsUtils.share);
        choices.add("Report Station");
        if (widget.media.extra != "") {
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
            bookmarksModel.bookmarkMedia(widget.media);
            break;
          case StringsUtils.unbookmark:
            bookmarksModel.unBookmarkMedia(widget.media);
            break;
          case StringsUtils.share:
            Share.shareFile(widget.media);
            break;
          case "Report Station":
            await showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return ReportRadioDialog(
                    radios: widget.media,
                  );
                });
            break;
          case "Visit Radio Link":
            openBrowserTab(widget.media.extra);
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

class ReportRadioDialog extends StatefulWidget {
  final Radios radios;
  ReportRadioDialog({Key key, this.radios}) : super(key: key);

  @override
  _ReportRadioDialogState createState() => _ReportRadioDialogState();
}

class _ReportRadioDialogState extends State<ReportRadioDialog> {
  List<String> reportOptions = StringsUtils.reportRadioList;
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        StringsUtils.report_comment,
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
            Navigator.of(context).pop();
            Provider.of<AppStateNotifier>(context, listen: false)
                .reportComment(widget.radios, reportOptions[_selected]);
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
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: reportOptions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                          title: Text(reportOptions[index]),
                          value: index,
                          groupValue: _selected,
                          onChanged: (value) {
                            setState(() {
                              _selected = index;
                            });
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Share {
  static shareFile(Radios media) async {
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
