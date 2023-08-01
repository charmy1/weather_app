import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:weather_app/core/utils/strings.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/domain/repositories/weather_repository.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/current_weather_model.dart';

part 'weather_event.dart';
part 'weather_state.dart';
@lazySingleton
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc({required this.weatherRepository}) : super(  WeatherState()) {
    on<FetchCurrentWeather>(_onFetchCurrentWeather);
    on<FetchForeCastWeather>(_onFetchForeCastWeather);
    on<FetchCurrentWeatherForAllCities>(_onFetchCurrentWeatherForAllCities);
  }
  FutureOr<void> _onFetchCurrentWeather(
      FetchCurrentWeather event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isSearchLoading: true));
    var result=await weatherRepository.getWeather(cityName: event.cityName);
    emit(state.copyWith(isSearchLoading: false,searchCurrentWeatherModel:optionOf(result) ));
        }
  FutureOr<void> _onFetchForeCastWeather(
      FetchForeCastWeather event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isForecastLoading: true));
    var result=await weatherRepository.getForecast(cityName: event.cityName);
    emit(state.copyWith(isForecastLoading: false,forecastWeatherModel:optionOf(result) ));

  }
  FutureOr<void> _onFetchCurrentWeatherForAllCities(
      FetchCurrentWeatherForAllCities event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isCurrentLoading: true));
    var result=await weatherRepository.getWeatherForCityList(cityList: Strings.cityList);
    emit(state.copyWith(isCurrentLoading: false,listCurrentWeatherModel:optionOf(result) ));


  }

}

