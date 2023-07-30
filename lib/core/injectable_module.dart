import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';



@module
abstract class InjectableModule {
  @lazySingleton
  http.Client get httpClient => http.Client();

  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker=>InternetConnectionChecker();


  @preResolve
  @singleton
  Future<HiveInterface> get hive async {
    await Hive.initFlutter();
    Hive.registerAdapter(CurrentWeatherModelAdapter());
    Hive.registerAdapter(ForecastWeatherModelAdapter());
    Hive.registerAdapter(WeatherListAdapter());
    Hive.registerAdapter(CloudsAdapter());
    Hive.registerAdapter(CityAdapter());
    return Hive;
  }


  @preResolve
  @singleton
  Future<Box<CurrentWeatherModel>> currentWeatherBox(HiveInterface hive) =>
      hive.openBox<CurrentWeatherModel>("currentWeatherModel");

  @preResolve
  @singleton
  Future<Box<ForecastWeatherModel>> currentWeatherForecastBox(HiveInterface hive) =>
      hive.openBox<ForecastWeatherModel>("currentWeatherForecastModel");
}

