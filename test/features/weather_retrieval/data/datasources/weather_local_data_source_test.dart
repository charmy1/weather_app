import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/exceptions.dart';
import 'package:weather_app/features/weather_retrieval/data/datasources/weather_local_data_source.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';

import '../../../../jsonParser/json_reader.dart';
import 'weather_local_data_source_test.mocks.dart';


@GenerateMocks([Box<CurrentWeatherModel>],)
void main() {
  late MockBox<CurrentWeatherModel> mockBoxCurrentWeather ;
  late MockBox<ForecastWeatherModel> mockBoxForecastWeather;
  late MockBox<List<CurrentWeatherModel>> mockBoxCurrentWeatherList ;
  late WeatherLocalDataSource mockWeatherLocalDataSource;
  setUp(() {
    mockBoxCurrentWeather = MockBox<CurrentWeatherModel>();
    mockBoxForecastWeather = MockBox<ForecastWeatherModel>();
    mockBoxCurrentWeatherList=MockBox<List<CurrentWeatherModel>>();
    mockWeatherLocalDataSource = WeatherLocalDataSourceImpl(
      currentWeatherListBox: mockBoxCurrentWeatherList,
        currentWeatherBox: mockBoxCurrentWeather,
        forecastWeatherBox: mockBoxForecastWeather);
  });
  group("Current Weather", () {
    final currentWeatherModel =
    CurrentWeatherModel.fromJson(json.decode(jsonParser('current.json')));
    test('should return CurrentWeatherModel when present in cache ', () async {
      // arrange
      when(mockBoxCurrentWeather.get(any))
          .thenReturn(currentWeatherModel);
      // act
      final result = await mockWeatherLocalDataSource.getCachedCurrentWeather();
      // assert
      verify(mockBoxCurrentWeather.get(any));
      expect(result, equals(currentWeatherModel));
    });
    test('should throw a CacheException when there is not a cached value', () async {
      // arrange
      when(mockBoxCurrentWeather.get(any))
          .thenReturn(null);
      // act
      final result =  mockWeatherLocalDataSource.getCachedCurrentWeather;
      // assert
      expect(() => result(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
  group("Forecast Weather", () {
    final forecastWeather =
    ForecastWeatherModel.fromJson(json.decode(jsonParser('forecast.json')));
    test('should return ForecastWeatherModel when present in cache ', () async {
      // arrange
      when(mockBoxForecastWeather.get(any))
          .thenReturn(forecastWeather);
      // act
      final result = await mockWeatherLocalDataSource.getCachedForecastWeather();
      // assert
      verify(mockBoxForecastWeather.get(any));
      expect(result, equals(forecastWeather));
    });
    test('should throw a CacheException when there is not a cached value', () async {
      // arrange
      when(mockBoxForecastWeather.get(any))
          .thenReturn(null);
      // act
      final result =  mockWeatherLocalDataSource.getCachedForecastWeather;
      // assert
      expect(() => result(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group("List Current Weather", () {
    final currentWeather =
    CurrentWeatherModel.fromJson(json.decode(jsonParser('current.json')));
    test('should return List<CurrentWeather> when present in cache ', () async {
      // arrange
      when(mockBoxCurrentWeatherList.get(any))
          .thenReturn([currentWeather,currentWeather]);
      // act
      final result = await mockWeatherLocalDataSource.getCachedCurrentWeatherList();
      // assert
      verify(mockBoxCurrentWeatherList.get(any));
      expect(result, equals([currentWeather,currentWeather]));
    });
    test('should throw a CacheException when there is not a cached value', () async {
      // arrange
      when(mockBoxCurrentWeatherList.get(any))
          .thenReturn(null);
      // act
      final result =  mockWeatherLocalDataSource.getCachedCurrentWeatherList;
      // assert
      expect(() => result(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
}