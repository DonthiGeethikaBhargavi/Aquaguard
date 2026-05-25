class AIThresholds {
  ////////////////////////////////////////////////////////////
  /// TEMPERATURE
  ////////////////////////////////////////////////////////////

  static const double tempMin = 20;
  static const double tempNormalMin = 26;
  static const double tempNormalMax = 30;
  static const double tempMax = 33;

  ////////////////////////////////////////////////////////////
  /// DISSOLVED OXYGEN
  ////////////////////////////////////////////////////////////

  static const double doMin = 3;
  static const double doNormalMin = 5;
  static const double doNormalMax = 7;
  static const double doMax = 10;

  ////////////////////////////////////////////////////////////
  /// PH
  ////////////////////////////////////////////////////////////

  static const double phMin = 7;
  static const double phNormalMin = 7.5;
  static const double phNormalMax = 8.5;
  static const double phMax = 8.8;

  ////////////////////////////////////////////////////////////
  /// WATER LEVEL
  ////////////////////////////////////////////////////////////

  static const double waterLevelMin = 20;
  static const double waterLevelNormalMin = 40;
  static const double waterLevelNormalMax = 88;
  static const double waterLevelMax = 100;

  ////////////////////////////////////////////////////////////
  /// HELPERS
  ////////////////////////////////////////////////////////////

  static double safeMin(String parameter) {
    switch (parameter) {
      case 'temperature':
        return tempMin;
      case 'dissolvedOxygen':
        return doMin;
      case 'ph':
        return phMin;
      case 'waterLevel':
        return waterLevelMin;
      default:
        return 0.0;
    }
  }

  static double safeMax(String parameter) {
    switch (parameter) {
      case 'temperature':
        return tempMax;
      case 'dissolvedOxygen':
        return doMax;
      case 'ph':
        return phMax;
      case 'waterLevel':
        return waterLevelMax;
      default:
        return 100.0;
    }
  }

  static double normalMin(String parameter) {
    switch (parameter) {
      case 'temperature':
        return tempNormalMin;
      case 'dissolvedOxygen':
        return doNormalMin;
      case 'ph':
        return phNormalMin;
      case 'waterLevel':
        return waterLevelNormalMin;
      default:
        return 0.0;
    }
  }

  static double normalMax(String parameter) {
    switch (parameter) {
      case 'temperature':
        return tempNormalMax;
      case 'dissolvedOxygen':
        return doNormalMax;
      case 'ph':
        return phNormalMax;
      case 'waterLevel':
        return waterLevelNormalMax;
      default:
        return 100.0;
    }
  }
}
