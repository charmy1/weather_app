# Flutter Weather App
Built with clean architecture and domain driven design with clear separation of Presentation, Domain and Data layers.

## Features

- Current Weather information for below cities in ListView

  🔆 Silverstone, UK

  🔆  São Paulo, Brazil

  🔆 Melbourne, Australia

  🔆 Monte Carlo, Monaco.

- 5-day weather forecast available for each city.

- Offline Caching 

## Installation

Run the below script  to set up the project on your local machine:
```sh
sh script/code_generator.sh
```
## State Management - flutter_bloc
## Dependency Injection - injectable
## Testing - mockito
## Offline Caching -hive

API documentation:
- https://openweathermap.org/current
- https://openweathermap.org/forecast

-Retrieves current and forecast data for 4 cities when device is online
![](online.gif)

-Retrieves current and forecast data if available on cache when device is offline
![](airplane.gif)




