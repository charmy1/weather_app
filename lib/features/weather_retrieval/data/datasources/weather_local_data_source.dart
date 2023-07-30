import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class WeatherLocalDataSource {
  /// Gets the cached [CurrentWeatherModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<CurrentWeatherModel> getCachedCurrentWeather();
  /// Gets the cached [ForecastWeatherModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<ForecastWeatherModel> getCachedForecastWeather();
  ///Cache current weather
  Future<void> cacheCurrentWeather(CurrentWeatherModel currentWeatherModel);
  ///Cache forecast weather
  Future<void> cacheForeCastWeather(ForecastWeatherModel forecastWeatherModel);
}

@LazySingleton(as: WeatherLocalDataSource)
class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Box<CurrentWeatherModel> currentWeatherBox;
  final Box<ForecastWeatherModel> forecastWeatherBox;

  WeatherLocalDataSourceImpl( {required this.currentWeatherBox,required this.forecastWeatherBox,});

  @override
  Future<CurrentWeatherModel> getCachedCurrentWeather() {
    CurrentWeatherModel? currentWeatherModel = currentWeatherBox.get(0);
    if (currentWeatherModel != null) {
      return Future.value(currentWeatherModel);
    } else {
      throw CacheException();
    }
  }


  @override
  Future<void> cacheCurrentWeather(CurrentWeatherModel currentWeatherModel) async {
    currentWeatherBox.put(0, currentWeatherModel);
  }

  @override
  Future<void> cacheForeCastWeather(ForecastWeatherModel forecastWeatherModel) async{
    forecastWeatherBox.put(0,forecastWeatherModel);
  }

  @override
  Future<ForecastWeatherModel> getCachedForecastWeather() {
    ForecastWeatherModel? forecastWeatherModel = forecastWeatherBox.get(0);
    if (forecastWeatherModel != null) {
      return Future.value(forecastWeatherModel);
    } else {
      throw CacheException();
    }
  }
}
