import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/exceptions.dart';
import 'package:weather_app/features/weather_retrieval/data/datasources/weather_local_data_source.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/repositories/weather_repository_impl.dart';

import '../../../../jsonParser/json_reader.dart';
import 'weather_local_data_source_test.mocks.dart';


@GenerateMocks([Box<CurrentWeatherModel>],)
void main() {
  late MockBox<CurrentWeatherModel> mockBoxCurrentWeather;
  late MockBox<ForecastWeatherModel> mockBoxForecastWeather;
  late MockBox<String> mockBoxCurrentWeatherList;
  late WeatherLocalDataSource mockWeatherLocalDataSource;
  late CurrentWeatherModel currentWeatherModel;
  late ForecastWeatherModel forecastWeather;
  setUp(() {
    mockBoxCurrentWeather = MockBox<CurrentWeatherModel>();
    mockBoxForecastWeather = MockBox<ForecastWeatherModel>();
    mockBoxCurrentWeatherList = MockBox<String>();
    mockWeatherLocalDataSource = WeatherLocalDataSourceImpl(
        currentWeatherListBox: mockBoxCurrentWeatherList,
        currentWeatherBox: mockBoxCurrentWeather,
        forecastWeatherBox: mockBoxForecastWeather);
    currentWeatherModel =
        CurrentWeatherModel.fromJson(json.decode(jsonParser('current.json')));
    forecastWeather =
        ForecastWeatherModel.fromJson(json.decode(jsonParser('forecast.json')));
  });
  group("Current Weather", () {
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
    test(
        'should throw a CacheException when there is not a cached value', () async {
      // arrange
      when(mockBoxCurrentWeather.get(any))
          .thenReturn(null);
      // act
      final result = mockWeatherLocalDataSource.getCachedCurrentWeather;
      // assert
      expect(() => result(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
  group("Forecast Weather", () {
    test('should return ForecastWeatherModel when present in cache ', () async {
      // arrange
      when(mockBoxForecastWeather.get(any))
          .thenReturn(forecastWeather);
      // act
      final result = await mockWeatherLocalDataSource.getCachedForecastWeather(
          cityName: "Ahmedabad");
      // assert
      verify(mockBoxForecastWeather.get(any));
      expect(result, equals(forecastWeather));
    });
    test(
        'should throw a CacheException when there is not a cached value', () async {
      // arrange
      when(mockBoxForecastWeather.get(any))
          .thenReturn(null);
      // act
      final result = mockWeatherLocalDataSource.getCachedForecastWeather;
      // assert
      expect(() => result(cityName: "Ahmedabad"),
          throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group("List Current Weather", () {
    final currentWeather =
    CurrentWeatherModel.fromJson(json.decode(jsonParser('current.json')));
    test('should return List<CurrentWeather> when present in cache ', () async {
      // arrange
      when(mockBoxCurrentWeatherList.get(any))
          .thenReturn(
          json.encode([currentWeather].map((e) => e.toJson()).toList()));
      // act
      final result = await mockWeatherLocalDataSource
          .getCachedCurrentWeatherList();
      // assert
      verify(mockBoxCurrentWeatherList.get(any));
      expect(result, equals([currentWeather,]));
    });
    test(
        'should throw a CacheException when there is not a cached value', () async {
      // arrange
      when(mockBoxCurrentWeatherList.get(any))
          .thenReturn(null);
      // act
      final result = mockWeatherLocalDataSource.getCachedCurrentWeatherList;
      // assert
      expect(() => result(), throwsA(const TypeMatcher<CacheException>()));
    });

    test('throws CacheException when cache contains invalid JSON', () async {
      // Arrange
      when(mockBoxCurrentWeatherList.get(any))
          .thenReturn("invalid_json_string");
      // act
      final result = await mockWeatherLocalDataSource
          .getCachedCurrentWeatherList;
     //assert
      expect(() => result(), throwsA(const TypeMatcher<CacheException>()));
      });


  });


  group('Write to cache', () {
    test(
      'should call Hive CurrentWeather Box to cache the data',
          () async {
        // act
        mockWeatherLocalDataSource.cacheCurrentWeather(currentWeatherModel);
        // assert
        verify(mockBoxCurrentWeather.put(0, currentWeatherModel));
      },
    );
    test(
      'should call Hive CurrentWeather Box to cache the data',
          () async {
        // act
        mockWeatherLocalDataSource.cacheCurrentWeather(currentWeatherModel);
        // assert
        verify(mockBoxCurrentWeather.put(0, currentWeatherModel));
      },
    );
    test(
      'should call Hive CurrentWeatherList Box to cache the data',
          () async {
        // act
        mockWeatherLocalDataSource.cacheCurrentWeatherForCityList(
            [currentWeatherModel]);
        // assert
        verify(mockBoxCurrentWeatherList.put("list", json.encode(
            [currentWeatherModel].map((e) => e.toJson()).toList())));
      },
    );

    test(
      'should call Hive ForeCastWeather Box to cache the data',
          () async {
        // act
        mockWeatherLocalDataSource.cacheForeCastWeather(forecastWeather);
        // assert
        verify(mockBoxForecastWeather.put(
            forecastWeather.city?.name, forecastWeather));
      },
    );
  });
}