import 'package:flutter/material.dart';
import '../utils/my_colors.dart';
import '../screens/ArticlesScreenBookmarks.dart';
import '../screens/VideoScreenBookmarks.dart';
import '../i18n/strings.g.dart';
import '../utils/TextStyles.dart';

class BookmarksScreen extends StatefulWidget {
  BookmarksScreen({Key key}) : super(key: key);

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 45,
          child: Center(
            child: Wrap(
              children: List<Widget>.generate(
                2,
                (int index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ChipTheme(
                      data: ChipTheme.of(context).copyWith(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor),
                      child: ChoiceChip(
                        selectedColor: MyColors.primary,
                        labelStyle: _value == index
                            ? TextStyles.subhead(context).copyWith(
                                fontSize: 14,
                                fontFamily: "serif",
                                fontWeight: FontWeight.normal,
                                color: Colors.white)
                            : TextStyles.subhead(context).copyWith(
                                fontSize: 14,
                                fontFamily: "serif",
                                fontWeight: FontWeight.normal,
                              ),
                        label: index == 0
                            ? Text(t.articlesnav)
                            : Text(t.videosnav),
                        //labelPadding: EdgeInsets.fromLTRB(2, 2, 2, 2),
                        selected: _value == index,
                        onSelected: (bool selected) {
                          if (_value != index) {
                            setState(() {
                              _value = index;
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        Divider(),
        _value == 0
            ? Expanded(
                child: ArticlesScreenBookmarks(),
              )
            : Expanded(
                child: VideoScreenBookmarks(),
              ),
      ],
    );
  }
}
