import 'dart:convert';
import 'package:weather_app/core/utils/strings.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';

abstract class WeatherRemoteDataSource {
  /// Calls the https://api.openweathermap.org/data/2.5/weather?appid=appId&q=cityName endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<CurrentWeatherModel> getCurrentWeather({required String cityName});

  /// Calls the https://api.openweathermap.org/data/2.5/forecast?q=cityName&appid=appId endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ForecastWeatherModel> getForecastWeather({required String cityName});
}


class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<CurrentWeatherModel> getCurrentWeather({required String cityName}) async {
    final response = await client.get(
      Strings.baseUrl+Strings.weather+"?appid="+Strings.appId+"&q="+cityName as Uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return CurrentWeatherModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ForecastWeatherModel> getForecastWeather({required String cityName}) async {
    final response = await client.get(
      Strings.baseUrl+Strings.forecast+"?appid="+Strings.appId+"&q="+cityName as Uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return ForecastWeatherModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }


}
