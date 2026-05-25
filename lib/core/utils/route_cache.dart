class RouteCache {
  static final Map<String, dynamic> _cache = {};

  static dynamic get(String key) => _cache[key];

  static void set(String key, dynamic value) {
    _cache[key] = value;
  }
}
