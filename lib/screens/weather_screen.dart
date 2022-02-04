import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.g.dart';
import '../providers/WeatherModel.dart';
import '../widgets/weather_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import '../utils/TextStyles.dart';

class WeatherScreen extends StatelessWidget {
  static const routeName = "/weather";
  WeatherScreen();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherModel(),
      child: WeatherScreenBody(),
    );
  }
}

class WeatherScreenBody extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreenBody>
    with TickerProviderStateMixin {
  WeatherModel _weatherModel;

  @override
  void initState() {
    _fetchWeatherWithLocation().catchError((error) {
      _fetchWeatherWithCity();
    });
    super.initState();
  }

  @override
  void dispose() {
    _weatherModel.setUnMounted();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _weatherModel = Provider.of<WeatherModel>(context);
    _weatherModel.setMounted();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                //DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
                t.weatherforecast,
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.location_searching,
                ),
                onPressed: () {
                  _fetchWeatherWithLocation();
                }),
            IconButton(
                icon: Icon(
                  Icons.location_city,
                ),
                onPressed: () {
                  _showCityChangeDialog();
                })
          ],
        ),
        backgroundColor: Colors.white,
        body: Material(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Container(
              child: Consumer<WeatherModel>(
                builder: (context, weatherModel, child) {
                  if (weatherModel.isLoading) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else if (weatherModel.isLoaded) {
                    return WeatherWidget(
                      weather: weatherModel.weather,
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 24,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          t.fetchweatherforecasterror,
                        ),
                        TextButton(
                          child: Text(
                            t.retryfetch,
                          ),
                          onPressed: _fetchWeatherWithCity,
                        )
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }

  void _showCityChangeDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              t.changecity,
              style:
                  Theme.of(context).textTheme.headline4.copyWith(fontSize: 17),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  t.ok,
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  _fetchWeatherWithCity();
                  Navigator.of(context).pop();
                },
              ),
            ],
            content: TextField(
              autofocus: true,
              onChanged: (text) {
                _weatherModel.cityName = text;
              },
              // cursorColor: Colors.black,
            ),
          );
        });
  }

  _fetchWeatherWithCity() {
    _weatherModel.fetchWeatherByCity();
  }

  _fetchWeatherWithLocation() async {
    Map<Permission, PermissionStatus> permissionResult =
        await [Permission.locationWhenInUse].request();
    print(permissionResult.toString());
    switch (permissionResult[Permission.locationWhenInUse]) {
      case PermissionStatus.denied:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        print('location permission denied');
        _showLocationDeniedDialog();
        throw Error();
        break;
      case PermissionStatus.granted:
        var status = await Permission.locationWhenInUse.serviceStatus;
        if (status.isEnabled) {
          Position position = await Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
          _weatherModel.fetchWeatherByLocation(
              position.longitude, position.latitude);
        } else if (status.isDisabled) {
          _showLocationDisabledDialog();
        }
        break;
    }
  }

  void _showLocationDeniedDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              t.locationdenied,
              style: TextStyles.caption(context),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  t.enable,
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showLocationDisabledDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              t.locationdisabled,
              style: TextStyles.caption(context).copyWith(fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  t.enable,
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
                onPressed: () {
                  AppSettings.openLocationSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
