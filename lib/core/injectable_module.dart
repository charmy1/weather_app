import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';

import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart' as current;
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart'as forecast;


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



    Hive.registerAdapter(CloudsAdapter());
    Hive.registerAdapter(WeatherAdapter());
    Hive.registerAdapter(CityAdapter());
    Hive.registerAdapter(MainAdapter());
    Hive.registerAdapter(CoordAdapter());
    Hive.registerAdapter(WindAdapter());
    Hive.registerAdapter(RainAdapter());
    Hive.registerAdapter(current.SysAdapter());
    Hive.registerAdapter(forecast.SysAdapter());
    Hive.registerAdapter(WeatherListAdapter());
    Hive.registerAdapter(CurrentWeatherModelAdapter());
    Hive.registerAdapter(ForecastWeatherModelAdapter());

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


  @preResolve
  @singleton
  Future<Box<List<CurrentWeatherModel>>> currentWeatherListBox(HiveInterface hive) =>
      hive.openBox<List<CurrentWeatherModel>>("currentWeatherList");
}

