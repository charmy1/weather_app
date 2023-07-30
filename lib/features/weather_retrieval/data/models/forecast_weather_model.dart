import 'dart:core';
import 'package:equatable/equatable.dart';

import 'current_weather_model.dart';
import 'package:hive/hive.dart';
part 'forecast_weather_model.g.dart';



@HiveType(typeId: 7)
class ForecastWeatherModel extends Equatable{
  @HiveField(0)
  String? cod;

  @HiveField(1)
  int? message;

  @HiveField(2)
  int? cnt;

  @HiveField(3)
  List<WeatherList>? list;

  @HiveField(4)
  City? city;

  ForecastWeatherModel({
    this.cod,
    this.message,
    this.cnt,
    this.list,
    this.city,
  });

  factory ForecastWeatherModel.fromJson(Map<String, dynamic> json) {
    return ForecastWeatherModel(
      cod: json['cod'],
      message: json['message'],
      cnt: json['cnt'],
      list: json['list'] != null
          ? List<WeatherList>.from(
          json['list'].map((x) => WeatherList.fromJson(x)))
          : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cod'] = cod;
    data['message'] = message;
    data['cnt'] = cnt;
    if (list != null) {
      data['list'] = list!.map((x) => x.toJson()).toList();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    return data;
  }

  @override
  List<Object?> get props => [cod,message,cnt,list,city];
}

@HiveType(typeId: 8)
class WeatherList extends Equatable{
  @HiveField(0)
  int? dt;

  @HiveField(1)
  Main? main;

  @HiveField(2)
  List<Weather>? weather;

  @HiveField(3)
  Clouds? clouds;

  @HiveField(4)
  Wind? wind;

  @HiveField(5)
  int? visibility;

  @HiveField(6)
  num? pop;

  @HiveField(7)
  Rain? rain;

  @HiveField(8)
  Sys? sys;

  @HiveField(9)
  String? dtTxt;

  WeatherList({
    this.dt,
    this.main,
    this.weather,
    this.clouds,
    this.wind,
    this.visibility,
    this.pop,
    this.rain,
    this.sys,
    this.dtTxt,
  });

  factory WeatherList.fromJson(Map<String, dynamic> json) {
    return WeatherList(
      dt: json['dt'],
      main: json['main'] != null ? Main.fromJson(json['main']) : null,
      weather: json['weather'] != null
          ? List<Weather>.from(json['weather'].map((x) => Weather.fromJson(x)))
          : null,
      clouds:
      json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null,
      wind: json['wind'] != null ? Wind.fromJson(json['wind']) : null,
      visibility: json['visibility'],
      pop: json['pop'],
      rain: json['rain'] != null ? Rain.fromJson(json['rain']) : null,
      sys: json['sys'] != null ? Sys.fromJson(json['sys']) : null,
      dtTxt: json['dt_txt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dt'] = dt;
    if (main != null) {
      data['main'] = main!.toJson();
    }
    if (weather != null) {
      data['weather'] = weather!.map((x) => x.toJson()).toList();
    }
    if (clouds != null) {
      data['clouds'] = clouds!.toJson();
    }
    if (wind != null) {
      data['wind'] = wind!.toJson();
    }
    data['visibility'] = visibility;
    data['pop'] = pop;
    if (rain != null) {
      data['rain'] = rain!.toJson();
    }
    if (sys != null) {
      data['sys'] = sys!.toJson();
    }
    data['dt_txt'] = dtTxt;
    return data;
  }

  @override
  List<Object?> get props => [dt,main,weather,clouds,wind,visibility,pop,rain,dtTxt];
}

@HiveType(typeId: 9)
class Rain extends Equatable{
  @HiveField(0)
  num? d3h;

  Rain({this.d3h});

  factory Rain.fromJson(Map<String, dynamic> json) {
    return Rain(d3h: json['3h']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['3h'] = d3h;
    return data;
  }

  @override
  List<Object?> get props => [d3h];
}

@HiveType(typeId: 10)
class Sys extends Equatable{
  @HiveField(0)
  String? pod;

  Sys({this.pod});

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(pod: json['pod']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['pod'] = pod;
    return data;
  }

  @override
  List<Object?> get props => [pod];
}

@HiveType(typeId: 11)
class City extends Equatable{
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  Coord? coord;

  @HiveField(3)
  String? country;

  @HiveField(4)
  int? population;

  @HiveField(5)
  int? timezone;

  @HiveField(6)
  int? sunrise;

  @HiveField(7)
  int? sunset;

  City({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.population,
    this.timezone,
    this.sunrise,
    this.sunset,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      coord: json['coord'] != null ? Coord.fromJson(json['coord']) : null,
      country: json['country'],
      population: json['population'],
      timezone: json['timezone'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    if (coord != null) {
      data['coord'] = coord!.toJson();
    }
    data['country'] = country;
    data['population'] = population;
    data['timezone'] = timezone;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    return data;
  }

  @override
  List<Object?> get props => [id,name,coord,country,population,timezone,sunrise,sunset];
}

@HiveType(typeId: 12)
class Coord extends Equatable {
  @HiveField(0)
  num? lat;

  @HiveField(1)
  num? lon;

  Coord({this.lat, this.lon});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(lat: json['lat'], lon: json['lon']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }

  @override
  List<Object?> get props => [lat,lon];
}
