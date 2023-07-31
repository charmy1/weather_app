import 'package:flutter/material.dart';
import 'package:weather_app/features/weather_retrieval/presentation/screens/current_weather_listing_screen.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the desired page after the delay
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CurrentWeatherListingScreen(),
        ),
      );
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
