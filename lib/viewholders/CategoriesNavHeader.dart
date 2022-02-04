import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateNotifier.dart';
import '../providers/ArticlesModel.dart';
import '../providers/VideosModel.dart';
import '../utils/my_colors.dart';
import '../utils/TextStyles.dart';
import '../i18n/strings.g.dart';

Column categoriesNavHeader2(ScrollController _controller) {
  return Column(
    children: <Widget>[
      Consumer<AppStateNotifier>(builder: (context, appStateNotifier, child) {
        //print("selectedcats = "+appStateNotifier.selectedcats.length.toString());
        return Container(
          height: 55,
          child: ListView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            //itemExtent: 100,
            itemCount: appStateNotifier.selectedcats.length,
            itemBuilder: (context, index) {
              bool selected = false;
              return Container(
                //width: 80,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: InkWell(
                    onTap: () {
                      appStateNotifier.chooseCategory(
                          appStateNotifier.selectedcats[index].toString());
                      Provider.of<ArticlesModel>(context, listen: false)
                          .refreshPageOnCategorySelected(
                              appStateNotifier.currentCategory);
                      Provider.of<VideosModel>(context, listen: false)
                          .refreshPageOnCategorySelected(
                              appStateNotifier.currentCategory);
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                                index == 0
                                    ? t.allstories
                                    : appStateNotifier.selectedcats[index],
                                style: TextStyles.headline(context).copyWith(
                                    fontFamily: "serif",
                                    fontSize: 15,
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                            selected
                                ? Container(
                                    width: 70,
                                    height: 2,
                                    color: MyColors.primary,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      // Divider(),
    ],
  );
}
