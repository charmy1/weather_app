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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WeatherState &&
              runtimeType == other.runtimeType &&
              isCurrentLoading == other.isCurrentLoading &&
              isForecastLoading == other.isForecastLoading &&
              isSearchLoading == other.isSearchLoading &&
              searchCurrentWeatherModel == other.searchCurrentWeatherModel &&
              listCurrentWeatherModel?.fold(() => null, (a) =>
                  a.fold((l) => l, (r) => r)) ==
                  other.listCurrentWeatherModel?.fold(() => null, (a) =>
                      a.fold((l) => l, (r) => r)) &&
              forecastWeatherModel == other.forecastWeatherModel;

  @override
  int get hashCode =>
      isCurrentLoading.hashCode ^
      isForecastLoading.hashCode ^
      isSearchLoading.hashCode ^
      searchCurrentWeatherModel.hashCode ^
      // Generate hashCode based on the contents of Option<Either> for listCurrentWeatherModel
      (listCurrentWeatherModel?.fold(() => null, (a) =>
          a.fold((l) => l.hashCode, (r) => r.hashCode)) ?? 0) ^
      forecastWeatherModel.hashCode;

}
