// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:hive/hive.dart' as _i9;
import 'package:hive_flutter/hive_flutter.dart' as _i4;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i5;

import 'core/injectable_module.dart' as _i10;
import 'features/weather_retrieval/data/datasources/weather_local_data_source.dart'
    as _i8;
import 'features/weather_retrieval/data/models/current_weather_model.dart'
    as _i6;
import 'features/weather_retrieval/data/models/forecast_weather_model.dart'
    as _i7;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectableModule = _$InjectableModule();
    gh.lazySingleton<_i3.Client>(() => injectableModule.httpClient);
    await gh.singletonAsync<_i4.HiveInterface>(
      () => injectableModule.hive,
      preResolve: true,
    );
    gh.lazySingleton<_i5.InternetConnectionChecker>(
        () => injectableModule.internetConnectionChecker);
    await gh.singletonAsync<_i4.Box<_i6.CurrentWeatherModel>>(
      () => injectableModule.currentWeatherBox(gh<_i4.HiveInterface>()),
      preResolve: true,
    );
    await gh.singletonAsync<_i4.Box<_i7.ForecastWeatherModel>>(
      () => injectableModule.currentWeatherForecastBox(gh<_i4.HiveInterface>()),
      preResolve: true,
    );
    gh.lazySingleton<_i8.WeatherLocalDataSource>(
        () => _i8.WeatherLocalDataSourceImpl(
              currentWeatherBox: gh<_i9.Box<_i6.CurrentWeatherModel>>(),
              forecastWeatherBox: gh<_i9.Box<_i7.ForecastWeatherModel>>(),
            ));
    return this;
  }
}

class _$InjectableModule extends _i10.InjectableModule {}
