import 'package:flutter/material.dart';
import '../utils/converters.dart';
import '../models/weather.dart';
import '../widgets/value_tile.dart';
import 'package:intl/intl.dart';

/// Renders a horizontal scrolling list of weather conditions
/// Used to show forecast
/// Shows DateTime, Weather Condition icon and Temperature
class ForecastHorizontal extends StatelessWidget {
  const ForecastHorizontal({
    Key key,
    @required this.weathers,
  }) : super(key: key);

  final List<Weather> weathers;
  final TemperatureUnit temperatureUnit = TemperatureUnit.celsius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: this.weathers.length,
        separatorBuilder: (context, index) => Divider(
              height: 100,
              color: Colors.white,
            ),
        padding: EdgeInsets.only(left: 10, right: 10),
        itemBuilder: (context, index) {
          final item = this.weathers[index];
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Center(
                child: ValueTile(
              DateFormat('E, ha').format(
                  DateTime.fromMillisecondsSinceEpoch(item.time * 1000)),
              '${item.temperature.as(temperatureUnit).round()}°',
              iconData: item.getIconData(),
            )),
          );
        },
      ),
    );
  }
}
