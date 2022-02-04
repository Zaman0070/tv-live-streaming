import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:device_id/device_id.dart';
import '../models/Articles.dart';
import '../models/Videos.dart';
import 'my_colors.dart';

var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  var data = message.data;
  Firebase.handleNotificationMessages(data);
}

class Firebase {
  String location = "wo", deviceID = "flutternewsextra123";
  Function navigateArticle;
  Function navigateVideo;
  BuildContext context;

  Firebase(
      BuildContext context, Function navigateArticle, Function navigateVideo) {
    this.navigateArticle = navigateArticle;
    this.navigateVideo = navigateVideo;
    this.context = context;
    getUserData();
  }

  getUserData() async {
    try {
      location = await FlutterSimCountryCode.simCountryCode;
      deviceID = await DeviceId.getID;
      print("location= " + location);
    } catch (e) {
      location = 'wo';
      print("location= " + location);
    }
  }

  //updated myBackgroundMessageHandler
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    handleNotificationMessages(message);
    return Future<void>.value();
  }

  void init() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/launcher_icon');

    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelect);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelect);

    FirebaseMessaging.onMessage.listen((message) async {
      print("onMessage: $message");
      handleNotificationMessages(message.data);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.getToken().then((token) {
      print("Push Messaging token: $token");
      sendFirebaseTokenToServer(token);
    });
  }

  static handleNotificationMessages(Map<String, dynamic> message) {
    var data = message;
    //['data'];
    print("myBackgroundMessageHandler message: $data");
    var action = data["action"];
    String title = "";
    String msg = "";
    if (action == "pushNotification") {
      Map<String, dynamic> arts = json.decode(data['article']);
      Articles articles = Articles.fromJson(arts);
      title = articles.source;
      msg = articles.title;
    } else if (action == "videoPushNotification") {
      Map<String, dynamic> arts = json.decode(data['videos']);
      Videos videos = Videos.fromJson(arts);
      title = videos.source;
      msg = videos.title;
    }

    if (title != "" && msg != "") {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'newsextra_flutter', 'newsextra_flutter', 'NewsExtra_app',
          color: MyColors.primary,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      flutterLocalNotificationsPlugin.show(
          100, title, msg, platformChannelSpecifics,
          payload: json.encode(message));
    }
  }

  Future<String> onSelect(String itm) async {
    print("onSelectNotification $itm");
    Map<String, dynamic> message = json.decode(itm);
    var data = message;
    //['data'];
    var action = data["action"];
    print("pushNotification = " + action);
    if (action == "pushNotification") {
      Map<String, dynamic> arts = json.decode(data['article']);
      Articles articles = Articles.fromJson(arts);
      List<Articles> artsList = [];
      artsList.add(articles);
      navigateArticle(artsList);
    } else if (action == "videoPushNotification") {
      Map<String, dynamic> arts = json.decode(data['videos']);
      Videos vids = Videos.fromJson(arts);
      List<Videos> vidsList = [];
      vidsList.add(vids);
      navigateVideo(vidsList);
    }
    return "";
  }

  sendFirebaseTokenToServer(String token) async {
    bool status = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("token_sent_to_server") != null) {
      status = prefs.getBool("token_sent_to_server");
    }
    if (status == false) {
      print("Firebase token not yet sent to server");

      var data = {
        "token": token,
        "uuid": "flutternewsextra123",
        "location": location
      };
      print(data.toString());
      try {
        final response = await http.post(Uri.parse(ApiUrl.storeFcmToken),
            body: jsonEncode({"data": data}));
        if (response.statusCode == 200) {
          // If the server did return a 200 OK response,
          // then parse the JSON.
          print(response.body);
          Map<String, dynamic> res = json.decode(response.body);
          if (res["status"] == "ok") {
            prefs.setBool("token_sent_to_server", true);
          }
        }
      } catch (exception) {
        // I get no exception here
        print(exception);
      }
    } else {
      print("Firebase token sent to server");
    }
  }
}
