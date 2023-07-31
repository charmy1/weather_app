part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
}

class FetchCurrentWeather extends WeatherEvent {
  final String cityName;
  FetchCurrentWeather({required this.cityName});
  @override
  List<Object?> get props => [cityName];
}

class FetchForeCastWeather extends WeatherEvent {
  final String cityName;
  FetchForeCastWeather({required this.cityName});
  @override
  List<Object?> get props => [cityName];
}

class FetchCurrentWeatherForAllCities extends WeatherEvent {
  FetchCurrentWeatherForAllCities();
  @override
  List<Object?> get props => [];
}

