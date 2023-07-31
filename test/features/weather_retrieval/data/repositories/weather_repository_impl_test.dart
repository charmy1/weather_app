import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/core/error/exceptions.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/network/network_info.dart';
import 'package:weather_app/core/utils/strings.dart';
import 'package:weather_app/features/weather_retrieval/data/datasources/weather_local_data_source.dart';
import 'package:weather_app/features/weather_retrieval/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/repositories/weather_repository_impl.dart';
import '../../../../jsonParser/json_reader.dart';
import 'weather_repository_impl_test.mocks.dart';
@GenerateMocks([WeatherRemoteDataSource,WeatherLocalDataSource,NetworkInfo],)
void main(){
  late MockNetworkInfo mockNetworkInfo;
  late MockWeatherLocalDataSource mockWeatherLocalDataSource;
  late MockWeatherRemoteDataSource mockWeatherRemoteDataSource;
  late WeatherRepositoryImpl repository;
  late CurrentWeatherModel currentWeather;
  late  ForecastWeatherModel forecastWeather;
  setUp(() {
     currentWeather =
    CurrentWeatherModel.fromJson(json.decode(jsonParser('current.json')));
     forecastWeather =
    ForecastWeatherModel.fromJson(json.decode(jsonParser('forecast.json')));
    mockNetworkInfo=MockNetworkInfo();
    mockWeatherLocalDataSource=MockWeatherLocalDataSource();
    mockWeatherRemoteDataSource=MockWeatherRemoteDataSource();
    repository=WeatherRepositoryImpl(remoteDataSource: mockWeatherRemoteDataSource, localDataSource: mockWeatherLocalDataSource, networkInfo: mockNetworkInfo);
  });
  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }


  group('getWeather', () {

    test(
      'should check if the device is online',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockWeatherRemoteDataSource.getCurrentWeather(cityName: "Ahmedabad"))
            .thenAnswer((_) async => currentWeather);

        // act
        repository.getWeather(cityName:"Ahmedabad");
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockWeatherRemoteDataSource.getCurrentWeather(cityName: "Ahmedabad"))
              .thenAnswer((_) async => currentWeather);
          // act
          final result = await repository.getWeather(cityName: "Ahmedabad");
          // assert
          verify(mockWeatherRemoteDataSource.getCurrentWeather(cityName: "Ahmedabad"));
          expect(result, equals(Right(currentWeather)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
            () async {
          // arrange
          when(mockWeatherRemoteDataSource.getCurrentWeather(cityName: "Ahmedabad"))
              .thenAnswer((_) async => currentWeather);
          // act
          await repository.getWeather(cityName: "Ahmedabad");
          // assert
          verify(mockWeatherRemoteDataSource.getCurrentWeather(cityName: "Ahmedabad"));
          verify(mockWeatherLocalDataSource.cacheCurrentWeather(currentWeather));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockWeatherRemoteDataSource.getCurrentWeather(cityName: "Ahmedabad"))
              .thenThrow(ServerException());
          // act
          final result = await repository.getWeather(cityName: "Ahmedabad");
          // assert
          verify(mockWeatherRemoteDataSource.getCurrentWeather(cityName:"Ahmedabad" ));
          verifyZeroInteractions(mockWeatherLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
            () async {
          // arrange
          when(mockWeatherLocalDataSource.getCachedCurrentWeather())
              .thenAnswer((_) async => currentWeather);
          // act
          final result = await repository.getWeather(cityName: "Ahmedabad");
          // assert
          verifyZeroInteractions(mockWeatherRemoteDataSource);
          verify(mockWeatherLocalDataSource.getCachedCurrentWeather());
          expect(result, equals(Right(currentWeather)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
            () async {
          // arrange
          when(mockWeatherLocalDataSource.getCachedCurrentWeather())
              .thenThrow(CacheException());
          // act
          final result = await repository.getWeather(cityName: "Ahmedabd");
          // assert
          verifyZeroInteractions(mockWeatherRemoteDataSource);
          verify(mockWeatherLocalDataSource.getCachedCurrentWeather());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });


  });

  group('getForecast', () {

    test(
      'should check if the device is online',
          () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockWeatherRemoteDataSource.getForecastWeather(cityName: "Ahmedabad"))
            .thenAnswer((_) async => forecastWeather);

        // act
        repository.getForecast(cityName:"Ahmedabad");
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockWeatherRemoteDataSource.getForecastWeather(cityName: "Ahmedabad"))
              .thenAnswer((_) async => forecastWeather);
          // act
          final result = await repository.getForecast(cityName: "Ahmedabad");
          // assert
          verify(mockWeatherRemoteDataSource.getForecastWeather(cityName: "Ahmedabad"));
          expect(result, equals(Right(forecastWeather)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
            () async {
          // arrange
          when(mockWeatherRemoteDataSource.getForecastWeather(cityName: "Ahmedabad"))
              .thenAnswer((_) async => forecastWeather);
          // act
          await repository.getForecast(cityName: "Ahmedabad");
          // assert
          verify(mockWeatherRemoteDataSource.getForecastWeather(cityName: "Ahmedabad"));
          verify(mockWeatherLocalDataSource.cacheForeCastWeather(forecastWeather));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockWeatherRemoteDataSource.getForecastWeather(cityName: "Ahmedabad"))
              .thenThrow(ServerException());
          // act
          final result = await repository.getForecast(cityName: "Ahmedabad");
          // assert
          verify(mockWeatherRemoteDataSource.getForecastWeather(cityName:"Ahmedabad" ));
          verifyZeroInteractions(mockWeatherLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
            () async {
          // arrange
          when(mockWeatherLocalDataSource.getCachedForecastWeather(cityName: "Ahmedabad"))
              .thenAnswer((_) async => forecastWeather);
          // act
          final result = await repository.getForecast(cityName: "Ahmedabad");
          // assert
          verifyZeroInteractions(mockWeatherRemoteDataSource);
          verify(mockWeatherLocalDataSource.getCachedForecastWeather(cityName: "Ahmedabad"));
          expect(result, equals(Right(forecastWeather)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
            () async {
          // arrange
          when(mockWeatherLocalDataSource.getCachedCurrentWeather())
              .thenThrow(CacheException());
          // act
          final result = await repository.getWeather(cityName: "Ahmedabd");
          // assert
          verifyZeroInteractions(mockWeatherRemoteDataSource);
          verify(mockWeatherLocalDataSource.getCachedCurrentWeather());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });


  });


  group('getWeatherForCityList', ()  {
    const cityList = Strings.cityList;

    test('should return a list of CurrentWeatherModel when online and remote data source is successful', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockWeatherRemoteDataSource.getCurrentWeather(cityName: anyNamed('cityName')))
          .thenAnswer((_) async => currentWeather);

      // Act
      final result = await repository.getWeatherForCityList(cityList: cityList);

      // Assert
      expect(result, isA<Right<Failure, List<CurrentWeatherModel>>>());
      expect(result.getOrElse(() => []), isA<List<CurrentWeatherModel>>());
      verify(mockNetworkInfo.isConnected);
      verify(mockWeatherRemoteDataSource.getCurrentWeather(cityName: anyNamed('cityName')))
          .called(cityList.length);
    });

    test('should return a list of CurrentWeatherModel when offline and local data is available', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockWeatherLocalDataSource.getCachedCurrentWeatherList())
          .thenAnswer((_) async => [CurrentWeatherModel(/* ... */)]);

      // Act
      final result = await repository.getWeatherForCityList(cityList: cityList);

      // Assert
      expect(result, isA<Right<Failure, List<CurrentWeatherModel>>>());
      expect(result.getOrElse(() => []), isA<List<CurrentWeatherModel>>());
      verify(mockNetworkInfo.isConnected);
      verify(mockWeatherLocalDataSource.getCachedCurrentWeatherList());
    });

    test('should return CacheFailure when offline and local data is not available', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockWeatherLocalDataSource.getCachedCurrentWeatherList())
          .thenThrow(CacheException());

      // Act
      final result = await repository.getWeatherForCityList(cityList: cityList);

      // Assert
      expect(result, Left(CacheFailure()));
      verify(mockNetworkInfo.isConnected);
      verify(mockWeatherLocalDataSource.getCachedCurrentWeatherList());
    });

    test('should return ServerFailure when online and remote data source throws an exception', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockWeatherRemoteDataSource.getCurrentWeather(cityName: anyNamed('cityName')))
          .thenAnswer((_) async => CurrentWeatherModel(name:anyNamed('cityName' )));

      // Act
      final result = await repository.getWeatherForCityList(cityList: cityList);

      // Assert
      expect(result, Left(ServerFailure()));
      verify(mockNetworkInfo.isConnected);
      verify(mockWeatherRemoteDataSource.getCurrentWeather(cityName: anyNamed('cityName')))
          .called(cityList.length);
    });
  });


}



