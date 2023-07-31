import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather_retrieval/data/models/current_weather_model.dart';
import 'package:weather_app/features/weather_retrieval/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/injection.dart';

import 'forecast_weather_listing_screen.dart';

class CurrentWeatherListingScreen extends StatelessWidget {
  const CurrentWeatherListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<WeatherBloc>(
          create: (context) =>
          getIt<WeatherBloc>()..add(FetchCurrentWeatherForAllCities()),
          child: const CurrentWeatherListingWidget()),
    );
  }
}

class CurrentWeatherListingWidget extends StatefulWidget {
  const CurrentWeatherListingWidget({Key? key}) : super(key: key);

  @override
  State<CurrentWeatherListingWidget> createState() =>
      _CurrentWeatherListingWidgetState();
}

class _CurrentWeatherListingWidgetState
    extends State<CurrentWeatherListingWidget> {
  List<CurrentWeatherModel> responseModel = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      //listenWhen: (previous, current) =>
      //  previous.listCurrentWeatherModel != current.listCurrentWeatherModel,
      listener: (context, state) {
        state.listCurrentWeatherModel?.fold(() => null, (a) {
          a.fold((l) {
            responseModel=[];
            final snackBar = SnackBar(content: Text(l.toString()));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }, (r) {
            responseModel = r;
          });
        });
      },
      builder: (context, state) {
        return (state.isCurrentLoading ||
            (state.listCurrentWeatherModel?.isNone() ?? false))
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : (responseModel.isNotEmpty)
            ? ListView.builder(
          itemCount: responseModel.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ForeCastWeatherListing(
                        cityName: responseModel[index].name ?? ""),
                  ),
                );
              },
              title: Text(responseModel[index].name ?? ""),
              subtitle: Text(
                  responseModel[index].weather?.first.description ??
                      "${responseModel[index].main?.temp??0}"),
            );
          },
        )
            : const Center(
          child: Text("Something went wrong"),
        );
      },
    );
  }
}
