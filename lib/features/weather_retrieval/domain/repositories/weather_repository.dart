import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';

abstract class WeatherRepository {
  Future<Either<Failure, CurrentWeatherModel>> getWeather({required String cityName});
  Future<Either<Failure, ForecastWeatherModel>> getForecast({required String cityName});
}