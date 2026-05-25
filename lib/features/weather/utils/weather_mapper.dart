String getWeatherType(String condition) {
  if (condition.contains("Rain")) return "rain";
  if (condition.contains("Cloud")) return "cloud";
  if (condition.contains("Clear")) return "sun";
  return "default";
}
