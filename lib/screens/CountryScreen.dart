import 'package:flutter/material.dart';
import 'package:newsextra/i18n/strings.g.dart';
import 'package:newsextra/screens/HomePage.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';
import '../utils/img.dart';
import 'package:provider/provider.dart';
import '../providers/CountryModel.dart';
import '../models/Country.dart';
import '../utils/Alerts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_restart/flutter_restart.dart';

class CountryScreen extends StatelessWidget {
  static const routeName = "/countries";
  final bool isFirstLoad;
  CountryScreen({this.isFirstLoad});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CountryModel(isFirstLoad),
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0), child: Container()),
          body: Container(
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      color: MyColors.primary,
                      width: double.infinity,
                      height: 70,
                      child: Image.asset(Img.get('world_map.png'),
                          fit: BoxFit.contain),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(height: 10),
                            Text(t.appname,
                                style: TextStyles.title(context)
                                    .copyWith(color: Colors.white)),
                            Container(height: 5),
                            Text("Choose Country",
                                style: TextStyles.caption(context)
                                    .copyWith(color: Colors.grey[200]))
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    transform: Matrix4.translationValues(0.0, 0, 0.0),
                    child: CategoriesList(),
                  ),
                ),
                Consumer<CountryModel>(
                  builder: (context, cats, child) {
                    return Container(
                      width: double.infinity,
                      height: 50,
                      padding: EdgeInsets.only(left: 0, right: 0.0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: MyColors.primary,
                        child: Text("Proceed"),
                        onPressed: () async {
                          //print(isFirstLoad.toString());
                          if (cats.isLoading || cats.selectedCountry == null) {
                            Alerts.show(context, t.error,
                                "You must select country before you can proceed");
                          } else {
                            if (isFirstLoad) {
                              Navigator.pushReplacementNamed(
                                context,
                                HomePage.routeName,
                                // arguments: cats.dbcategories,
                              );
                            } else {
                              Navigator.of(context).pop();
                              //Phoenix.rebirth(context);
                              await FlutterRestart.restartApp();
                            }
                          }
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(0.0),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }
}

class CategoriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Country> countries = [];
    final countryModel = Provider.of<CountryModel>(context);
    countries = countryModel.items;
    //print("i am called");

    if (countryModel.isLoading) {
      return Center(child: CupertinoActivityIndicator());
    } else if (countryModel.items.length == 0) {
      return Center(
          child: Container(
        height: 200,
        child: GestureDetector(
          onTap: () {
            countryModel.fetchData();
          },
          child: ListView(children: <Widget>[
            Icon(
              Icons.refresh,
              size: 50.0,
              color: Colors.red,
            ),
            Text(
              "There was an error fetching countries.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            )
          ]),
        ),
      ));
    } else
      return ListView.separated(
        itemCount: countries.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          return Container(
              height: 60,
              child: CategoryItems(
                country: countries[index],
                countryModel: countryModel,
              ));
        },
      );
  }
}

class CategoryItems extends StatelessWidget {
  const CategoryItems({
    Key key,
    @required this.country,
    @required this.countryModel,
  }) : super(key: key);

  final Country country;
  final CountryModel countryModel;

  @override
  Widget build(BuildContext context) {
    //print("i am called here");
    return InkWell(
      child: ListTile(
        //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(country.thumbnailUrl),
        ),
        title: Text(
          country.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        //subtitle:  Text(categories.interest, ),
        trailing: Checkbox(
            activeColor: MyColors.primary,
            value: countryModel.isContain(country.id),
            onChanged: ((isChecked) {
              countryModel.setSelectedCountry(country);
            })),
      ),
      onTap: () {
        countryModel.setSelectedCountry(country);
      },
    );
  }
}
