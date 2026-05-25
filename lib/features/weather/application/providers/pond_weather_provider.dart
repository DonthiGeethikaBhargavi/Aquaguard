import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/weather_repository.dart';
import '../../domain/models/weather_model.dart';

final weatherRepoProvider = Provider((ref) => WeatherRepository());

final pondWeatherProvider =
    FutureProvider.family<WeatherModel, ({double lat, double lng})>((
      ref,
      coords,
    ) async {
      final repo = ref.read(weatherRepoProvider);

      return repo.getWeather(lat: coords.lat, lng: coords.lng);
    });
