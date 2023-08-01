part of 'weather_bloc.dart';


class WeatherState extends Equatable {
  final bool isCurrentLoading;
  final bool isForecastLoading;
  final bool isSearchLoading;
  final Option<Either<Failure, CurrentWeatherModel>>? searchCurrentWeatherModel;
  final Option<Either<Failure, ForecastWeatherModel>>? forecastWeatherModel;
  final Option<
      Either<Failure, List<CurrentWeatherModel>>>? listCurrentWeatherModel;

  const WeatherState({
    this.isCurrentLoading = false,
    this.isForecastLoading = false,
    this.isSearchLoading = false,
    this.searchCurrentWeatherModel,
    this.forecastWeatherModel,
    this.listCurrentWeatherModel,
  });

  WeatherState copyWith({
    bool? isCurrentLoading,
    bool? isForecastLoading,
    bool? isSearchLoading,
    Option<Either<Failure, CurrentWeatherModel>>? searchCurrentWeatherModel,
    Option<Either<Failure, ForecastWeatherModel>>? forecastWeatherModel,
    Option<Either<Failure, List<CurrentWeatherModel>>>? listCurrentWeatherModel,
  }) {
    return WeatherState(
      isCurrentLoading: isCurrentLoading ?? this.isCurrentLoading,
      isForecastLoading: isForecastLoading ?? this.isForecastLoading,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      searchCurrentWeatherModel: searchCurrentWeatherModel ??
          this.searchCurrentWeatherModel,
      listCurrentWeatherModel: listCurrentWeatherModel ??
          this.listCurrentWeatherModel,
      forecastWeatherModel: forecastWeatherModel ?? this.forecastWeatherModel,
    );
  }

  @override
  List<Object?> get props =>
      [
        isCurrentLoading,
        isForecastLoading,
        isSearchLoading,
        searchCurrentWeatherModel,
        listCurrentWeatherModel?.fold(() => null, (a) =>
            a.fold((l) => l, (r) => r)),
        forecastWeatherModel,
      ];


}
