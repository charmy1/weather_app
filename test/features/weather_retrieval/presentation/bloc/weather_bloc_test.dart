import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/core/utils/strings.dart';
import 'package:weather_app/features/weather_retrieval/data/datasources/weather_local_data_source.dart';
import 'package:weather_app/features/weather_retrieval/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/features/weather_retrieval/domain/repositories/weather_repository.dart';
import 'package:weather_app/features/weather_retrieval/presentation/bloc/weather_bloc.dart';
import '../../../../core/network/network_info_test.mocks.dart';
import '../../../../jsonParser/json_reader.dart';
import 'weather_bloc_test.mocks.dart';
@GenerateMocks([WeatherRepository,NetworkInfo])
void main() {
  late MockWeatherRepository weatherRepository;
  late WeatherBloc weatherBloc;
late MockNetworkInfo networkInfo;
  late CurrentWeatherModel currentWeather;
  late ForecastWeatherModel forecastWeather;

  setUp(() async {
    currentWeather =
        CurrentWeatherModel.fromJson(json.decode(jsonParser('current.json')));
    forecastWeather =
        ForecastWeatherModel.fromJson(json.decode(jsonParser('forecast.json')));
    networkInfo = MockNetworkInfo();
    when(networkInfo.isConnected).thenAnswer((_) async => true);
    weatherRepository = MockWeatherRepository();
    weatherBloc = WeatherBloc(weatherRepository: weatherRepository);

  });
  group('WeatherBloc', () {
    test('initial state should be correct', () {
      expect(weatherBloc.state, WeatherState());
    });

    blocTest<WeatherBloc, WeatherState>(
      'emits [isSearchLoading=true, isSearchLoading=false] when FetchCurrentWeather is added',
      build: () => weatherBloc,
      act: (bloc) async {
        // Mock the result of the weather repository call
        when(weatherRepository.getWeather(cityName: 'SomeCity'))
            .thenAnswer((_) async => Right(CurrentWeatherModel()));

        bloc.add(FetchCurrentWeather(cityName: 'SomeCity'));
      },
      expect: () => [
        WeatherState().copyWith(isSearchLoading: true),
        WeatherState().copyWith(
          isSearchLoading: false,
          searchCurrentWeatherModel: optionOf(Right(CurrentWeatherModel())),
        ),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [isForecastLoading=true, isForecastLoading=false] when FetchForeCastWeather is added',
      build: () => weatherBloc,
      act: (bloc) async {
        // Mock the result of the weather repository call
        when(weatherRepository.getForecast(cityName: 'SomeCity'))
            .thenAnswer((_) async => Right(ForecastWeatherModel()));

        bloc.add(FetchForeCastWeather(cityName: 'SomeCity'));
      },
      expect: () => [
        WeatherState().copyWith(isForecastLoading: true),
        WeatherState().copyWith(
          isForecastLoading: false,
          forecastWeatherModel: optionOf(Right(ForecastWeatherModel())),
        ),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [isCurrentLoading=true, isCurrentLoading=false] when FetchCurrentWeatherForAllCities is added',
      build: () => weatherBloc,
      act: (bloc) async {
        // Mock the result of the weather repository call
        when(weatherRepository.getWeatherForCityList(cityList: Strings.cityList))
            .thenAnswer((_) async => Right([currentWeather, currentWeather, currentWeather]));


        bloc.add(FetchCurrentWeatherForAllCities());
      },
      expect: () => [
        WeatherState().copyWith(isCurrentLoading: true),
        WeatherState().copyWith(
          isCurrentLoading: false,
          listCurrentWeatherModel: Some(Right([
            currentWeather,
            currentWeather,
            currentWeather,
          ])),
        ),
      ],
    );


   /* // Test FetchCurrentWeatherForAllCities event
    test('emits [isCurrentLoading=true, isCurrentLoading=false] when FetchCurrentWeatherForAllCities is added', () async*{
      final cityList = Strings.cityList;

      when(weatherRepository.getWeatherForCityList(cityList: cityList))
          .thenAnswer((_) async => Right([currentWeather, currentWeather, currentWeather]));

      expectLater(
        weatherBloc.stream,
        emitsInOrder([
          WeatherState().copyWith(isCurrentLoading: true),
          WeatherState().copyWith(
            isCurrentLoading: false,
            listCurrentWeatherModel: Some(Right([
              currentWeather,
              currentWeather,
              currentWeather,
            ])),
          ),
        ]),
      );

      weatherBloc.add(FetchCurrentWeatherForAllCities());
    });
*/  });

}