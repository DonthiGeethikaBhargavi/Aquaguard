class Pond {
  final String id;
  final String name;
  final double? lat;
  final double? lng;

  Pond({required this.id, required this.name, this.lat, this.lng});
}

class Reading {
  final double? temp;
  final double? ph;
  final double? oxygen;
  final double? waterLevel;

  Reading({this.temp, this.ph, this.oxygen, this.waterLevel});
}

class PondWithReading {
  final Pond pond;
  final Reading? reading;

  PondWithReading({required this.pond, this.reading});
}
