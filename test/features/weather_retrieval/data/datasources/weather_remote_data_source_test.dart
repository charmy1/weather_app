import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/exceptions.dart';
import 'package:weather_app/core/utils/strings.dart';
import 'package:weather_app/features/weather_retrieval/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';

import '../../../../jsonParser/json_reader.dart';
import 'weather_remote_data_source_test.mocks.dart';
@GenerateMocks([http.Client],)
void main(){
late MockClient mockClient;
late WeatherRemoteDataSource weatherRemoteDataSource;
setUp(() {
  mockClient=MockClient();
  weatherRemoteDataSource=WeatherRemoteDataSourceImpl(client: mockClient);
});
void setUpCurrentWeatherSuccess200() {
  when(mockClient.get(any, headers: anyNamed('headers')))
      .thenAnswer((_) async => http.Response(jsonParser('current.json'), 200));
}
void setUpForeCastWeatherSuccess200() {
  when(mockClient.get(any, headers: anyNamed('headers')))
      .thenAnswer((_) async => http.Response(jsonParser('forecast.json'), 200));
}

void setUpMockHttpClientFailure404() {
  when(mockClient.get(any, headers: anyNamed('headers')))
      .thenAnswer((_) async => http.Response('Something went wrong', 404));
}
group('Current Weather,search by city name', () {
  final city = "Ahmedabad";
  final currentWeather =
  CurrentWeatherModel.fromJson(json.decode(jsonParser('current.json')));

  test(
    '''should perform a GET request for currentWeather''',
        () async {
      // arrange
          setUpCurrentWeatherSuccess200();
      // act
          weatherRemoteDataSource.getCurrentWeather(cityName: city);
      // assert
      verify(mockClient.get(
        Uri.parse("${Strings.baseUrl}${Strings.weather}?appid=${Strings.appId}&q=$city"),
        headers: {
          'Content-Type': 'application/json',
        },
      ));
    },
  );

  test(
    'should return CurrentWeatherModel when the response code is 200 (success)',
        () async {
      // arrange
          setUpCurrentWeatherSuccess200();
      // act
          var result =await weatherRemoteDataSource.getCurrentWeatherSearchByCityName(cityName: city);
      // assert
      expect(result, equals(currentWeather));
    },
  );

  test(
    'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = weatherRemoteDataSource.getCurrentWeatherSearchByCityName;
      // assert
      expect(() => call(cityName: city), throwsA(TypeMatcher<ServerException>()));
    },
  );
});
group('Forecast Weather', () {
  final city = "Ahmedabad";
  final forecastWeather =
  ForecastWeatherModel.fromJson(json.decode(jsonParser('forecast.json')));

  test(
    '''should perform a GET request for forecast weather''',
        () async {
      // arrange
      setUpForeCastWeatherSuccess200();
      // act
      weatherRemoteDataSource.getForecastWeather(cityName: city);
      // assert
      verify(mockClient.get(
        Uri.parse("${Strings.baseUrl}${Strings.forecast}?appid=${Strings.appId}&q=$city"),
        headers: {
          'Content-Type': 'application/json',
        },
      ));
    },
  );

  test(
    'should return ForecastWeatherModel when the response code is 200 (success)',
        () async {
      // arrange
          setUpForeCastWeatherSuccess200();
      // act
      var result =await weatherRemoteDataSource.getForecastWeather(cityName: city);
      // assert
      expect(result, equals(forecastWeather));
    },
  );

  test(
    'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = weatherRemoteDataSource.getForecastWeather;
      // assert
      expect(() => call(cityName: city), throwsA(TypeMatcher<ServerException>()));
    },
  );
});
}