enum PondStatus { normal, warning, critical }

class PondAlerts {
  static PondStatus getStatus(Map p) {
    final minDo = (p['min_do'] as num?)?.toDouble();
    final minPh = (p['min_ph'] as num?)?.toDouble();

    if (minDo != null && minDo < 3) return PondStatus.critical;
    if (minPh != null && (minPh < 6.5 || minPh > 8.5)) {
      return PondStatus.warning;
    }
    return PondStatus.normal;
  }

  static String label(Map p) {
    switch (getStatus(p)) {
      case PondStatus.critical:
        return "Critical";
      case PondStatus.warning:
        return "Warning";
      default:
        return "Healthy";
    }
  }

  static int color(Map p) {
    switch (getStatus(p)) {
      case PondStatus.critical:
        return 0xFFFF4D4F;
      case PondStatus.warning:
        return 0xFFFFA940;
      default:
        return 0xFF22C55E;
    }
  }
}
