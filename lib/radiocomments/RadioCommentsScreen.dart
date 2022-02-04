import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsextra/models/Radios.dart';
import 'package:newsextra/radiocomments/CommentsItem.dart';
import 'package:newsextra/radiocomments/CommentsRadioHeader.dart';
import 'package:newsextra/radiocomments/RadioCommentsModel.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateNotifier.dart';
import '../screens/LoginScreen.dart';
import '../models/Userdata.dart';
import '../models/Comments.dart';
import '../utils/my_colors.dart';

class RadioCommentsScreen extends StatefulWidget {
  static String routeName = "/RadioCommentsScreen";
  final Radios item;
  final int commentCount;

  RadioCommentsScreen({Key key, this.item, this.commentCount})
      : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<RadioCommentsScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.item.toString());
    final appState = Provider.of<AppStateNotifier>(context);
    Userdata userdata = appState.userdata;

    return ChangeNotifierProvider(
        create: (context) => RadioCommentsModel(
            context, widget.item.id, userdata, widget.commentCount),
        child: CommentsSection(widget: widget, userdata: userdata));
  }
}

class CommentsSection extends StatelessWidget {
  const CommentsSection({
    Key key,
    @required this.widget,
    @required this.userdata,
  }) : super(key: key);

  final RadioCommentsScreen widget;
  final Userdata userdata;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context,
            Provider.of<RadioCommentsModel>(context, listen: false)
                .totalPostComments);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(
                context,
                Provider.of<RadioCommentsModel>(context, listen: false)
                    .totalPostComments),
          ),
          title: Text(StringsUtils.comments),
        ),
        body: Column(
          children: <Widget>[
            CommentsRadioHeader(object: widget.item),
            Container(height: 5),
            Expanded(
              child: CommentsLists(),
            ),
            Divider(height: 0, thickness: 1),
            userdata == null
                ? Container(
                    height: 50,
                    child: Center(
                        child: RaisedButton(
                            child: Text(StringsUtils.login_to_add_comment),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, LoginScreen.routeName);
                            })),
                  )
                : Consumer<RadioCommentsModel>(
                    builder: (context, commentsModel, child) {
                    return Row(
                      children: <Widget>[
                        Container(width: 10),
                        Expanded(
                          child: TextField(
                            controller: commentsModel.inputController,
                            maxLines: 5,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration: new InputDecoration.collapsed(
                                hintText: StringsUtils.write_a_message),
                          ),
                        ),
                        commentsModel.isMakingComment
                            ? Container(
                                width: 30, child: CupertinoActivityIndicator())
                            : IconButton(
                                icon: Icon(Icons.send,
                                    color: MyColors.primary, size: 20),
                                onPressed: () {
                                  String text =
                                      commentsModel.inputController.text;
                                  if (text != "") {
                                    commentsModel.makeComment(text);
                                  }
                                }),
                      ],
                    );
                  })
          ],
        ),
      ),
    );
  }
}

class CommentsLists extends StatelessWidget {
  const CommentsLists({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var commentsModel = Provider.of<RadioCommentsModel>(context);
    List<Comments> commentsList = commentsModel.items;
    if (commentsModel.isLoading) {
      return Center(child: CupertinoActivityIndicator());
    } else if (commentsList.length == 0) {
      return Center(
          child: Container(
        height: 200,
        child: GestureDetector(
          onTap: () {
            commentsModel.loadComments();
          },
          child: ListView(children: <Widget>[
            Icon(
              Icons.refresh,
              size: 50.0,
              color: Colors.red,
            ),
            Text(
              StringsUtils.no_comments,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            )
          ]),
        ),
      ));
    } else {
      return ListView.separated(
        controller: commentsModel.scrollController,
        itemCount: commentsModel.hasMoreComments
            ? commentsList.length + 1
            : commentsList.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          if (index == 0 && commentsModel.isLoadingMore) {
            return Container(
                width: 30, child: Center(child: CupertinoActivityIndicator()));
          } else if (index == 0 && commentsModel.hasMoreComments) {
            return Container(
              height: 30,
              child: Center(
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20)),
                      child: Text(StringsUtils.load_more),
                      onPressed: () {
                        Provider.of<RadioCommentsModel>(context, listen: false)
                            .loadMoreComments();
                      })),
            );
          } else {
            int _index = index;
            if (commentsModel.hasMoreComments) _index = index - 1;
            return CommentsItem(
              isUser: commentsModel.isUser(commentsList[_index].email),
              context: context,
              index: _index,
              object: commentsList[_index],
            );
          }
        },
      );
    }
  }
}
