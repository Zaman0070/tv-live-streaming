import 'package:flutter/material.dart';
import 'package:newsextra/screens/CategoriesScreen.dart';
import 'package:newsextra/screens/ComplaintsScreen.dart';
import 'package:newsextra/screens/CountryScreen.dart';
import 'package:newsextra/screens/CreateRadioScreen.dart';
import 'package:newsextra/screens/FavoritesScreen.dart';
import 'package:newsextra/screens/MediaCategoriesScreen.dart';
import 'package:newsextra/screens/RadioRecordingsScreen.dart';
import 'package:newsextra/screens/SourcesScreen.dart';
import 'package:newsextra/screens/UploadMediaScreen.dart';
import 'package:provider/provider.dart';
import '../screens/weather_screen.dart';
import '../screens/LoginScreen.dart';
import '../models/Userdata.dart';
import 'package:flutter/cupertino.dart';
import '../providers/AppStateNotifier.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';
import '../utils/StringsUtils.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:launch_review/launch_review.dart';
import '../i18n/strings.g.dart';
import '../utils/langs.dart';

class DrawerScreen extends StatefulWidget {
  DrawerScreen({Key key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  var appState;

  Future<void> showLogoutAlert() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(t.logoutfromapp),
              content: new Text(t.logoutfromapphint),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                    appState.unsetUserData();
                    _handleSignOut();
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future<void> _handleSignOut() async {
    try {
      await googleSignIn.signOut();
    } catch (error) {
      print(error);
    }
  }

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
    appState = Provider.of<AppStateNotifier>(context);
    Userdata userdata = appState.userdata;
    String language =
        appLanguageData[AppLanguage.values[appState.preferredLanguage]]
            ['value'];

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              color: MyColors.primary,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Text(
                      userdata == null
                          ? t.guestuser.substring(0, 1)
                          : userdata.name.substring(0, 1),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(height: 10),
                  Text(userdata == null ? t.guestuser : userdata.name,
                      style: TextStyles.title(context)
                          .copyWith(color: Colors.white, fontSize: 17)),
                  Container(height: 5),
                  userdata != null
                      ? Text(userdata.email,
                          style: TextStyles.subhead(context)
                              .copyWith(color: MyColors.grey_10, fontSize: 13))
                      : Container(),
                  Container(
                    height: 12,
                  ),
                  SizedBox(
                    height: 30,
                    width: 150,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: new BorderRadius.circular(10)),
                      ),
                      child: Text(
                        userdata != null ? t.logout : t.login,
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        if (userdata != null) {
                          showLogoutAlert();
                        } else {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 5),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, CountryScreen.routeName);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.language,
                              size: 20.0, color: Colors.red[500]),
                          Container(width: 10),
                          Text("Change Country",
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                              )),
                          Spacer(),
                          Icon(Icons.navigate_next,
                              size: 25.0, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, CategoriesScreen.routeName);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.category,
                              size: 20.0, color: Colors.blue[500]),
                          Container(width: 10),
                          Text("News Category",
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                              )),
                          Spacer(),
                          Icon(Icons.navigate_next,
                              size: 25.0, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, MediaCategoriesScreen.routeName);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.playlist_play,
                              size: 20.0, color: Colors.blue[500]),
                          Container(width: 10),
                          Text("E-Zone Category",
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                              )),
                          Spacer(),
                          Icon(Icons.navigate_next,
                              size: 25.0, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, FavoritesScreen.routeName);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.favorite,
                              size: 20.0, color: Colors.blue[500]),
                          Container(width: 10),
                          Text("Favorites",
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                              )),
                          Spacer(),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RadioRecordingsScreen.routeName);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.record_voice_over,
                              size: 20.0, color: Colors.blue[500]),
                          Container(width: 10),
                          Text("Recordings",
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                              )),
                          Spacer(),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 15),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      await showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return FeedbackDialog();
                          });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.feedback_outlined,
                              size: 20.0, color: Colors.blue[500]),
                          Container(width: 10),
                          Text("FeedBacks",
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                              )),
                          Spacer(),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 8),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.color_lens,
                              size: 20.0, color: Colors.yellow[800]),
                          Container(width: 10),
                          Text(t.nightmode,
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                              )),
                          Spacer(),
                          Switch(
                            value: appState.isDarkModeOn,
                            onChanged: (value) {
                              appState.setAppTheme(value);
                            },
                            activeColor: MyColors.primary,
                            inactiveThumbColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.notifications,
                              size: 20.0, color: Colors.blue[500]),
                          Container(width: 10),
                          Text(t.receievepshnotifications,
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                              )),
                          Spacer(),
                          Switch(
                            value: appState.isReceievePushNotifications,
                            onChanged: (value) {
                              appState.setRecieveNotifications(value);
                            },
                            activeColor: MyColors.primary,
                            inactiveThumbColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 20),
                  Divider(height: 1, color: Colors.grey),
                  Container(height: 20),
                  InkWell(
                    onTap: () {
                      LaunchReview.launch();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.rate_review,
                              size: 20.0, color: Colors.blue[500]),
                          Container(width: 10),
                          Text(t.rate,
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                              )),
                          Spacer(),
                          Icon(Icons.navigate_next,
                              size: 25.0, color: Colors.blue[500]),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10),
                  InkWell(
                    onTap: () {
                      openBrowserTab(StringsUtils.ABOUT);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.info, size: 20.0, color: Colors.blue[500]),
                          Container(width: 10),
                          Text(t.about,
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                              )),
                          Spacer(),
                          Icon(Icons.navigate_next,
                              size: 25.0, color: Colors.blue[500]),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10),
                  InkWell(
                    onTap: () {
                      openBrowserTab(StringsUtils.TERMS);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.chrome_reader_mode,
                              size: 20.0, color: Colors.blue[500]),
                          Container(width: 10),
                          Text(t.terms,
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                              )),
                          Spacer(),
                          Icon(Icons.navigate_next,
                              size: 25.0, color: Colors.blue[500]),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10),
                  InkWell(
                    onTap: () {
                      openBrowserTab(StringsUtils.PRIVACY);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.label_important,
                              size: 20.0, color: Colors.blue[500]),
                          Container(width: 10),
                          Text(t.privacy,
                              style: TextStyles.subhead(context).copyWith(
                                fontSize: 15,
                              )),
                          Spacer(),
                          Icon(Icons.navigate_next,
                              size: 25.0, color: Colors.blue[500]),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 10),
                ],
              ),
            ),
            Container(height: 0),
          ],
        ),
      ),
    );
  }
}

class FeedbackDialog extends StatefulWidget {
  FeedbackDialog({Key key}) : super(key: key);

  @override
  _ReportRadioDialogState createState() => _ReportRadioDialogState();
}

class _ReportRadioDialogState extends State<FeedbackDialog> {
  List<String> reportOptions = StringsUtils.feedbackoptions;
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Select an option",
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
            //reportComment(widget.radios, reportOptions[_selected]);
            switch (_selected) {
              case 0:
                Navigator.pushNamed(context, ComplaintsScreen.routeName);
                break;
              case 1:
                Navigator.pushNamed(context, UploadMediaScreen.routeName);
                break;
              case 2:
                Navigator.pushNamed(context, CreateRadioScreen.routeName);
                break;
            }
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
