import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  ////////////////////////////////////////////////////////////
  /// INIT VALIDATION
  ////////////////////////////////////////////////////////////
  static void validate() {
    final missing = <String>[];

    if (!_has('SUPABASE_URL')) missing.add('SUPABASE_URL');
    if (!_has('SUPABASE_KEY')) missing.add('SUPABASE_KEY');
    if (!_has('WEATHER_API_KEY')) missing.add('WEATHER_API_KEY');

    if (missing.isNotEmpty) {
      throw Exception(
        '❌ Missing ENV keys: ${missing.join(', ')}\n'
        '👉 Check your assets/.env file',
      );
    }
  }

  ////////////////////////////////////////////////////////////
  /// GETTERS (SAFE ACCESS)
  ////////////////////////////////////////////////////////////
  static String get supabaseUrl => _get('SUPABASE_URL');
  static String get supabaseKey => _get('SUPABASE_KEY');
  static String get weatherApiKey => _get('WEATHER_API_KEY');

  ////////////////////////////////////////////////////////////
  /// INTERNAL HELPERS
  ////////////////////////////////////////////////////////////
  static String _get(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception('❌ ENV key "$key" is missing or empty');
    }
    return value;
  }

  static bool _has(String key) {
    final value = dotenv.env[key];
    return value != null && value.isNotEmpty;
  }
}
