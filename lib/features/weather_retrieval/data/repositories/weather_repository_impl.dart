import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/features/weather_retrieval/data/datasources/weather_local_data_source.dart';
import 'package:weather_app/features/weather_retrieval/data/datasources/weather_remote_data_source.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/domain/repositories/weather_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, ForecastWeatherModel>> getForecast({required String cityName}) async {
    if (await networkInfo.isConnected) {
      try {
        final forecastWeather = await remoteDataSource.getForecastWeather(cityName: cityName);
        localDataSource.cacheForeCastWeather(forecastWeather);
        return Right(forecastWeather);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final forecastWeather = await localDataSource.getCachedForecastWeather();
        return Right(forecastWeather);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, CurrentWeatherModel>> getWeather({required String cityName}) async {
    if (await networkInfo.isConnected) {
      try {
        final currentWeather = await remoteDataSource.getCurrentWeather(cityName: cityName);
        localDataSource.cacheCurrentWeather(currentWeather);
        return Right(currentWeather);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final currentWeather = await localDataSource.getCachedCurrentWeather();
        return Right(currentWeather);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
  
}