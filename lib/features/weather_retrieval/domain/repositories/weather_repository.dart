import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';

abstract class WeatherRepository {
  ///Get current Weather
  Future<Either<Failure, CurrentWeatherModel>> getWeather({required String cityName});
  ///Get Forecast Weather
  Future<Either<Failure, ForecastWeatherModel>> getForecast({required String cityName});
  ///Get Current Weather for [Strings.cityList]
  Future<Either<Failure, List<CurrentWeatherModel>>> getWeatherForCityList({required List<String> cityList});
}