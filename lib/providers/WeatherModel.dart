import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../api/ApiKey.dart';
import 'package:http/http.dart' as http;
import '../api/weather_api_client.dart';
import '../models/weather.dart';
import '../i18n/strings.g.dart';

class WeatherModel with ChangeNotifier {
  Weather weather;
  bool isLoading = true;
  bool isEmpty = true;
  bool isLoaded = false;
  bool isError = false;
  String cityName = t.weatherdeafaultcity;
  WeatherApiClient weatherApiClient;
  bool isMounted = false;

  WeatherModel() {
    weatherApiClient = WeatherApiClient(
        httpClient: http.Client(), apiKey: ApiKey.OPEN_WEATHER_MAP);
  }

  fetchWeatherByLocation(double longitude, double latitude) async {
    isLoading = true;
    if (isMounted) notifyListeners();
    try {
      weather =
          await getWeather(null, latitude: latitude, longitude: longitude);
      isLoading = false;
      isLoaded = true;
      if (isMounted) notifyListeners();
    } catch (exception) {
      print(exception);
      isError = true;
      isLoading = false;
      if (isMounted) notifyListeners();
    }
  }

  fetchWeatherByCity() async {
    isLoading = true;
    if (isMounted) notifyListeners();
    try {
      weather = await getWeather(this.cityName);
      isLoading = false;
      isLoaded = true;
      if (isMounted) notifyListeners();
    } catch (exception) {
      print(exception);
      isError = true;
      isLoading = false;
      if (isMounted) notifyListeners();
    }
  }

  Future<Weather> getWeather(String cityName,
      {double latitude, double longitude}) async {
    if (cityName == null) {
      this.cityName = await weatherApiClient.getCityNameFromLocation(
          latitude: latitude, longitude: longitude);
    }
    var weather = await weatherApiClient.getWeatherData(this.cityName);
    //print("weather="+weather.toString()) ;
    var weathers = await weatherApiClient.getForecast(this.cityName);
    //print("weathers="+weathers.toString()) ;
    weather.forecast = weathers;
    return weather;
  }

  setUnMounted() {
    isMounted = false;
  }

  setMounted() {
    isMounted = true;
  }
}
