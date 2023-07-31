
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather_retrieval/data/models/forecast_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/injection.dart';

class ForeCastWeatherListing extends StatefulWidget {
  final String cityName;

  const ForeCastWeatherListing({Key? key, required this.cityName})
      : super(key: key);

  @override
  State<ForeCastWeatherListing> createState() => _ForeCastWeatherListingState();
}

class _ForeCastWeatherListingState extends State<ForeCastWeatherListing> {
  ForecastWeatherModel responseModel = ForecastWeatherModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WeatherBloc, WeatherState>(
        bloc: getIt<WeatherBloc>()
          ..add(FetchForeCastWeather(cityName: widget.cityName)),
        //listenWhen: (previous, current) =>
        //  previous.forecastWeatherModel != current.forecastWeatherModel,
        listener: (context, state) {
          state.forecastWeatherModel?.fold(() => null, (a) {
            a.fold((l) {
              responseModel = ForecastWeatherModel();
              final snackBar = SnackBar(content: Text(l.toString()));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }, (r) {
              responseModel = r;
            });
          });
        },
        builder: (context, state) {
          return (state.isForecastLoading ||
              (state.forecastWeatherModel?.isNone() ?? false))
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : (responseModel.city != null)
              ? ListView.builder(
            itemCount: responseModel.list?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(responseModel.list?[index].dtTxt ?? ""),
                subtitle: Text("${widget.cityName}  ${(responseModel.list?[index].main?.temp).toString() ?? ""}"),
              );
            },
          )
              : const Center(
            child: Text("Something went wrong"),
          );
        },
      ),
    );
  }
}
