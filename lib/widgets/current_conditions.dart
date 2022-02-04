import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AppStateNotifier.dart';
import '../utils/converters.dart';
import '../models/weather.dart';
import 'value_tile.dart';

/// Renders Weather Icon, current, min and max temperatures
class CurrentConditions extends StatelessWidget {
  final Weather weather;
  final TemperatureUnit temperatureUnit = TemperatureUnit.celsius;
  const CurrentConditions({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Consumer<AppStateNotifier>(
          builder: (context, appStateNotifier, child) {
            return Icon(
              weather.getIconData(),
              color:
                  appStateNotifier.isDarkModeOn ? Colors.white : Colors.black45,
              size: 50,
            );
          },
        ),
        SizedBox(
          height: 15,
        ),
        Text('${this.weather.temperature.as(temperatureUnit).round()}°',
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w100,
            )),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          ValueTile("max",
              '${this.weather.maxTemperature.as(temperatureUnit).round()}°'),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Center(
                child: Container(
              width: 1,
              height: 30,
              color: Colors.grey,
            )),
          ),
          ValueTile("min",
              '${this.weather.minTemperature.as(temperatureUnit).round()}°'),
        ]),
      ],
    );
  }
}
