import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../i18n/strings.g.dart';
import '../utils/my_colors.dart';
import 'forecast_horizontal_widget.dart';
import 'current_conditions.dart';
import 'value_tile.dart';
import 'package:intl/intl.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;

  WeatherWidget({this.weather}) : assert(weather != null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              this.weather.cityName.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.w500, letterSpacing: 5, fontSize: 23),
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              this.weather.description.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w100,
                letterSpacing: 3,
                fontSize: 15,
              ),
            ),
            Container(
              height: 280,
              child: CurrentConditions(
                weather: weather,
              ),
            ),
            Padding(
              child: Divider(
                color: MyColors.grey_100_,
              ),
              padding: EdgeInsets.all(10),
            ),
            Container(
              height: 80,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: <Widget>[
                    ValueTile(t.windspeed, '${this.weather.windSpeed} m/s'),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Center(
                          child: Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey,
                      )),
                    ),
                    ValueTile(
                        t.sunrise,
                        DateFormat('h:m a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                this.weather.sunrise * 1000))),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Center(
                          child: Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey,
                      )),
                    ),
                    ValueTile(
                        t.sunset,
                        DateFormat('h:m a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                this.weather.sunset * 1000))),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Center(
                          child: Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey,
                      )),
                    ),
                    ValueTile(t.humidity, '${this.weather.humidity}%'),
                  ]),
            ),
            Padding(
              child: Divider(
                color: MyColors.grey_100_,
              ),
              padding: EdgeInsets.all(5),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                t.oneweekforecast,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            ForecastHorizontal(weathers: weather.forecast),
          ],
        ),
      ),
    );
  }
}
