import '../screens/CountryScreen.dart';
import '../providers/DatabaseManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';
import '../i18n/strings.g.dart';

class DownloadItemsScreen extends StatefulWidget {
  static const routeName = "/DownloadItemsScreen";
  const DownloadItemsScreen({
    Key key,
  }) : super(key: key);

  @override
  _DownloadItemsScreenState createState() => _DownloadItemsScreenState();
}

class _DownloadItemsScreenState extends State<DownloadItemsScreen> {
  DatabaseManager databaseManager;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<DatabaseManager>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    databaseManager = Provider.of<DatabaseManager>(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(databaseManager.title,
                      style: TextStyles.display1(context).copyWith(
                          //color: MyColors.primary,
                          fontWeight: FontWeight.bold)),
                  Container(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(databaseManager.message,
                        textAlign: TextAlign.center,
                        style: TextStyles.medium(context).copyWith(
                            //color: MyColors.primary
                            )),
                  ),
                  Container(height: 25),
                  Visibility(
                    visible: databaseManager.isLoading,
                    child: Container(
                      width: 180,
                      height: 40,
                      child: CupertinoActivityIndicator(
                        radius: 20,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: databaseManager.isError,
                    child: Container(
                      width: 180,
                      height: 40,
                      child: TextButton(
                        child: Text(t.retry,
                            style: TextStyle(color: Colors.white)),
                        style: TextButton.styleFrom(
                          backgroundColor: MyColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          databaseManager.fetchData();
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: databaseManager.downloadDone,
                    child: Container(
                      width: 180,
                      height: 40,
                      child: TextButton(
                        child: Text("Proceed",
                            style: TextStyle(color: Colors.white)),
                        style: TextButton.styleFrom(
                          backgroundColor: MyColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CountryScreen(
                                        isFirstLoad: true,
                                      )));
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
