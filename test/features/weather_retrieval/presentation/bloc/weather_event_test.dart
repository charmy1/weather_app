import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/features/weather_retrieval/presentation/bloc/weather_bloc.dart';

void main() {
  group('WeatherEvent', () {
    test('FetchCurrentWeather should properly override props', () {
      final event1 = FetchCurrentWeather(cityName: 'New York');
      final event2 = FetchCurrentWeather(cityName: 'New York');

      // Expect the events with the same properties to be equal
      expect(event1, event2);
    });

    test('FetchCurrentWeather should be equatable', () {
      final event = FetchCurrentWeather(cityName: 'New York');
      expect(event.props, ['New York']);

    });

    test(' FetchForeCastWeather should be different for different city names', () {
      final event1 = FetchForeCastWeather(cityName: 'London');
      final event2 = FetchForeCastWeather(cityName: 'New York');

      // Expect the events with different properties to be different
      expect(event1, isNot(event2));
    });


    test('FetchForeCastWeather should properly override props', () {
      final event1 = FetchForeCastWeather(cityName: 'London');
      final event2 = FetchForeCastWeather(cityName: 'London');

      // Expect the events with the same properties to be equal
      expect(event1, event2);
    });

    test('FetchCurrentWeatherForAllCities should properly override props', () {
      final event1 = FetchCurrentWeatherForAllCities();
      final event2 = FetchCurrentWeatherForAllCities();

      // Expect the events with the same properties to be equal
      expect(event1, event2);
    });

  });
}
