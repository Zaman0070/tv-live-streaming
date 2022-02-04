import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:newsextra/i18n/strings.g.dart';
import 'package:newsextra/providers/AppStateNotifier.dart';
import 'package:newsextra/utils/ApiUrl.dart';
import 'package:newsextra/utils/TextStyles.dart';
import 'package:provider/provider.dart';

import '../utils/my_colors.dart';
import '../utils/Alerts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateRadioScreen extends StatefulWidget {
  static const routeName = "/CreateRadioScreen";
  CreateRadioScreen();

  @override
  FeedbacksScreenState createState() => new FeedbacksScreenState();
}

class FeedbacksScreenState extends State<CreateRadioScreen> {
  TextEditingController contentController = TextEditingController();
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController categoryController = new TextEditingController();
  final TextEditingController thumbnailController = new TextEditingController();
  final TextEditingController streamController = new TextEditingController();
  final TextEditingController tvController = new TextEditingController();

  validateandsubmit() async {
    String _title = titleController.text;
    String _category = categoryController.text;
    String _thumbnail = thumbnailController.text;
    String _stream = streamController.text;
    String _tv = tvController.text;
    if (_title == "" || _category == "" || _thumbnail == "" || _stream == "") {
      Alerts.show(context, "", "Please fill all the fields before you submit.");
      return;
    }
    submitPosttoServer(_title, _category, _thumbnail, _stream, _tv);
  }

  submitPosttoServer(String title, String category, String thumbnail,
      String stream, String tv) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    FormData formData = FormData.fromMap({
      "country": Provider.of<AppStateNotifier>(context, listen: false)
          .selectedCountry
          .id,
      "title": title,
      "category": category,
      "thumbnail": thumbnail,
      "stream": stream,
      "tv": tv
    });

    Dio dio = new Dio();

    try {
      var response = await dio.post(ApiUrl.createradio, data: formData,
          onSendProgress: (int send, int total) {
        print((send / total) * 100);
      });
      Navigator.of(context).pop();
      print(response.data);

      Map<String, dynamic> res = json.decode(response.data);
      if (res["status"] == "ok") {
        titleController.text = "";
        categoryController.text = "";
        thumbnailController.text = "";
        streamController.text = "";
        tvController.text = "";
        Alerts.show(context, "Success",
            "You have succesfully submitted a radio station.");
        return;
      }
      //Navigator.pop(context, true);
    } on DioError catch (e) {
      Navigator.of(context).pop();
      Alerts.show(context, "Error", e.message);
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        //print(e.response.request);
      } else {
        //print(e.request.headers);
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
            "Add Radio Station"), /*actions: <Widget>[
        IconButton(
          icon: Icon(Icons.done_all),
          onPressed: () {
            validateandsubmit();
          },
        ),
      ]*/
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Radio Title",
                  style: TextStyles.body1(context)
                      .copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[900],
                        blurRadius: 0,
                      )
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    controller: titleController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Radio Category",
                  style: TextStyles.body1(context)
                      .copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[900],
                        blurRadius: 0,
                      )
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    controller: categoryController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Radio Thumbnail",
                  style: TextStyles.body1(context)
                      .copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[900],
                        blurRadius: 0,
                      )
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: thumbnailController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Radio Stream Link",
                  style: TextStyles.body1(context)
                      .copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[900],
                        blurRadius: 0,
                      )
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: streamController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Radio LiveStream Link (optional)",
                  style: TextStyles.body1(context)
                      .copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[900],
                        blurRadius: 0,
                      )
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: tvController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 200,
                  height: 50,
                  child: TextButton(
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      validateandsubmit();
                    },
                  ),
                ),
              ),
              Container(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
