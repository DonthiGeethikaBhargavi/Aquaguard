// lib/core/services/location_service.dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  Stream<Position> stream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }
}
