import 'package:flutter/material.dart';
import 'package:newsextra/utils/my_colors.dart';
import '../i18n/strings.g.dart';
import '../screens/LoginScreen.dart';
import '../utils/Alerts.dart';
import '../utils/img.dart';
import 'dart:convert';
import 'dart:async';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = "/forgotpassword";
  ForgotPasswordScreen();

  @override
  ForgotPasswordScreenRouteState createState() =>
      new ForgotPasswordScreenRouteState();
}

class ForgotPasswordScreenRouteState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  verifyFormAndSubmit() {
    String _email = emailController.text;

    if (_email == "") {
      Alerts.show(context, t.error, t.emptyfielderrorhint);
    } else if (EmailValidator.validate(_email) == false) {
      Alerts.show(context, t.error, t.invalidemailerrorhint);
    } else {
      registerUser(_email);
    }
  }

  Future<void> registerUser(String email) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      final response = await http.post(Uri.parse(ApiUrl.RESETPASSWORD),
          body: jsonEncode({
            "data": {"email": email}
          }));
      if (response.statusCode == 200) {
        // Navigator.pop(context);
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Navigator.of(context).pop();
        print(response.body);
        Map<String, dynamic> res = json.decode(response.body);
        if (res["status"] == "error") {
          Alerts.show(context, t.error, res["message"]);
        } else {
          Alerts.show(context, t.success, res["message"]);
        }
        print(res);
      }
    } catch (exception) {
      // Navigator.pop(context);
      // I get no exception here
      print(exception);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.primary,
      appBar:
          PreferredSize(child: Container(), preferredSize: Size.fromHeight(0)),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: Image.asset(Img.get("world_map.png")),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: <Widget>[
                  Container(height: 10),
                  Container(height: 0),
                  Container(
                    child: Center(
                        child: Text(
                      t.appname,
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )),
                    width: double.infinity,
                    height: 80,
                  ),
                  Container(height: 60),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: t.emailaddress,
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  Container(height: 25),
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      child: Text(
                        t.resetpassword,
                        style: TextStyle(color: MyColors.primary),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        verifyFormAndSubmit();
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      child: Text(
                        t.gotologin,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(primary: Colors.transparent),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                    ),
                  ),
                  Spacer(),
                ],
                // mainAxisSize: MainAxisSize.min,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
