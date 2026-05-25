////////////////////////////////////////////////////////////
/// CHART RANGE
////////////////////////////////////////////////////////////

enum ChartRange { hour, day, week, month, year }

////////////////////////////////////////////////////////////
/// EXTENSION
////////////////////////////////////////////////////////////

extension ChartRangeExtension on ChartRange {
  ////////////////////////////////////////////////////////////
  /// LABEL
  ////////////////////////////////////////////////////////////

  String get label {
    switch (this) {
      case ChartRange.hour:
        return '1H';

      case ChartRange.day:
        return '24H';

      case ChartRange.week:
        return '7D';

      case ChartRange.month:
        return '30D';

      case ChartRange.year:
        return '1Y';
    }
  }

  ////////////////////////////////////////////////////////////
  /// FULL LABEL
  ////////////////////////////////////////////////////////////

  String get fullLabel {
    switch (this) {
      case ChartRange.hour:
        return 'Last Hour';

      case ChartRange.day:
        return 'Last 24 Hours';

      case ChartRange.week:
        return 'Last 7 Days';

      case ChartRange.month:
        return 'Last 30 Days';

      case ChartRange.year:
        return 'Last 12 Months';
    }
  }

  ////////////////////////////////////////////////////////////
  /// API PARAM
  ////////////////////////////////////////////////////////////

  String get apiParam {
    switch (this) {
      case ChartRange.hour:
        return 'hour';

      case ChartRange.day:
        return 'day';

      case ChartRange.week:
        return 'week';

      case ChartRange.month:
        return 'month';

      case ChartRange.year:
        return 'year';
    }
  }

  ////////////////////////////////////////////////////////////
  /// REFRESH INTERVAL
  ////////////////////////////////////////////////////////////

  Duration get refreshInterval {
    switch (this) {
      case ChartRange.hour:
        return const Duration(seconds: 15);

      case ChartRange.day:
        return const Duration(minutes: 1);

      case ChartRange.week:
        return const Duration(minutes: 5);

      case ChartRange.month:
        return const Duration(minutes: 15);

      case ChartRange.year:
        return const Duration(hours: 1);
    }
  }

  ////////////////////////////////////////////////////////////
  /// MAX DATA POINTS
  ////////////////////////////////////////////////////////////

  int get maxDataPoints {
    switch (this) {
      case ChartRange.hour:
        return 120;

      case ChartRange.day:
        return 144;

      case ChartRange.week:
        return 168;

      case ChartRange.month:
        return 180;

      case ChartRange.year:
        return 365;
    }
  }

  ////////////////////////////////////////////////////////////
  /// CHART STEP
  ////////////////////////////////////////////////////////////

  Duration get aggregationStep {
    switch (this) {
      case ChartRange.hour:
        return const Duration(minutes: 1);

      case ChartRange.day:
        return const Duration(minutes: 10);

      case ChartRange.week:
        return const Duration(hours: 1);

      case ChartRange.month:
        return const Duration(hours: 4);

      case ChartRange.year:
        return const Duration(days: 1);
    }
  }

  ////////////////////////////////////////////////////////////
  /// START DATE
  ////////////////////////////////////////////////////////////

  DateTime get startDate {
    final now = DateTime.now();

    switch (this) {
      case ChartRange.hour:
        return now.subtract(const Duration(hours: 1));

      case ChartRange.day:
        return now.subtract(const Duration(days: 1));

      case ChartRange.week:
        return now.subtract(const Duration(days: 7));

      case ChartRange.month:
        return now.subtract(const Duration(days: 30));

      case ChartRange.year:
        return now.subtract(const Duration(days: 365));
    }
  }

  ////////////////////////////////////////////////////////////
  /// REALTIME
  ////////////////////////////////////////////////////////////

  bool get supportsRealtime {
    return this == ChartRange.hour || this == ChartRange.day;
  }

  ////////////////////////////////////////////////////////////
  /// HIGH DENSITY
  ////////////////////////////////////////////////////////////

  bool get isHighDensity {
    return this == ChartRange.hour || this == ChartRange.day;
  }
}
