import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import '../utils/Alerts.dart';
import 'dart:convert';
import 'dart:async';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;
import '../screens/LoginScreen.dart';
import '../utils/img.dart';
import '../utils/my_colors.dart';
import 'package:email_validator/email_validator.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = "/register";
  RegisterScreen();

  @override
  RegisterScreenRouteState createState() => new RegisterScreenRouteState();
}

class RegisterScreenRouteState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  verifyFormAndSubmit() {
    String _name = nameController.text;
    String _email = emailController.text;
    String _password = passwordController.text;
    String _repeatPassword = repeatPasswordController.text;

    if (_name == "" || _email == "" || _password == "") {
      Alerts.show(context, t.error, t.emptyfielderrorhint);
    } else if (EmailValidator.validate(_email) == false) {
      Alerts.show(context, t.error, t.invalidemailerrorhint);
    } else if (_password != _repeatPassword) {
      Alerts.show(context, t.error, t.passwordsdontmatch);
    } else {
      registerUser(_email, _name, _password);
    }
  }

  Future<void> registerUser(String email, String name, String password) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      final response = await http.post(Uri.parse(ApiUrl.REGISTER),
          body: jsonEncode({
            "data": {
              "email": email,
              "name": name,
              "password": password,
            }
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
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
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: Image.asset(Img.get("world_map.png")),
            ),
            Column(children: <Widget>[
              Container(
                height: 20,
              ),
              Container(
                child: Center(
                    child: Text(
                  t.appname,
                  style: TextStyle(color: Colors.white, fontSize: 26),
                )),
                width: double.infinity,
                height: 100,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  width: double.infinity,
                  height: double.infinity,
                  child: ListView(
                    children: <Widget>[
                      Container(height: 0),
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: t.fullname,
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                      Container(height: 25),
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: t.emailaddress,
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                      Container(height: 25),
                      TextField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: passwordController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: t.password,
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                      Container(height: 25),
                      TextField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: repeatPasswordController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: t.repeatpassword,
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                      Container(height: 35),
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          child: Text(
                            t.register,
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
                            t.logintoaccount,
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.routeName);
                          },
                        ),
                      ),
                    ],
                    //mainAxisSize: MainAxisSize.min,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        t.skipregister,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
