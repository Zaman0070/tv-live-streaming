import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/Utility.dart';
import '../models/Comments.dart';
import '../models/CommentsArguement.dart';
import '../providers/CommentsModel.dart';
import '../screens/RepliesScreen.dart';
import '../utils/TextStyles.dart';
import '../utils/TimUtil.dart';
import '../i18n/strings.g.dart';
import 'package:provider/provider.dart';

class CommentsItem extends StatefulWidget {
  final bool isUser;
  final Comments object;
  final int index;
  final BuildContext context;

  const CommentsItem(
      {Key key,
      @required this.isUser,
      @required this.index,
      @required this.object,
      @required this.context})
      : assert(index != null),
        assert(isUser != null),
        assert(object != null),
        assert(context != null),
        super(key: key);

  @override
  _CommentsItemState createState() => _CommentsItemState();
}

class _CommentsItemState extends State<CommentsItem> {
  int repliesCount;

  @override
  void initState() {
    repliesCount = widget.object.replies;
    super.initState();
  }

  reportPost(int id, int index, String reason) {
    Provider.of<CommentsModel>(widget.context, listen: false)
        .reportComment(id, index, reason);
  }

  replyCommentScreen() async {
    var count = await Navigator.pushNamed(
      context,
      RepliesScreen.routeName,
      arguments: CommentsArguement(
          item: widget.object, commentCount: widget.object.replies),
    );
    setState(() {
      repliesCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: IntrinsicHeight(
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey,
              child: Center(
                child: Text(
                  widget.object.name.substring(0, 1),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(width: 10),
            Flexible(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(widget.object.name,
                          style: TextStyles.caption(context)
                          //.copyWith(color: MyColors.grey_60),
                          ),
                      Spacer(),
                      Text(TimUtil.timeAgoSinceDate(widget.object.date),
                          style: TextStyles.caption(context)
                          //.copyWith(color: MyColors.grey_60),
                          ),
                    ],
                  ),
                  Container(height: 8),
                  Container(
                    width: double.infinity,
                    child: Text(
                        Utility.getBase64DecodedString(widget.object.content),
                        maxLines: 10,
                        textAlign: TextAlign.left,
                        style: TextStyles.subhead(context).copyWith(
                            //color: MyColors.grey_80,
                            fontWeight: FontWeight.w500)),
                  ),
                  Container(height: 8),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          replyCommentScreen();
                        },
                        child: Text(
                          t.reply,
                          style: TextStyles.caption(context).copyWith(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      Container(width: 10),
                      Visibility(
                        visible: repliesCount != 0,
                        child: InkWell(
                          onTap: () {
                            replyCommentScreen();
                          },
                          child: Text(
                            repliesCount.toString(),
                            style: TextStyles.caption(context).copyWith(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                      Container(width: 2),
                      Visibility(
                        visible: repliesCount != 0,
                        child: InkWell(
                          onTap: () {
                            replyCommentScreen();
                          },
                          child: Text(
                            t.replies,
                            style: TextStyles.caption(context).copyWith(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: <Widget>[
                          Visibility(
                            visible: widget.isUser ? false : true,
                            child: InkWell(
                              child: Icon(Icons.report,
                                  color: Colors.pink[300], size: 20.0),
                              onTap: () async {
                                await showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return ReportCommentDialog(
                                        id: widget.object.id,
                                        index: widget.index,
                                        function: reportPost,
                                      );
                                    });
                              },
                            ),
                          ),
                          Container(width: 10),
                          Visibility(
                            visible: widget.isUser ? true : false,
                            child: InkWell(
                              child: Icon(Icons.edit,
                                  color: Colors.lightBlue, size: 20.0),
                              onTap: () {
                                Provider.of<CommentsModel>(context,
                                        listen: false)
                                    .showEditCommentAlert(
                                        widget.object.id, widget.index);
                              },
                            ),
                          ),
                          Container(width: 10),
                          Visibility(
                            visible: widget.isUser ? true : false,
                            child: InkWell(
                              child: Icon(Icons.delete_forever,
                                  color: Colors.redAccent, size: 20.0),
                              onTap: () {
                                Provider.of<CommentsModel>(context,
                                        listen: false)
                                    .showDeleteCommentAlert(
                                        widget.object.id, widget.index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportCommentDialog extends StatefulWidget {
  final id, index;
  final Function function;
  ReportCommentDialog({Key key, this.id, this.index, this.function})
      : super(key: key);

  @override
  _ReportCommentDialogState createState() => _ReportCommentDialogState();
}

class _ReportCommentDialogState extends State<ReportCommentDialog> {
  List<String> reportOptions = t.reportCommentsList;
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        t.reportcomment,
        style: TextStyles.subhead(context),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      actions: <Widget>[
        TextButton(
          child: Text(t.cancel),
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            primary: Theme.of(context).accentColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(t.ok),
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            primary: Theme.of(context).accentColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            widget.function(widget.id, widget.index, reportOptions[_selected]);
          },
        ),
      ],
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: reportOptions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RadioListTile(
                          title: Text(reportOptions[index]),
                          value: index,
                          groupValue: _selected,
                          onChanged: (value) {
                            setState(() {
                              _selected = index;
                            });
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
