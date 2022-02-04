import 'package:flutter/material.dart';
import 'package:newsextra/utils/my_colors.dart';
import '../utils/img.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../providers/AppStateNotifier.dart';
import '../i18n/strings.g.dart';
import 'dart:io';
import '../screens/ForgotPasswordScreen.dart';
import '../screens/RegisterScreen.dart';
import '../utils/Alerts.dart';
import 'dart:convert';
import 'dart:async';
import '../utils/ApiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../models/Userdata.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  LoginScreen();

  @override
  LoginScreenRouteState createState() => new LoginScreenRouteState();
}

class LoginScreenRouteState extends State<LoginScreen> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  GoogleSignInAccount _currentUser;

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  verifyFormAndSubmit() {
    String _email = emailController.text;
    String _password = passwordController.text;

    if (_email == "" || _password == "") {
      Alerts.show(context, t.error, t.emptyfielderrorhint);
    } else if (EmailValidator.validate(_email) == false) {
      Alerts.show(context, t.error, t.invalidemailerrorhint);
    } else {
      loginUser(_email, _password, "", "");
    }
  }

  Future<void> loginUser(
      String email, String password, String name, String type) async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      var data = {
        "email": email,
        "password": password,
      };
      if (type != "") {
        data = {
          "email": email,
          "password": password,
          "name": name,
          "type": type
        };
      }
      final response = await http.post(Uri.parse(ApiUrl.LOGIN),
          body: jsonEncode({"data": data}));
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
          print(res["user"]);
          //Alerts.show(context, Strings.success, res["message"]);
          Provider.of<AppStateNotifier>(context, listen: false)
              .setUserData(Userdata.fromJson(res["user"]));
          Navigator.of(context).pop();
        }
        //print(res);
      } else {
        print(response.body);
      }
    } catch (exception) {
      // Navigator.pop(context);
      // I get no exception here
      print(exception);
    }
  }

  Future<Null> loginWithFacebook() async {
    final FacebookLoginResult result =
        await facebookSignIn.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        var graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}'));
        Map<String, dynamic> profile = json.decode(graphResponse.body);
        print(profile);
        loginUser(profile['email'], "", profile['name'], "Facebook");
        break;
      case FacebookLoginStatus.cancelledByUser:
        Toast.show('Login cancelled by the user.', context);
        break;
      case FacebookLoginStatus.error:
        Toast.show(
            'Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}',
            context);
        break;
    }
  }

  applesigning() async {
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential.email);
          loginUser(
              result.credential.email,
              "",
              result.credential.fullName.familyName +
                  " " +
                  result.credential.fullName.givenName,
              "Apple");
          break;
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          Alerts.show(context, t.error,
              "Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        // _handleGetContact();
        print(_currentUser.email);
        loginUser(_currentUser.email, "", _currentUser.displayName, "Google");
      }
    });
    googleSignIn.signInSilently();
    //_googleSignIn.signOut();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      resizeToAvoidBottomInset: true,
      // backgroundColor: Colors.white,
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
            Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                    width: double.infinity,
                    height: double.infinity,
                    child: ListView(
                      children: <Widget>[
                        Container(height: 0),
                        Container(
                          child: Center(
                              child: Text(
                            t.appname,
                            style: TextStyle(color: Colors.white, fontSize: 26),
                          )),
                          width: double.infinity,
                          height: 100,
                        ),
                        Container(height: 0),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.text,
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
                          controller: passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.text,
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
                        Container(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextButton(
                              child: Text(
                                t.createaccount,
                                style: TextStyle(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, RegisterScreen.routeName);
                              },
                            ),
                            Container(height: 5),
                            TextButton(
                              child: Text(
                                t.forgotpassword,
                                style: TextStyle(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, ForgotPasswordScreen.routeName);
                              },
                            )
                          ],
                        ),
                        Container(height: 15),
                        Container(
                          width: double.infinity,
                          height: 40,
                          child: TextButton(
                            child: Text(
                              t.login,
                              style: TextStyle(color: MyColors.primary),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20)),
                            ),
                            onPressed: () {
                              verifyFormAndSubmit();
                            },
                          ),
                        ),
                        Container(height: 40),
                        Center(
                          child: Text(
                            t.orloginwith,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(height: 15),
                        Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                icon: FaIcon(
                                  FontAwesomeIcons.facebook,
                                  color: Colors.blue,
                                  size: 20,
                                ), //`Icon` to display
                                label: Text(
                                  t.facebook,
                                  style: TextStyle(color: Colors.blue),
                                ), //`Text` to display
                                onPressed: () {
                                  loginWithFacebook();
                                },
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                icon: FaIcon(
                                  FontAwesomeIcons.google,
                                  color: MyColors.primary,
                                  size: 20,
                                ), //`Icon` to display
                                label: Text(
                                  t.google,
                                  style: TextStyle(color: MyColors.primary),
                                ), //`Text` to display
                                onPressed: () {
                                  _handleSignIn();
                                },
                              ),
                            ),
                            Visibility(
                              visible: Platform.isIOS ? true : false,
                              child: Container(
                                width: double.infinity,
                                child: AppleSignInButton(
                                  //style: ButtonStyle.white,
                                  type: ButtonType.continueButton,
                                  onPressed: () {
                                    applesigning();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(height: 15),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          t.skiplogin,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
