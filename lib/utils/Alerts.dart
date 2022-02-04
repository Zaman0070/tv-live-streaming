import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsextra/screens/LoginScreen.dart';
import 'package:newsextra/screens/SubscriptionScreen.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import '../i18n/strings.g.dart';

class Alerts {
  static Future<void> show(context, title, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(t.ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showCupertinoAlert(context, title, message) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(title),
              content: new Text(message),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(t.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  static showProgressDialog(BuildContext context, String title) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Flexible(
                      flex: 8,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }

  static subscriptionloginrequiredhint(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(StringsUtils.loginrequired),
          content: const Text(StringsUtils.loginrequiredhint),
          actions: <Widget>[
            FlatButton(
              child: Text(t.cancel.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(t.login.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
            )
          ],
        );
      },
    );
  }

  static showPlaySubscribeAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(StringsUtils.subscribehint),
          content: const Text(StringsUtils.playsubscriptionrequiredhint),
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

  static showPreviewSubscribeAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(StringsUtils.subscribehint),
          content: Text(StringsUtils.previewsubscriptionrequiredhint),
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
