import 'package:newsextra/i18n/strings.g.dart';
import 'package:newsextra/providers/AppStateNotifier.dart';
import 'package:newsextra/utils/TextStyles.dart';

import '../utils/my_colors.dart';
import 'dart:convert';
import '../utils/ApiUrl.dart';
import '../utils/Alerts.dart';
import '../models/Userdata.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ComplaintsScreen extends StatefulWidget {
  static const routeName = "/ComplaintsScreen";
  ComplaintsScreen();

  @override
  ComplaintsScreenScreenState createState() =>
      new ComplaintsScreenScreenState();
}

class ComplaintsScreenScreenState extends State<ComplaintsScreen> {
  Userdata userdata;
  TextEditingController contentController = TextEditingController();
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();

  validateandsubmit() async {
    String _title = titleController.text;
    String _name = nameController.text;
    String _email = emailController.text;
    String _content = contentController.text;
    if (_name == "" || _title == "" || _email == "" || _content == "") {
      Alerts.show(context, "", "Please fill all the fields before you submit.");
      return;
    }
    submitPosttoServer(_name, _email, _title, _content);
  }

  submitPosttoServer(
      String name, String email, String title, String content) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    FormData formData = FormData.fromMap({
      "content": content,
      "title": title,
      "name": name,
      "email": email,
    });

    Dio dio = new Dio();

    try {
      var response = await dio.post(ApiUrl.save_complaint, data: formData,
          onSendProgress: (int send, int total) {
        print((send / total) * 100);
      });
      Navigator.of(context).pop();
      print(response.data);

      Map<String, dynamic> res = json.decode(response.data);
      if (res["status"] == "ok") {
        nameController.text = "";
        emailController.text = "";
        titleController.text = "";
        contentController.text = "";
        Alerts.show(
            context, "Success", "You have succesfully shared your feedback.");
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
  void initState() {
    userdata = Provider.of<AppStateNotifier>(context, listen: false).userdata;
    if (userdata != null) {
      nameController.text = userdata.name;
      emailController.text = userdata.email;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
            "Feedbacks"), /* actions: <Widget>[
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
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 0, 20),
                  child: Text(
                    "Share with us your complaints or feedbacks on how to improve this app.",
                    style: TextStyles.headline(context).copyWith(
                      //fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Text("Name",
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
                    controller: nameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Email",
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
                    controller: emailController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Subject",
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
                    controller: titleController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("Body",
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
                  height: 150,
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
                    maxLines: 5,
                    keyboardType: TextInputType.text,
                    controller: contentController,
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
