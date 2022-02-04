import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsextra/comments/MediaCommentsModel.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateNotifier.dart';
import '../screens/LoginScreen.dart';
import '../widgets/CommentsItem.dart';
import '../models/Userdata.dart';
import '../models/Comments.dart';
import '../models/Media.dart';
import '../utils/my_colors.dart';
import '../widgets/CommentsMediaHeader.dart';

class MediaCommentsScreen extends StatefulWidget {
  static String routeName = "/MediaCommentsScreen";
  final Media item;
  final int commentCount;

  MediaCommentsScreen({Key key, this.item, this.commentCount})
      : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<MediaCommentsScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.item.toString());
    final appState = Provider.of<AppStateNotifier>(context);
    Userdata userdata = appState.userdata;

    return ChangeNotifierProvider(
        create: (context) => MediaCommentsModel(
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

  final MediaCommentsScreen widget;
  final Userdata userdata;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context,
            Provider.of<MediaCommentsModel>(context, listen: false)
                .totalPostComments);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(
                context,
                Provider.of<MediaCommentsModel>(context, listen: false)
                    .totalPostComments),
          ),
          title: Text(StringsUtils.comments),
        ),
        body: Column(
          children: <Widget>[
            CommentsMediaHeader(object: widget.item),
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
                : Consumer<MediaCommentsModel>(
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
    var commentsModel = Provider.of<MediaCommentsModel>(context);
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
                        Provider.of<MediaCommentsModel>(context, listen: false)
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
