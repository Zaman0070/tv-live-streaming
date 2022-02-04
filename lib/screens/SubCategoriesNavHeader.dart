import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../utils/my_colors.dart';
import '../providers/CategoryMediaScreensModel.dart';
import '../utils/TextStyles.dart';

Column subCategoriesNavHeader() {
  return Column(
    children: <Widget>[
      Consumer<CategoryMediaScreensModel>(
          builder: (context, catsProvider, child) {
        return Container(
          height: 55,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            //itemExtent: 100,
            itemCount: catsProvider.subCategoriesList.length,
            itemBuilder: (context, index) {
              bool selected = catsProvider.isSubcategorySelected(index);
              return Container(
                //width: 80,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: InkWell(
                    onTap: () {
                      catsProvider.refreshPageOnCategorySelected(
                          catsProvider.subCategoriesList[index].id);
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(catsProvider.subCategoriesList[index].title,
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
