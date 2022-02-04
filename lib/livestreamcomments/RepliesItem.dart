import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsextra/i18n/strings.g.dart';
import 'package:newsextra/livestreamcomments/LivestreamsRepliesModel.dart';
import 'package:newsextra/utils/StringsUtils.dart';
import '../utils/Utility.dart';
import '../models/Replies.dart';
import '../utils/TextStyles.dart';
import '../utils/TimUtil.dart';
import 'package:provider/provider.dart';

class RepliesItem extends StatelessWidget {
  final bool isUser;
  final Replies object;
  final int index;
  final BuildContext context;

  const RepliesItem(
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

  reportPost(int id, int index, String reason) {
    Provider.of<LivestreamsRepliesModel>(context, listen: false)
        .reportComment(id, index, reason);
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
                  object.name.substring(0, 1),
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
                      Text(object.name, style: TextStyles.caption(context)
                          //.copyWith(color: MyColors.grey_60),
                          ),
                      Spacer(),
                      Text(TimUtil.timeAgoSinceDate(object.date),
                          style: TextStyles.caption(context)
                          //.copyWith(color: MyColors.grey_60),
                          ),
                    ],
                  ),
                  Container(height: 8),
                  Container(
                    width: double.infinity,
                    child: Text(Utility.getBase64DecodedString(object.content),
                        maxLines: 10,
                        textAlign: TextAlign.left,
                        style: TextStyles.subhead(context).copyWith(
                            //color: MyColors.grey_80,
                            fontWeight: FontWeight.w500)),
                  ),
                  Container(height: 8),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      Row(
                        children: <Widget>[
                          Visibility(
                            visible: isUser ? false : true,
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
                                        id: object.id,
                                        index: index,
                                        function: reportPost,
                                      );
                                    });
                              },
                            ),
                          ),
                          Container(width: 10),
                          Visibility(
                            visible: isUser ? true : false,
                            child: InkWell(
                              child: Icon(Icons.edit,
                                  color: Colors.lightBlue, size: 20.0),
                              onTap: () {
                                Provider.of<LivestreamsRepliesModel>(context,
                                        listen: false)
                                    .showEditCommentAlert(object.id, index);
                              },
                            ),
                          ),
                          Container(width: 10),
                          Visibility(
                            visible: isUser ? true : false,
                            child: InkWell(
                              child: Icon(Icons.delete_forever,
                                  color: Colors.redAccent, size: 20.0),
                              onTap: () {
                                Provider.of<LivestreamsRepliesModel>(context,
                                        listen: false)
                                    .showDeleteCommentAlert(object.id, index);
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
  List<String> reportOptions = StringsUtils.reportCommentsList;
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        StringsUtils.report_comment,
        style: TextStyles.subhead(context),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      actions: <Widget>[
        FlatButton(
          child: Text(t.cancel),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(t.ok),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textColor: Theme.of(context).accentColor,
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
