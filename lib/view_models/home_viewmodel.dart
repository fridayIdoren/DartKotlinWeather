// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:weather_app/constants/weather_api.dart';
import 'package:weather_app/model/city.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/model/weather.dart';

final ciryStateProvider = StateNotifierProvider<CityStateNotifier, City?>((ref) {
  return CityStateNotifier(ref: ref);
});

final weatherStateProvider = StateNotifierProvider<WeatherStateNotifier, Weather?>((ref) {
  return WeatherStateNotifier();
});

final isLoadingProvider = StateProvider((ref) {
  return false;
});

const String BASE_URL = "http://api.openweathermap.org";

class CityStateNotifier extends StateNotifier<City?> {
  final Ref ref;

  late TextEditingController cityController;

  WeatherStateNotifier get weatherNotifier => ref.read(weatherStateProvider.notifier);

  CityStateNotifier({required this.ref}) : super(null) {
    cityController = TextEditingController();
  }

  Future<void> getCity() async {
    final isLoadingNotifier = ref.read(isLoadingProvider.notifier);
    final isLoading = ref.read(isLoadingProvider);

    try {
      final Dio dio = Dio();

      if (isLoading == false) {
        isLoadingNotifier.state = true;
        Response response = await dio.get('$BASE_URL/geo/1.0/direct?q=${cityController.text.trim()},USA&limit=1&appid=$WEATHER_API');
        if (response.statusCode == 200) {
          final data = List<dynamic>.from(response.data);
          if (data.isNotEmpty) {
            final city = City.fromMap(data.first);
            state = city;
            await weatherNotifier.getWeather(lat: city.lat, lon: city.lon);
          }
        }
      }
    } catch (e) {
      print(e);
    }

    isLoadingNotifier.state = false;
  }
}

class WeatherStateNotifier extends StateNotifier<Weather?> {
  WeatherStateNotifier() : super(null);

  Future<void> getWeather({required double lat, required double lon}) async {
    try {
      final Dio dio = Dio();
      Response response = await dio.get('$BASE_URL/data/2.5/weather?lat=$lat&lon=$lon&appid=$WEATHER_API');
      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        final weather = List<dynamic>.from(data["weather"]);

        if (weather.isNotEmpty) {
          final newWeather = Weather.fromMap(weather.first);
          state = newWeather.copyWith(
            dt: data["dt"],
            temp: data["main"]?["temp"],
          );

          print("weather is $state");
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
