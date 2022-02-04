import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsextra/screens/DownloadItemsScreen.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateNotifier.dart';
import '../screens/CountryScreen.dart';
import '../utils/my_colors.dart';
import '../utils/TextStyles.dart';
import '../models/Onboarder.dart';
import '../i18n/strings.g.dart';
import '../utils/img.dart';

class OnboardingPage extends StatefulWidget {
  static const routeName = "/onboarding";
  OnboardingPage();

  @override
  OnboarderPageState createState() => new OnboarderPageState();
}

class OnboarderPageState extends State<OnboardingPage> {
  List<Onboarder> onboarderItem = Onboarder.getOnboardingItems();
  PageController pageController = PageController(
    initialPage: 0,
  );
  int page = 0;
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: Colors.grey[100])),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                PageView(
                  onPageChanged: onPageViewChange,
                  controller: pageController,
                  children: buildPageViewItem(),
                ),
                Row(
                  children: <Widget>[
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close, color: MyColors.grey_40),
                      onPressed: () {
                        Provider.of<AppStateNotifier>(context, listen: false)
                            .setUserSeenOnboardingPage(true);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DownloadItemsScreen()));
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 60,
              child: Align(
                alignment: Alignment.topCenter,
                child: buildDots(context),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: TextButton(
              child: Text(isLast ? t.done : t.next,
                  style: TextStyles.subhead(context).copyWith(
                      color: MyColors.grey_90, fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(
                backgroundColor: MyColors.grey_10,
              ),
              onPressed: () {
                if (isLast) {
                  Provider.of<AppStateNotifier>(context, listen: false)
                      .setUserSeenOnboardingPage(true);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DownloadItemsScreen()));
                  return;
                }
                pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              },
            ),
          )
        ]),
      ),
    );
  }

  void onPageViewChange(int _page) {
    page = _page;
    isLast = _page == onboarderItem.length - 1;
    setState(() {});
  }

  List<Widget> buildPageViewItem() {
    List<Widget> widgets = [];
    for (Onboarder onboarder in onboarderItem) {
      Widget wg = Container(
        padding: EdgeInsets.all(35),
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Wrap(
          children: <Widget>[
            Container(
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Image.asset(Img.get(onboarder.image),
                              width: 150, height: 150),
                        ),
                        Text(onboarder.title,
                            style: TextStyles.medium(context).copyWith(
                                color: MyColors.grey_80,
                                fontFamily: "serif",
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                        Container(
                          width: 120,
                          height: 2,
                          color: MyColors.primary,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: Text(onboarder.hint,
                              textAlign: TextAlign.center,
                              style: TextStyles.subhead(context)
                                  .copyWith(color: MyColors.grey_60)),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      );
      widgets.add(wg);
    }
    return widgets;
  }

  Widget buildDots(BuildContext context) {
    Widget widget;

    List<Widget> dots = [];
    for (int i = 0; i < onboarderItem.length; i++) {
      Widget w = Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 8,
        width: 8,
        child: CircleAvatar(
          backgroundColor: page == i ? MyColors.primary : MyColors.grey_20,
        ),
      );
      dots.add(w);
    }
    widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: dots,
    );
    return widget;
  }
}
