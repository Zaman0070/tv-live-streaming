import 'package:flutter/material.dart';
import 'empty_widget.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateNotifier.dart';

/// General utility widget used to render a cell divided into three rows
/// First row displays [label]
/// second row displays [iconData]
/// third row displays [value]
class ValueTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData iconData;

  ValueTile(this.label, this.value, {this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          this.label,
        ),
        SizedBox(
          height: 5,
        ),
        this.iconData != null
            ? Consumer<AppStateNotifier>(
                builder: (context, appStateNotifier, child) {
                  return Icon(
                    iconData,
                    color: appStateNotifier.isDarkModeOn
                        ? Colors.white
                        : Colors.black45,
                    size: 20,
                  );
                },
              )
            : EmptyWidget(),
        SizedBox(
          height: 10,
        ),
        Text(
          this.value,
        ),
      ],
    );
  }
}
